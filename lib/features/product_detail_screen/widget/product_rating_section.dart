import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class ProductRatingsSection extends StatelessWidget {
  final String productId;

  const ProductRatingsSection({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      // Simplified query to avoid composite index requirement
      stream: FirebaseFirestore.instance
          .collection('ratings')
          .where('productId', isEqualTo: productId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final ratings = snapshot.data?.docs ?? [];
        if (ratings.isEmpty) {
          return const SizedBox.shrink();
        }

        // Sort the ratings locally instead of in the query
        ratings.sort((a, b) {
          final aDate = (a.data() as Map<String, dynamic>)['createdAt'] as Timestamp;
          final bDate = (b.data() as Map<String, dynamic>)['createdAt'] as Timestamp;
          return bDate.compareTo(aDate); // Descending order
        });

        // Calculate average rating
        double totalRating = 0;
        for (var doc in ratings) {
          final data = doc.data() as Map<String, dynamic>;
          totalRating += (data['rating'] ?? 0).toDouble();
        }
        final averageRating = totalRating / ratings.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(height: 32),
            const Text(
              'Ratings & Reviews',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildRatingSummary(averageRating, ratings.length),
            const SizedBox(height: 24),
            _buildReviewsList(ratings),
          ],
        );
      },
    );
  }

  Widget _buildRatingSummary(double averageRating, int totalReviews) {
    return Row(
      children: [
        Column(
          children: [
            Text(
              averageRating.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            RatingBar.builder(
              initialRating: averageRating,
              ignoreGestures: true,
              direction: Axis.horizontal,
              itemCount: 5,
              itemSize: 20,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (_) {},
            ),
            const SizedBox(height: 8),
            Text(
              '$totalReviews ${totalReviews == 1 ? 'Review' : 'Reviews'}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReviewsList(List<QueryDocumentSnapshot> reviews) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reviews.length,
      separatorBuilder: (context, index) => const Divider(height: 32),
      itemBuilder: (context, index) {
        final review = reviews[index].data() as Map<String, dynamic>;
        final rating = (review['rating'] ?? 0).toDouble();
        final reviewText = review['review'] as String? ?? '';
        final createdAt = (review['createdAt'] as Timestamp).toDate();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                RatingBar.builder(
                  initialRating: rating,
                  ignoreGestures: true,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  itemSize: 16,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (_) {},
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormat('MMM dd, yyyy').format(createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            if (reviewText.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                reviewText,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ],
        );
      },
    );
  }
}