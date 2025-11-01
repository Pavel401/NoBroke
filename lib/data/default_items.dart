import 'package:drift/drift.dart';

import '../db/app_db.dart';

// Raw seed data from user. First batch: main items with icon + description
const List<Map<String, dynamic>> _seedBatchA = [
  {
    "name": "Burger Meal",
    "category": "Food",
    "icon": "fastfood",
    "description": "A quick bite from your favorite fast-food spot.",
  },
  {
    "name": "Pizza Slice",
    "category": "Food",
    "icon": "local_pizza",
    "description": "Cheesy and delicious comfort food.",
  },
  {
    "name": "Iced Coffee",
    "category": "Food",
    "icon": "local_cafe",
    "description": "Chilled caffeine for study or chill days.",
  },
  {
    "name": "Bubble Tea",
    "category": "Food",
    "icon": "emoji_food_beverage",
    "description": "Sweet milk tea with chewy tapioca pearls.",
  },
  {
    "name": "Smoothie",
    "category": "Food",
    "icon": "blender",
    "description": "Fruit-filled drink for an energy boost.",
  },
  {
    "name": "Snack Pack",
    "category": "Food",
    "icon": "cookie",
    "description": "Chips, candy, or your favorite treats.",
  },
  {
    "name": "Frozen Yogurt",
    "category": "Food",
    "icon": "icecream",
    "description": "Cool dessert with fun toppings.",
  },
  {
    "name": "Fountain Drink",
    "category": "Food",
    "icon": "local_drink",
    "description": "Grab a soda or slushie on the go.",
  },
  {
    "name": "Energy Drink",
    "category": "Food",
    "icon": "bolt",
    "description": "Extra boost before exams or games.",
  },
  {
    "name": "Convenience Snack",
    "category": "Food",
    "icon": "storefront",
    "description": "Hot pretzels or rolls from the local store.",
  },

  {
    "name": "Hoodie",
    "category": "Fashion",
    "icon": "checkroom",
    "description": "Comfy oversized hoodie for daily wear.",
  },
  {
    "name": "Jeans",
    "category": "Fashion",
    "icon": "styler",
    "description": "Classic denim for school or hangouts.",
  },
  {
    "name": "Graphic Tee",
    "category": "Fashion",
    "icon": "emoji_people",
    "description": "T-shirts with cool prints or logos.",
  },
  {
    "name": "Sneakers",
    "category": "Fashion",
    "icon": "directions_run",
    "description": "Stylish kicks for every outfit.",
  },
  {
    "name": "Socks Pack",
    "category": "Fashion",
    "icon": "socks",
    "description": "Colorful or branded socks to match shoes.",
  },
  {
    "name": "Jacket",
    "category": "Fashion",
    "icon": "ac_unit",
    "description": "Windbreaker or puffer for cold days.",
  },
  {
    "name": "Leggings",
    "category": "Fashion",
    "icon": "fitness_center",
    "description": "Comfortable and sporty stretch wear.",
  },
  {
    "name": "Backpack",
    "category": "Fashion",
    "icon": "backpack",
    "description": "Carry your essentials in style.",
  },
  {
    "name": "Cap or Beanie",
    "category": "Fashion",
    "icon": "redeem",
    "description": "Headwear that adds instant cool.",
  },
  {
    "name": "Sunglasses",
    "category": "Fashion",
    "icon": "wb_sunny",
    "description": "Protect your eyes and look trendy.",
  },

  {
    "name": "Smartphone",
    "category": "Tech",
    "icon": "smartphone",
    "description": "Your all-in-one communication hub.",
  },
  {
    "name": "Phone Case",
    "category": "Tech",
    "icon": "style",
    "description": "Protect your phone with style.",
  },
  {
    "name": "Wireless Earbuds",
    "category": "Tech",
    "icon": "headphones",
    "description": "Listen to music and podcasts wire-free.",
  },
  {
    "name": "Headphones",
    "category": "Tech",
    "icon": "headset",
    "description": "For deep focus or gaming sessions.",
  },
  {
    "name": "Bluetooth Speaker",
    "category": "Tech",
    "icon": "speaker",
    "description": "Portable sound for hangouts.",
  },
  {
    "name": "Laptop",
    "category": "Tech",
    "icon": "laptop_mac",
    "description": "Essential for schoolwork or creative projects.",
  },
  {
    "name": "Tablet",
    "category": "Tech",
    "icon": "tablet_mac",
    "description": "For reading, drawing, or streaming.",
  },
  {
    "name": "Smartwatch",
    "category": "Tech",
    "icon": "watch",
    "description": "Tracks steps, sleep, and messages.",
  },
  {
    "name": "Power Bank",
    "category": "Tech",
    "icon": "battery_charging_full",
    "description": "Never run out of battery on the go.",
  },
  {
    "name": "Charger Cable",
    "category": "Tech",
    "icon": "power",
    "description": "Extra cables for phone or laptop.",
  },

  {
    "name": "In-Game Skins",
    "category": "Gaming",
    "icon": "sports_esports",
    "description": "Customize your avatar or gear.",
  },
  {
    "name": "Console Game",
    "category": "Gaming",
    "icon": "stadia_controller",
    "description": "Play the latest PS or Xbox hit.",
  },
  {
    "name": "Controller",
    "category": "Gaming",
    "icon": "gamepad",
    "description": "Extra controller for multiplayer fun.",
  },
  {
    "name": "Gaming Headset",
    "category": "Gaming",
    "icon": "headset_mic",
    "description": "Crystal-clear sound while gaming.",
  },
  {
    "name": "Mobile Game Pass",
    "category": "Gaming",
    "icon": "phone_iphone",
    "description": "Unlock levels or premium access.",
  },
  {
    "name": "Game Subscription",
    "category": "Gaming",
    "icon": "subscriptions",
    "description": "Monthly access to favorite games.",
  },
  {
    "name": "Roblox Premium",
    "category": "Gaming",
    "icon": "videogame_asset",
    "description": "More Robux and perks each month.",
  },
  {
    "name": "Steam Purchase",
    "category": "Gaming",
    "icon": "computer",
    "description": "Buy new PC games or DLCs.",
  },
  {
    "name": "Gaming Mouse",
    "category": "Gaming",
    "icon": "mouse",
    "description": "Fast clicks and RGB lights!",
  },
  {
    "name": "Game Merchandise",
    "category": "Gaming",
    "icon": "local_mall",
    "description": "Show off your favorite game.",
  },

  {
    "name": "Music Subscription",
    "category": "Subscription",
    "icon": "music_note",
    "description": "Spotify, Apple Music, or similar.",
  },
  {
    "name": "Streaming Service",
    "category": "Subscription",
    "icon": "movie",
    "description": "Netflix, Disney+, or YouTube Premium.",
  },
  {
    "name": "Phone Data Top-Up",
    "category": "Subscription",
    "icon": "signal_cellular_alt",
    "description": "Extra data for your plan.",
  },
  {
    "name": "Cloud Storage",
    "category": "Subscription",
    "icon": "cloud",
    "description": "Save files and photos securely.",
  },
  {
    "name": "Fitness Class",
    "category": "Subscription",
    "icon": "self_improvement",
    "description": "Dance, yoga, or gym sessions.",
  },
  {
    "name": "Social App Premium",
    "category": "Subscription",
    "icon": "chat",
    "description": "Extra perks on Snapchat or BeReal.",
  },
  {
    "name": "Magazine Subscription",
    "category": "Subscription",
    "icon": "library_books",
    "description": "Fashion, gaming, or hobby reads.",
  },
  {
    "name": "Learning App",
    "category": "Subscription",
    "icon": "school",
    "description": "Skill or coding app membership.",
  },
  {
    "name": "Music Lessons",
    "category": "Subscription",
    "icon": "piano",
    "description": "Online or in-person lessons.",
  },
  {
    "name": "VPN App",
    "category": "Subscription",
    "icon": "security",
    "description": "Keep your browsing private.",
  },

  {
    "name": "Skincare",
    "category": "Beauty",
    "icon": "spa",
    "description": "Face wash, moisturizer, or serum.",
  },
  {
    "name": "Acne Treatment",
    "category": "Beauty",
    "icon": "healing",
    "description": "Keep your skin clear and fresh.",
  },
  {
    "name": "Makeup Kit",
    "category": "Beauty",
    "icon": "brush",
    "description": "Foundation, mascara, and more.",
  },
  {
    "name": "Lip Balm",
    "category": "Beauty",
    "icon": "favorite",
    "description": "For smooth, hydrated lips.",
  },
  {
    "name": "Perfume or Cologne",
    "category": "Beauty",
    "icon": "emoji_nature",
    "description": "Smell good, feel confident.",
  },
  {
    "name": "Hair Product",
    "category": "Beauty",
    "icon": "content_cut",
    "description": "Shampoo, gel, or styling spray.",
  },
  {
    "name": "Nail Polish",
    "category": "Beauty",
    "icon": "color_lens",
    "description": "Paint or design your nails.",
  },
  {
    "name": "Haircut",
    "category": "Beauty",
    "icon": "cut",
    "description": "Fresh look for the season.",
  },
  {
    "name": "Sunscreen",
    "category": "Beauty",
    "icon": "light_mode",
    "description": "Protect your skin outdoors.",
  },
  {
    "name": "Toothcare",
    "category": "Beauty",
    "icon": "health_and_safety",
    "description": "Electric brush or whitening kit.",
  },

  {
    "name": "Movie Ticket",
    "category": "Entertainment",
    "icon": "theaters",
    "description": "Catch the latest film with friends.",
  },
  {
    "name": "Concert Ticket",
    "category": "Entertainment",
    "icon": "music_video",
    "description": "See your favorite artist live.",
  },
  {
    "name": "Arcade Visit",
    "category": "Entertainment",
    "icon": "sports_esports",
    "description": "Play games and win prizes.",
  },
  {
    "name": "Bowling Night",
    "category": "Entertainment",
    "icon": "sports",
    "description": "Fun weekend hangout.",
  },
  {
    "name": "Band Merch",
    "category": "Entertainment",
    "icon": "mic",
    "description": "Shirts and posters of your favorite band.",
  },
  {
    "name": "Comic Book",
    "category": "Entertainment",
    "icon": "menu_book",
    "description": "Stories and manga collections.",
  },
  {
    "name": "Board Game",
    "category": "Entertainment",
    "icon": "extension",
    "description": "Play with family or friends.",
  },
  {
    "name": "Festival Entry",
    "category": "Entertainment",
    "icon": "celebration",
    "description": "Music or local art events.",
  },
  {
    "name": "Photo Prints",
    "category": "Entertainment",
    "icon": "photo_camera",
    "description": "Capture and print memories.",
  },
  {
    "name": "Karaoke Night",
    "category": "Entertainment",
    "icon": "mic_none",
    "description": "Sing your heart out!",
  },

  {
    "name": "Stationery Set",
    "category": "School",
    "icon": "create",
    "description": "Pens, notebooks, and stickers.",
  },
  {
    "name": "Art Supplies",
    "category": "School",
    "icon": "palette",
    "description": "Sketchbooks and colors.",
  },
  {
    "name": "Planner",
    "category": "School",
    "icon": "event_note",
    "description": "Stay organized and productive.",
  },
  {
    "name": "Calculator",
    "category": "School",
    "icon": "calculate",
    "description": "For math and science homework.",
  },
  {
    "name": "Printer Ink",
    "category": "School",
    "icon": "print",
    "description": "For school reports and projects.",
  },
  {
    "name": "Locker Decor",
    "category": "School",
    "icon": "door_front",
    "description": "Customize your locker style.",
  },
  {
    "name": "Application Fee",
    "category": "School",
    "icon": "request_quote",
    "description": "College or contest fees.",
  },
  {
    "name": "Science Kit",
    "category": "School",
    "icon": "biotech",
    "description": "DIY experiments for fun learning.",
  },
  {
    "name": "Instrument Strings",
    "category": "School",
    "icon": "music_note",
    "description": "Replace or upgrade your guitar strings.",
  },
  {
    "name": "Paper Ream",
    "category": "School",
    "icon": "description",
    "description": "For notes, projects, and doodles.",
  },

  {
    "name": "Sports Shoes",
    "category": "Sports",
    "icon": "directions_run",
    "description": "Shoes built for performance.",
  },
  {
    "name": "Basketball",
    "category": "Sports",
    "icon": "sports_basketball",
    "description": "For pickup games at the park.",
  },
  {
    "name": "Gym Membership",
    "category": "Sports",
    "icon": "fitness_center",
    "description": "Stay active and healthy.",
  },
  {
    "name": "Skateboard",
    "category": "Sports",
    "icon": "snowboarding",
    "description": "Cruise or practice tricks.",
  },
  {
    "name": "Bike Helmet",
    "category": "Sports",
    "icon": "pedal_bike",
    "description": "Safety gear for biking.",
  },
  {
    "name": "Water Bottle",
    "category": "Sports",
    "icon": "water_drop",
    "description": "Reusable and eco-friendly.",
  },
  {
    "name": "Yoga Mat",
    "category": "Sports",
    "icon": "self_improvement",
    "description": "For stretching or meditation.",
  },
  {
    "name": "Team Jersey",
    "category": "Sports",
    "icon": "sports_soccer",
    "description": "Support your favorite team.",
  },
  {
    "name": "Camping Gear",
    "category": "Sports",
    "icon": "hiking",
    "description": "Outdoor adventures await.",
  },
  {
    "name": "Swim Goggles",
    "category": "Sports",
    "icon": "pool",
    "description": "Perfect for pool practice.",
  },

  {
    "name": "Bus Pass",
    "category": "Lifestyle",
    "icon": "directions_bus",
    "description": "Get around town easily.",
  },
  {
    "name": "Rideshare",
    "category": "Lifestyle",
    "icon": "local_taxi",
    "description": "Quick trip with Uber or Lyft.",
  },
  {
    "name": "Gift Card",
    "category": "Lifestyle",
    "icon": "card_giftcard",
    "description": "Spend anywhere, anytime.",
  },
  {
    "name": "Phone Lens",
    "category": "Lifestyle",
    "icon": "photo_camera_front",
    "description": "Snap better photos.",
  },
  {
    "name": "Room Decor",
    "category": "Lifestyle",
    "icon": "bedroom_child",
    "description": "LED lights, posters, or wall art.",
  },
  {
    "name": "Jewelry",
    "category": "Lifestyle",
    "icon": "diamond",
    "description": "Personalized rings or necklaces.",
  },
  {
    "name": "Thrift Find",
    "category": "Lifestyle",
    "icon": "shopping_bag",
    "description": "Unique pieces from resale shops.",
  },
  {
    "name": "Pet Supplies",
    "category": "Lifestyle",
    "icon": "pets",
    "description": "Treats, toys, or pet care items.",
  },
  {
    "name": "Charity Donation",
    "category": "Lifestyle",
    "icon": "volunteer_activism",
    "description": "Support a cause you care about.",
  },
  {
    "name": "Savings Deposit",
    "category": "Lifestyle",
    "icon": "savings",
    "description": "Add to your savings or investment jar.",
  },
];

// Second batch with kidSpecific flags for overlapping subset
const List<Map<String, dynamic>> _seedBatchB = [
  {
    "name": "Burger Meal",
    "category": "Food",
    "kidSpecific": false,
    "icon": "fastfood",
    "description": "A quick bite from your favorite fast-food spot.",
  },
  {
    "name": "Pizza Slice",
    "category": "Food",
    "kidSpecific": false,
    "icon": "local_pizza",
    "description": "Cheesy and delicious comfort food.",
  },
  {
    "name": "Iced Coffee",
    "category": "Food",
    "kidSpecific": false,
    "icon": "local_cafe",
    "description": "Chilled caffeine for study or chill days.",
  },
  {
    "name": "Bubble Tea",
    "category": "Food",
    "kidSpecific": false,
    "icon": "emoji_food_beverage",
    "description": "Sweet milk tea with chewy tapioca pearls.",
  },
  {
    "name": "Smoothie",
    "category": "Food",
    "kidSpecific": true,
    "icon": "blender",
    "description": "Fruit-filled drink for an energy boost.",
  },
  {
    "name": "Snack Pack",
    "category": "Food",
    "kidSpecific": true,
    "icon": "cookie",
    "description": "Chips, candy, or your favorite treats.",
  },
  {
    "name": "Frozen Yogurt",
    "category": "Food",
    "kidSpecific": true,
    "icon": "icecream",
    "description": "Cool dessert with fun toppings.",
  },
  {
    "name": "Fountain Drink",
    "category": "Food",
    "kidSpecific": true,
    "icon": "local_drink",
    "description": "Grab a soda or slushie on the go.",
  },
  {
    "name": "Energy Drink",
    "category": "Food",
    "kidSpecific": false,
    "icon": "bolt",
    "description": "Extra boost before exams or games.",
  },
  {
    "name": "Convenience Snack",
    "category": "Food",
    "kidSpecific": true,
    "icon": "storefront",
    "description": "Hot pretzels or rolls from the local store.",
  },
  {
    "name": "Hoodie",
    "category": "Fashion",
    "kidSpecific": false,
    "icon": "checkroom",
    "description": "Comfy oversized hoodie for daily wear.",
  },
  {
    "name": "Jeans",
    "category": "Fashion",
    "kidSpecific": false,
    "icon": "styler",
    "description": "Classic denim for school or hangouts.",
  },
  {
    "name": "Graphic Tee",
    "category": "Fashion",
    "kidSpecific": true,
    "icon": "emoji_people",
    "description": "T-shirts with cool prints or logos.",
  },
  {
    "name": "Sneakers",
    "category": "Fashion",
    "kidSpecific": false,
    "icon": "directions_run",
    "description": "Stylish kicks for every outfit.",
  },
  {
    "name": "Socks Pack",
    "category": "Fashion",
    "kidSpecific": true,
    "icon": "socks",
    "description": "Colorful or branded socks to match shoes.",
  },
  {
    "name": "Jacket",
    "category": "Fashion",
    "kidSpecific": false,
    "icon": "ac_unit",
    "description": "Windbreaker or puffer for cold days.",
  },
  {
    "name": "Leggings",
    "category": "Fashion",
    "kidSpecific": true,
    "icon": "fitness_center",
    "description": "Comfortable and sporty stretch wear.",
  },
  {
    "name": "Backpack",
    "category": "Fashion",
    "kidSpecific": true,
    "icon": "backpack",
    "description": "Carry your essentials in style.",
  },
  {
    "name": "Cap or Beanie",
    "category": "Fashion",
    "kidSpecific": true,
    "icon": "redeem",
    "description": "Headwear that adds instant cool.",
  },
  {
    "name": "Sunglasses",
    "category": "Fashion",
    "kidSpecific": false,
    "icon": "wb_sunny",
    "description": "Protect your eyes and look trendy.",
  },
  {
    "name": "Smartphone",
    "category": "Tech",
    "kidSpecific": false,
    "icon": "smartphone",
    "description": "Your all-in-one communication hub.",
  },
  {
    "name": "Phone Case",
    "category": "Tech",
    "kidSpecific": true,
    "icon": "style",
    "description": "Protect your phone with style.",
  },
  {
    "name": "Wireless Earbuds",
    "category": "Tech",
    "kidSpecific": false,
    "icon": "headphones",
    "description": "Listen to music and podcasts wire-free.",
  },
  {
    "name": "Headphones",
    "category": "Tech",
    "kidSpecific": true,
    "icon": "headset",
    "description": "For deep focus or gaming sessions.",
  },
  {
    "name": "Bluetooth Speaker",
    "category": "Tech",
    "kidSpecific": true,
    "icon": "speaker",
    "description": "Portable sound for hangouts.",
  },
  {
    "name": "Laptop",
    "category": "Tech",
    "kidSpecific": false,
    "icon": "laptop_mac",
    "description": "Essential for schoolwork or creative projects.",
  },
  {
    "name": "Tablet",
    "category": "Tech",
    "kidSpecific": true,
    "icon": "tablet_mac",
    "description": "For reading, drawing, or streaming.",
  },
  {
    "name": "Smartwatch",
    "category": "Tech",
    "kidSpecific": false,
    "icon": "watch",
    "description": "Tracks steps, sleep, and messages.",
  },
  {
    "name": "Power Bank",
    "category": "Tech",
    "kidSpecific": true,
    "icon": "battery_charging_full",
    "description": "Never run out of battery on the go.",
  },
  {
    "name": "Charger Cable",
    "category": "Tech",
    "kidSpecific": true,
    "icon": "power",
    "description": "Extra cables for phone or laptop.",
  },
];

Future<void> ensureDefaultCatalogSeeded(AppDb db) async {
  final count = await db.countCatalogItems();
  if (count > 0) return;

  // Insert batch A
  for (final m in _seedBatchA) {
    await db.addCatalogItem(
      CatalogItemsCompanion.insert(
        name: m['name'] as String,
        category: m['category'] as String,
        iconName: Value(m['icon'] as String?),
        description: Value(m['description'] as String?),
      ),
    );
  }

  // Apply kidSpecific flags where provided by name
  final all = await db.getAllCatalogItems();
  final byName = {for (final it in all) it.name: it};
  for (final m in _seedBatchB) {
    final name = m['name'] as String;
    final existing = byName[name];
    if (existing == null) continue;
    final kid = (m['kidSpecific'] as bool?) ?? false;
    await (db.update(db.catalogItems)..where((t) => t.id.equals(existing.id)))
        .write(CatalogItemsCompanion(kidSpecific: Value(kid)));
  }
}
