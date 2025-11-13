import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../utils/permission_manager.dart';

class PhotoService {
  static final ImagePicker _picker = ImagePicker();

  static Future<List<String>> pickImages({
    int maxImages = 5,
    BuildContext? context,
  }) async {
    try {
      final hasPermission = await PermissionManager.requestStoragePermissions(context);
      if (!hasPermission) return [];

      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 70,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (images.isEmpty) return [];

      // Limit to maxImages
      final limitedImages = images.take(maxImages).toList();

      // Save images to app directory
      final savedPaths = <String>[];
      for (final image in limitedImages) {
        final savedPath = await _saveImageToAppDirectory(File(image.path));
        if (savedPath != null) {
          savedPaths.add(savedPath);
        }
      }

      return savedPaths;
    } catch (e) {
      print('Error picking images: $e');
      return [];
    }
  }

  static Future<String?> pickImageFromCamera({BuildContext? context}) async {
    try {
      final hasPermission = await PermissionManager.requestCameraPermissions();
      if (!hasPermission) return null;

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image == null) return null;

      return await _saveImageToAppDirectory(File(image.path));
    } catch (e) {
      print('Error taking photo: $e');
      return null;
    }
  }

  static Future<String?> pickImageFromGallery({BuildContext? context}) async {
    try {
      final hasPermission = await PermissionManager.requestStoragePermissions(context);
      if (!hasPermission) return null;

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image == null) return null;

      return await _saveImageToAppDirectory(File(image.path));
    } catch (e) {
      print('Error picking image from gallery: $e');
      return null;
    }
  }

  static Future<String?> _saveImageToAppDirectory(File imageFile) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory(path.join(appDir.path, 'transaction_images'));

      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${path.basename(imageFile.path)}';
      final savedFile = File(path.join(imagesDir.path, fileName));

      await imageFile.copy(savedFile.path);
      return savedFile.path;
    } catch (e) {
      print('Error saving image: $e');
      return null;
    }
  }

  static Future<bool> deleteImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting image: $e');
      return false;
    }
  }

  static Future<void> deleteImages(List<String> imagePaths) async {
    for (final imagePath in imagePaths) {
      await deleteImage(imagePath);
    }
  }

  static Future<void> cleanupOldImages({int daysOld = 30}) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory(path.join(appDir.path, 'transaction_images'));

      if (!await imagesDir.exists()) return;

      final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));
      final files = await imagesDir.list().toList();

      for (final entity in files) {
        if (entity is File) {
          final stat = await entity.stat();
          if (stat.modified.isBefore(cutoffDate)) {
            await entity.delete();
          }
        }
      }
    } catch (e) {
      print('Error cleaning up old images: $e');
    }
  }
}
