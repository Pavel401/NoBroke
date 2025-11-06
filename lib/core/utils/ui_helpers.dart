import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class UIHelpers {
  /// Shows a Material Design snackbar with consistent styling
  static void showSnackbar(
    BuildContext context, {
    required String message,
    SnackbarType type = SnackbarType.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    Color backgroundColor;
    Color textColor = AppTheme.primaryWhite;
    IconData? icon;

    switch (type) {
      case SnackbarType.success:
        backgroundColor = AppTheme.successGreen;
        icon = Icons.check_circle_outline;
        break;
      case SnackbarType.error:
        backgroundColor = AppTheme.errorRed;
        icon = Icons.error_outline;
        break;
      case SnackbarType.warning:
        backgroundColor = Colors.orange.shade700;
        icon = Icons.warning_amber_outlined;
        break;
      case SnackbarType.info:
        backgroundColor = AppTheme.primaryBlack;
        icon = Icons.info_outline;
        break;
    }

    final snackbar = SnackBar(
      content: Row(
        children: [
          Icon(icon, color: textColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.all(16),
      action: actionLabel != null && onActionPressed != null
          ? SnackBarAction(
              label: actionLabel,
              textColor: textColor,
              onPressed: onActionPressed,
            )
          : null,
    );

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  /// Shows a Material Design confirmation dialog
  static Future<bool?> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String content,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDangerous = false,
    Widget? icon,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              if (icon != null) ...[icon, const SizedBox(width: 12)],
              Expanded(child: Text(title)),
            ],
          ),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                cancelText,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDangerous
                    ? AppTheme.errorRed
                    : AppTheme.primaryBlack,
                foregroundColor: AppTheme.primaryWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }

  /// Shows a Material Design loading dialog
  static void showLoadingDialog(
    BuildContext context, {
    String message = 'Loading...',
    bool barrierDismissible = false,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Row(
            children: [
              const CircularProgressIndicator(color: AppTheme.primaryBlack),
              const SizedBox(width: 20),
              Expanded(child: Text(message)),
            ],
          ),
        );
      },
    );
  }

  /// Closes any open dialogs
  static void closeDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  /// Shows a Material Design info dialog
  static Future<void> showInfoDialog(
    BuildContext context, {
    required String title,
    required Widget content,
    String closeText = 'Close',
    List<Widget>? additionalActions,
  }) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(title),
          content: content,
          actions: [
            ...?additionalActions,
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(closeText),
            ),
          ],
        );
      },
    );
  }
}

enum SnackbarType { success, error, warning, info }
