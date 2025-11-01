import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

class TapTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final IconData? leadingIcon;
  final Color? leadingBg;
  final Widget? trailing;

  const TapTile({
    super.key,
    required this.title,
    this.subtitle,
    this.onTap,
    this.leadingIcon,
    this.leadingBg,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    return Bounceable(
      onTap: onTap ?? () {},
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (leadingIcon != null)
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color:
                        leadingBg ??
                        theme.colorScheme.secondary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(leadingIcon, color: theme.colorScheme.primary),
                ),
              if (leadingIcon != null) const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle != null && subtitle!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 12),
                trailing!,
              ] else ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right_rounded,
                  color: onSurface.withOpacity(0.5),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
