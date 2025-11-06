import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
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

  static Future<bool> requestStoragePermissions() async {
    try {
      final status = await Permission.storage.request();
      return status == PermissionStatus.granted;
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
