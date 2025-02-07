import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edicion_limitada/features/order/model/order_model.dart';
import 'package:edicion_limitada/features/order/model/order_view_model.dart';
import 'package:edicion_limitada/features/order/view/order_detail_screen.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrderViewModel(),
      child: const OrderScreenContent(),
    );
  }
}

class OrderScreenContent extends StatefulWidget {
  const OrderScreenContent({Key? key}) : super(key: key);

  @override
  State<OrderScreenContent> createState() => _OrderScreenContentState();
}

class _OrderScreenContentState extends State<OrderScreenContent> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<OrderViewModel>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
      
        title: const Text(
          'My Order',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Text(
                'Pending',
                style: TextStyle(color: Colors.amber[700]),
              ),
            ),
            Tab(
              child: Text(
                'Delivered',
                style: TextStyle(color: Colors.green[700]),
              ),
            ),
            Tab(
              child: Text(
                'Cancelled',
                style: TextStyle(color: Colors.red[700]),
              ),
            ),
          ],
          indicatorColor: Colors.transparent,
          labelStyle: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _OrderList(status: 'pending'),
          _OrderList(status: 'delivered'),
          _OrderList(status: 'cancelled'),
        ],
      ),
    );
  }
}


class _OrderList extends StatelessWidget {
  final String status;

  const _OrderList({required this.status});

  bool _belongsToStatus(String orderStatus, String tabStatus) {
    switch (tabStatus.toLowerCase()) {
      case 'pending':
        // Include orders that are pending, processing, or shipped
        return orderStatus.toLowerCase() == 'pending' ||
               orderStatus.toLowerCase() == 'processing' ||
               orderStatus.toLowerCase() == 'shipped';
      case 'delivered':
        return orderStatus.toLowerCase() == 'delivered';
      case 'cancelled':
        return orderStatus.toLowerCase() == 'cancelled';
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderViewModel = Provider.of<OrderViewModel>(context, listen: false);

    return StreamBuilder<List<OrderModel>>(
      stream: orderViewModel.getOrdersStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'No ${status.toLowerCase()} orders',
              style: TextStyle(color: Colors.grey[600]),
            ),
          );
        }

        final filteredOrders = snapshot.data!
            .where((order) => _belongsToStatus(order.status, status))
            .toList();

        if (filteredOrders.isEmpty) {
          return Center(
            child: Text(
              'No ${status.toLowerCase()} orders',
              style: TextStyle(color: Colors.grey[600]),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filteredOrders.length,
          itemBuilder: (context, index) {
            return _OrderCard(
              order: filteredOrders[index],
              viewModel: orderViewModel,
            );
          },
        );
      },
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  final OrderViewModel viewModel;

  const _OrderCard({
    required this.order,
    required this.viewModel,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'processing':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.orange; // For pending
    }
  }

  bool get _canCancel {
    final status = order.status.toLowerCase();
    return status == 'pending' || status == 'processing';
    // Note: Usually we don't allow cancellation after shipping
  }

  void _showCancellationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(
          'Cancel Order',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to cancel this order? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('No, Keep Order'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await viewModel.cancelOrder(context, order);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text(
              'Yes, Cancel Order',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      elevation: 0,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailScreen(
                order: order,
                item: order.items.first,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  base64Decode(order.items.first.imageUrl),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(order.status),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        order.status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      order.items.first.productName,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₹${order.items.first.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                         if (_canCancel)
                      SizedBox(
                        height: 29,
                        child: TextButton(
                          onPressed: () => _showCancellationDialog(context),
                          style: TextButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 151, 144, 144),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: Center(
                            child: const Text(
                              'CANCEL',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}