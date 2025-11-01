import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'colors.dart';

class AnimatedAppIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color? color;
  final bool animate;
  final Duration delay;

  const AnimatedAppIcon({
    super.key,
    required this.icon,
    this.size = 24,
    this.color,
    this.animate = true,
    this.delay = Duration.zero,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? TurfitColors.primaryLight;

    Widget iconWidget = Icon(icon, size: size, color: iconColor);

    if (animate) {
      iconWidget = iconWidget
          .animate(delay: delay)
          .scale(duration: 300.ms, curve: Curves.elasticOut)
          .then()
          .shimmer(duration: 1500.ms, color: iconColor.withOpacity(0.3));
    }

    return iconWidget;
  }
}

// Enhanced icon mappings for kid-friendly visual appeal
class KidFriendlyIcons {
  // Food & Drinks
  static final Map<String, IconData> food = {
    'fastfood': Iconsax.cup,
    'local_pizza': PhosphorIcons.pizza(),
    'local_cafe': PhosphorIcons.coffee(),
    'emoji_food_beverage': Iconsax.coffee,
    'blender': PhosphorIcons.cookingPot(),
    'cookie': PhosphorIcons.cookie(),
    'icecream': PhosphorIcons.iceCream(),
    'local_drink': PhosphorIcons.wine(),
    'bolt': PhosphorIcons.lightning(),
    'storefront': PhosphorIcons.storefront(),
  };

  // Fashion & Style
  static final Map<String, IconData> fashion = {
    'checkroom': PhosphorIcons.hoodie(),
    'styler': PhosphorIcons.pants(),
    'emoji_people': PhosphorIcons.tShirt(),
    'directions_run': PhosphorIcons.sneaker(),
    'socks': PhosphorIcons.sock(),
    'ac_unit': PhosphorIcons.hoodie(),
    'fitness_center': PhosphorIcons.pants(),
    'backpack': PhosphorIcons.backpack(),
    'redeem': PhosphorIcons.baseballCap(),
    'wb_sunny': PhosphorIcons.sunglasses(),
  };

  // Tech & Gadgets
  static final Map<String, IconData> tech = {
    'smartphone': PhosphorIcons.deviceMobile(),
    'style': PhosphorIcons.deviceMobileCamera(),
    'headphones': PhosphorIcons.headphones(),
    'headset': PhosphorIcons.headset(),
    'speaker': PhosphorIcons.speakerHigh(),
    'laptop_mac': PhosphorIcons.laptop(),
    'tablet_mac': PhosphorIcons.deviceTablet(),
    'watch': PhosphorIcons.watch(),
    'battery_charging_full': PhosphorIcons.batteryCharging(),
    'power': PhosphorIcons.power(),
  };

  // Gaming
  static final Map<String, IconData> gaming = {
    'sports_esports': PhosphorIcons.gameController(),
    'stadia_controller': PhosphorIcons.gameController(),
    'gamepad': PhosphorIcons.gameController(),
    'headset_mic': PhosphorIcons.headset(),
    'phone_iphone': PhosphorIcons.deviceMobile(),
    'subscriptions': PhosphorIcons.crown(),
    'videogame_asset': PhosphorIcons.puzzlePiece(),
    'computer': PhosphorIcons.desktopTower(),
    'mouse': PhosphorIcons.mouse(),
    'local_mall': PhosphorIcons.shoppingBag(),
  };

  // Entertainment & Fun
  static final Map<String, IconData> entertainment = {
    'theaters': PhosphorIcons.filmStrip(),
    'music_video': PhosphorIcons.musicNote(),
    'sports': PhosphorIcons.football(),
    'mic': PhosphorIcons.microphone(),
    'menu_book': PhosphorIcons.book(),
    'extension': PhosphorIcons.puzzlePiece(),
    'celebration': PhosphorIcons.confetti(),
    'photo_camera': PhosphorIcons.camera(),
    'mic_none': PhosphorIcons.microphone(),
  };

  // School & Education
  static final Map<String, IconData> school = {
    'create': PhosphorIcons.pen(),
    'palette': PhosphorIcons.palette(),
    'event_note': PhosphorIcons.calendar(),
    'calculate': PhosphorIcons.calculator(),
    'print': PhosphorIcons.printer(),
    'door_front': PhosphorIcons.door(),
    'request_quote': PhosphorIcons.currencyDollar(),
    'biotech': PhosphorIcons.testTube(),
    'music_note': PhosphorIcons.musicNote(),
    'description': PhosphorIcons.fileText(),
  };

  // Get icon by name with fallback
  static IconData getIcon(String? iconName) {
    if (iconName == null || iconName.isEmpty) {
      return PhosphorIcons.star();
    }

    // Search through all categories
    for (final category in [
      food,
      fashion,
      tech,
      gaming,
      entertainment,
      school,
    ]) {
      if (category.containsKey(iconName)) {
        return category[iconName]!;
      }
    }

    // Fallback to default icon
    return PhosphorIcons.star();
  }

  // Get animated icon widget
  static Widget getAnimatedIcon(
    String? iconName, {
    double size = 24,
    Color? color,
    bool animate = true,
    Duration delay = Duration.zero,
  }) {
    return AnimatedAppIcon(
      icon: getIcon(iconName),
      size: size,
      color: color,
      animate: animate,
      delay: delay,
    );
  }
}

// Category icons for better navigation
class CategoryIcons {
  static final Map<String, IconData> categories = {
    'Food': PhosphorIcons.hamburger(),
    'Fashion': PhosphorIcons.tShirt(),
    'Tech': PhosphorIcons.deviceMobile(),
    'Gaming': PhosphorIcons.gameController(),
    'Subscription': PhosphorIcons.crown(),
    'Beauty': PhosphorIcons.sparkle(),
    'Entertainment': PhosphorIcons.filmStrip(),
    'School': PhosphorIcons.graduationCap(),
    'Sports': PhosphorIcons.football(),
    'Lifestyle': PhosphorIcons.heart(),
  };

  static IconData getCategoryIcon(String category) {
    return categories[category] ?? PhosphorIcons.star();
  }

  static Widget getAnimatedCategoryIcon(
    String category, {
    double size = 24,
    Color? color,
    bool animate = true,
    Duration delay = Duration.zero,
  }) {
    return AnimatedAppIcon(
      icon: getCategoryIcon(category),
      size: size,
      color: color,
      animate: animate,
      delay: delay,
    );
  }
}
