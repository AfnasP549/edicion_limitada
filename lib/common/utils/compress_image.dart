//!image compresser
import 'dart:convert';
import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<String> compressImage(String imagePath) async {
    try {
      final file = File(imagePath);
      final bytes = await file.readAsBytes();
      
      // Calculate compression quality based on file size
      int quality = 100;
      int maxSize = 500 * 1024; // 500KB target size
      
      if (bytes.length > maxSize) {
        quality = ((maxSize / bytes.length) * 100).round();
        quality = quality.clamp(1, 100); // Ensure quality is between 1 and 100
      }
      final compressedImage = await FlutterImageCompress.compressWithFile(
        imagePath,
        minWidth: 1024,
        minHeight: 1024,
        quality: quality,
        rotate: 0,
      );

      if (compressedImage == null) {
        throw 'Compression failed: null result';
      }

      // Check if the compressed size is still too large
      if (compressedImage.length > maxSize) {
        // Try another round of compression with lower quality
        final secondPassQuality = (quality * 0.7).round(); // 70% of original quality
        final secondCompression = await FlutterImageCompress.compressWithFile(
          imagePath,
          minWidth: 800, // Smaller dimensions
          minHeight: 800,
          quality: secondPassQuality,
          rotate: 0,
        );

        if (secondCompression != null) {
          return base64Encode(secondCompression);
        }
      }

      return base64Encode(compressedImage);
    } catch (e) {
      throw 'Failed to compress image: $e';
    }
  }
  