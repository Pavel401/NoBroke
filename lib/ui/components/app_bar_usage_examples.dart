/*
Kid-Friendly Responsive App Bar Usage Examples

The KidFriendlyAppBar component is designed to be responsive and adapts to:
- Different screen sizes (compact layout for small screens)
- Orientation changes (landscape vs portrait)
- Various content requirements

Here are examples of how to use it:

1. Basic Usage (like in home_screen.dart):
```dart
appBar: KidFriendlyAppBar(
  title: '💰 Your Smart Savings',
  subtitle: 'See how much your "what-ifs" could grow! 🌱',
  trailing: StreakBadge(streakCount: 5, label: ''),
),
```

2. With Back Button:
```dart
appBar: KidFriendlyAppBar(
  title: '📊 Investment Details',
  subtitle: 'Track your growth over time',
  showBackButton: true,
  onBackPressed: () => Navigator.pop(context),
),
```

3. With Menu and Notifications:
```dart
appBar: KidFriendlyAppBar(
  title: '🎯 Goals Dashboard',
  subtitle: 'Reach for the stars!',
  onMenuTap: () => _openDrawer(),
  onNotificationTap: () => _showNotifications(),
  notificationCount: 3,
),
```

4. Simple App Bar (Alternative):
```dart
appBar: SimpleKidAppBar(
  title: 'Settings',
  actions: [
    IconButton(
      icon: Icon(Icons.help_outline),
      onPressed: () => _showHelp(),
    ),
  ],
),
```

Key Features:
- Responsive layout that adapts to screen width
- Kid-friendly gradient backgrounds
- Smooth animations and haptic feedback
- Support for custom trailing widgets
- Notification badges with animation
- Automatic text overflow handling
- Proper Material Design compliance

Screen Size Adaptations:
- < 400px width: Compact layout with title/subtitle stacked
- ≥ 400px width: Standard layout with side-by-side content
- Landscape mode: Reduced height and padding
- Portrait mode: Full height with more padding

The app bar automatically handles:
- Text overflow with ellipsis
- Dynamic sizing based on content
- Proper safe area handling
- Material Design elevation and shadows
- Kid-friendly color schemes and typography
*/
