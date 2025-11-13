import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'ui_helpers.dart';

class PermissionManager {
  static Future<bool> requestSmsPermissions([BuildContext? context]) async {
    try {
      final status = await Permission.sms.request();

      if (status == PermissionStatus.granted) {
        return true;
      } else if (status == PermissionStatus.denied) {
        if (context != null) {
          UIHelpers.showSnackbar(
            context,
            message:
                'SMS permission is required to read banking messages. You can enable it manually in settings.',
            type: SnackbarType.warning,
            duration: const Duration(seconds: 5),
          );
        }
        return false;
      } else if (status == PermissionStatus.permanentlyDenied) {
        if (context != null) {
          UIHelpers.showSnackbar(
            context,
            message:
                'Please enable SMS permission in app settings to read banking messages.',
            type: SnackbarType.warning,
            duration: const Duration(seconds: 5),
          );
        }
        await openAppSettings();
        return false;
      }

      return false;
    } catch (e) {
      print('Error requesting SMS permission: $e');
      return false;
    }
  }

  static Future<bool> checkSmsPermission() async {
    try {
      final status = await Permission.sms.status;
      return status == PermissionStatus.granted;
    } catch (e) {
      print('Error checking SMS permission: $e');
      return false;
    }
  }

  static Future<bool> requestStoragePermissions([BuildContext? context]) async {
    try {
      PermissionStatus status;
      
      // For Android 13+ (API 33+), use photos permission
      // For older versions, use storage permission
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt >= 33) {
          // Android 13+ requires photos permission
          status = await Permission.photos.request();
        } else {
          // Android 12 and below use storage permission
          status = await Permission.storage.request();
        }
      } else if (Platform.isIOS) {
        // iOS uses photos permission
        status = await Permission.photos.request();
      } else {
        return false;
      }

      if (status == PermissionStatus.granted) {
        return true;
      } else if (status == PermissionStatus.denied) {
        if (context != null) {
          UIHelpers.showSnackbar(
            context,
            message:
                'Photo permission is required to attach images. You can enable it manually in settings.',
            type: SnackbarType.warning,
            duration: const Duration(seconds: 5),
          );
        }
        return false;
      } else if (status == PermissionStatus.permanentlyDenied) {
        if (context != null) {
          UIHelpers.showSnackbar(
            context,
            message:
                'Please enable photo permission in app settings to attach images.',
            type: SnackbarType.warning,
            duration: const Duration(seconds: 5),
          );
        }
        await openAppSettings();
        return false;
      }
      
      return false;
    } catch (e) {
      print('Error requesting storage permission: $e');
      return false;
    }
  }

  static Future<bool> requestCameraPermissions() async {
    try {
      final status = await Permission.camera.request();
      return status == PermissionStatus.granted;
    } catch (e) {
      print('Error requesting camera permission: $e');
      return false;
    }
  }

  static Future<Map<Permission, PermissionStatus>> requestMultiplePermissions(
    List<Permission> permissions,
  ) async {
    try {
      return await permissions.request();
    } catch (e) {
      print('Error requesting multiple permissions: $e');
      return {};
    }
  }
}
