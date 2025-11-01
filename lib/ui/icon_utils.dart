import 'package:flutter/material.dart';
import 'animated_icons.dart';

IconData iconFromName(String? name) {
  // Use the new enhanced icons first
  final enhancedIcon = KidFriendlyIcons.getIcon(name);
  if (enhancedIcon != Icons.star) {
    return enhancedIcon;
  }

  // Fallback to original Material icons
  if (name == null || name.isEmpty) return Icons.category;
  switch (name) {
    case 'food':
      return Icons.fastfood;
    case 'fastfood':
      return Icons.fastfood;
    case 'local_pizza':
      return Icons.local_pizza;
    case 'local_cafe':
      return Icons.local_cafe;
    case 'emoji_food_beverage':
      return Icons.emoji_food_beverage;
    case 'blender':
      return Icons.blender;
    case 'cookie':
      return Icons.cookie;
    case 'icecream':
      return Icons.icecream;
    case 'local_drink':
      return Icons.local_drink;
    case 'bolt':
      return Icons.bolt;
    case 'storefront':
      return Icons.storefront;
    case 'checkroom':
      return Icons.checkroom;
    case 'style':
    case 'styler':
      return Icons.style;
    case 'emoji_people':
      return Icons.emoji_people;
    case 'directions_run':
      return Icons.directions_run;
    case 'socks':
      return Icons.checkroom;
    case 'ac_unit':
      return Icons.ac_unit;
    case 'fitness_center':
      return Icons.fitness_center;
    case 'backpack':
      return Icons.backpack;
    case 'redeem':
      return Icons.redeem;
    case 'wb_sunny':
      return Icons.wb_sunny;
    case 'smartphone':
      return Icons.smartphone;
    case 'headphones':
      return Icons.headphones;
    case 'headset':
      return Icons.headset;
    case 'speaker':
      return Icons.speaker;
    case 'laptop_mac':
      return Icons.laptop_mac;
    case 'tablet_mac':
      return Icons.tablet_mac;
    case 'watch':
      return Icons.watch;
    case 'battery_charging_full':
      return Icons.battery_charging_full;
    case 'power':
      return Icons.power;
    case 'sports_esports':
      return Icons.sports_esports;
    case 'stadia_controller':
      return Icons.sports_esports;
    case 'gamepad':
      return Icons.gamepad;
    case 'headset_mic':
      return Icons.headset_mic;
    case 'phone_iphone':
      return Icons.phone_iphone;
    case 'subscriptions':
      return Icons.subscriptions;
    case 'videogame_asset':
      return Icons.videogame_asset;
    case 'computer':
      return Icons.computer;
    case 'mouse':
      return Icons.mouse;
    case 'local_mall':
      return Icons.local_mall;
    case 'music_note':
      return Icons.music_note;
    case 'movie':
      return Icons.movie;
    case 'signal_cellular_alt':
      return Icons.signal_cellular_alt;
    case 'cloud':
      return Icons.cloud;
    case 'self_improvement':
      return Icons.self_improvement;
    case 'chat':
      return Icons.chat;
    case 'library_books':
      return Icons.library_books;
    case 'school':
      return Icons.school;
    case 'piano':
      return Icons.piano;
    case 'security':
      return Icons.security;
    case 'spa':
      return Icons.spa;
    case 'healing':
      return Icons.healing;
    case 'brush':
      return Icons.brush;
    case 'favorite':
      return Icons.favorite;
    case 'emoji_nature':
      return Icons.emoji_nature;
    case 'content_cut':
      return Icons.content_cut;
    case 'color_lens':
      return Icons.color_lens;
    case 'cut':
      return Icons.content_cut;
    case 'light_mode':
      return Icons.light_mode;
    case 'health_and_safety':
      return Icons.health_and_safety;
    case 'theaters':
      return Icons.theaters;
    case 'music_video':
      return Icons.music_video;
    case 'sports':
      return Icons.sports;
    case 'mic':
      return Icons.mic;
    case 'menu_book':
      return Icons.menu_book;
    case 'extension':
      return Icons.extension;
    case 'celebration':
      return Icons.celebration;
    case 'photo_camera':
      return Icons.photo_camera;
    case 'mic_none':
      return Icons.mic_none;
    case 'create':
      return Icons.create;
    case 'palette':
      return Icons.palette;
    case 'event_note':
      return Icons.event_note;
    case 'calculate':
      return Icons.calculate;
    case 'print':
      return Icons.print;
    case 'door_front':
      return Icons.door_front_door;
    case 'request_quote':
      return Icons.request_quote;
    case 'biotech':
      return Icons.biotech;
    case 'description':
      return Icons.description;
    case 'sports_basketball':
      return Icons.sports_basketball;
    case 'snowboarding':
      return Icons.snowboarding;
    case 'pedal_bike':
      return Icons.pedal_bike;
    case 'water_drop':
      return Icons.water_drop;
    case 'sports_soccer':
      return Icons.sports_soccer;
    case 'hiking':
      return Icons.hiking;
    case 'pool':
      return Icons.pool;
    case 'directions_bus':
      return Icons.directions_bus;
    case 'local_taxi':
      return Icons.local_taxi;
    case 'card_giftcard':
      return Icons.card_giftcard;
    case 'photo_camera_front':
      return Icons.photo_camera_front;
    case 'bedroom_child':
      return Icons.bedroom_child;
    case 'diamond':
      return Icons.diamond;
    case 'shopping_bag':
      return Icons.shopping_bag;
    case 'pets':
      return Icons.pets;
    case 'volunteer_activism':
      return Icons.volunteer_activism;
    case 'savings':
      return Icons.savings;
    // Added extended set of Material icons
    case 'home':
      return Icons.home;
    case 'restaurant':
      return Icons.restaurant;
    case 'restaurant_menu':
      return Icons.restaurant_menu;
    case 'local_grocery_store':
      return Icons.local_grocery_store;
    case 'local_bar':
      return Icons.local_bar;
    case 'local_florist':
      return Icons.local_florist;
    case 'local_gas_station':
      return Icons.local_gas_station;
    case 'local_hotel':
      return Icons.local_hotel;
    case 'local_library':
      return Icons.local_library;
    case 'local_offer':
      return Icons.local_offer;
    case 'local_parking':
      return Icons.local_parking;
    case 'local_phone':
      return Icons.local_phone;
    case 'local_play':
      return Icons.local_play;
    case 'local_post_office':
      return Icons.local_post_office;
    case 'local_printshop':
      return Icons.local_printshop;
    case 'local_see':
      return Icons.local_see;
    case 'local_shipping':
      return Icons.local_shipping;
    case 'local_museum':
      return Icons.museum; // closest modern equivalent
    case 'local_pharmacy':
      return Icons.local_pharmacy;
    case 'local_activity':
      return Icons.local_activity;
    case 'directions_walk':
      return Icons.directions_walk;
    case 'directions_bike':
      return Icons.directions_bike;
    case 'directions_car':
      return Icons.directions_car;
    case 'directions_boat':
      return Icons.directions_boat;
    case 'directions_transit':
      return Icons.directions_transit;
    case 'flight':
      return Icons.flight;
    case 'train':
      return Icons.train;
    case 'tram':
      return Icons.tram;
    case 'subway':
      return Icons.subway;
    case 'beach_access':
      return Icons.beach_access;
    case 'park':
      return Icons.park;
    case 'map':
      return Icons.map;
    case 'place':
      return Icons.place;
    case 'location_on':
      return Icons.location_on;
    case 'pin_drop':
      return Icons.pin_drop;
    case 'work':
      return Icons.work;
    case 'business':
      return Icons.business;
    case 'apartment':
      return Icons.apartment;
    case 'house':
      return Icons.house;
    case 'store':
      return Icons.store;
    case 'shopping_cart':
      return Icons.shopping_cart;
    case 'shopping_basket':
      return Icons.shopping_basket;
    case 'attach_money':
      return Icons.attach_money;
    case 'account_balance_wallet':
      return Icons.account_balance_wallet;
    case 'credit_card':
      return Icons.credit_card;
    case 'payment':
      return Icons.payment;
    case 'receipt':
      return Icons.receipt;
    case 'medical_services':
      return Icons.medical_services;
    case 'science':
      return Icons.science;
    case 'psychology':
      return Icons.psychology;
    case 'sports_baseball':
      return Icons.sports_baseball;
    case 'sports_tennis':
      return Icons.sports_tennis;
    case 'sports_volleyball':
      return Icons.sports_volleyball;
    case 'tv':
      return Icons.tv;
    case 'keyboard':
      return Icons.keyboard;
    case 'router':
      return Icons.router;
    case 'earbuds':
      return Icons.earbuds;
    case 'cast':
      return Icons.cast;
    case 'email':
      return Icons.email;
    case 'phone':
      return Icons.phone;
    case 'chat_bubble':
      return Icons.chat_bubble;
    case 'forum':
      return Icons.forum;
    case 'group':
      return Icons.group;
    case 'person':
      return Icons.person;
    case 'people':
      return Icons.people;
    case 'eco':
      return Icons.eco;
    case 'public':
      return Icons.public;
    case 'language':
      return Icons.language;
    case 'translate':
      return Icons.translate;
    case 'build':
      return Icons.build;
    case 'construction':
      return Icons.construction;
    case 'design_services':
      return Icons.design_services;
    default:
      return Icons.category;
  }
}

// Curated list of Material icon names supported by iconFromName
const List<String> knownIconNames = [
  'fastfood',
  'local_pizza',
  'local_cafe',
  'emoji_food_beverage',
  'blender',
  'cookie',
  'icecream',
  'local_drink',
  'bolt',
  'storefront',
  'checkroom',
  'style',
  'emoji_people',
  'directions_run',
  'ac_unit',
  'fitness_center',
  'backpack',
  'redeem',
  'wb_sunny',
  'smartphone',
  'headphones',
  'headset',
  'speaker',
  'laptop_mac',
  'tablet_mac',
  'watch',
  'battery_charging_full',
  'power',
  'sports_esports',
  'gamepad',
  'headset_mic',
  'phone_iphone',
  'subscriptions',
  'videogame_asset',
  'computer',
  'mouse',
  'local_mall',
  'music_note',
  'movie',
  'signal_cellular_alt',
  'cloud',
  'self_improvement',
  'chat',
  'library_books',
  'school',
  'piano',
  'security',
  'spa',
  'healing',
  'brush',
  'favorite',
  'emoji_nature',
  'content_cut',
  'color_lens',
  'light_mode',
  'health_and_safety',
  'theaters',
  'music_video',
  'sports',
  'mic',
  'menu_book',
  'extension',
  'celebration',
  'photo_camera',
  'mic_none',
  'create',
  'palette',
  'event_note',
  'calculate',
  'print',
  'door_front',
  'request_quote',
  'biotech',
  'description',
  'sports_basketball',
  'snowboarding',
  'pedal_bike',
  'water_drop',
  'sports_soccer',
  'hiking',
  'pool',
  'directions_bus',
  'local_taxi',
  'card_giftcard',
  'photo_camera_front',
  'bedroom_child',
  'diamond',
  'shopping_bag',
  'pets',
  'volunteer_activism',
  'savings',
  // Extended set
  'home',
  'restaurant',
  'restaurant_menu',
  'local_grocery_store',
  'local_bar',
  'local_florist',
  'local_gas_station',
  'local_hotel',
  'local_library',
  'local_offer',
  'local_parking',
  'local_phone',
  'local_play',
  'local_post_office',
  'local_printshop',
  'local_see',
  'local_shipping',
  'local_museum',
  'local_pharmacy',
  'local_activity',
  'directions_walk',
  'directions_bike',
  'directions_car',
  'directions_boat',
  'directions_transit',
  'flight',
  'train',
  'tram',
  'subway',
  'beach_access',
  'park',
  'map',
  'place',
  'location_on',
  'pin_drop',
  'work',
  'business',
  'apartment',
  'house',
  'store',
  'shopping_cart',
  'shopping_basket',
  'attach_money',
  'account_balance_wallet',
  'credit_card',
  'payment',
  'receipt',
  'local_hospital',
  'medical_services',
  'science',
  'psychology',
  'sports_baseball',
  'sports_tennis',
  'sports_volleyball',
  'tv',
  'keyboard',
  'router',
  'earbuds',
  'cast',
  'email',
  'phone',
  'chat_bubble',
  'forum',
  'group',
  'person',
  'people',
  'eco',
  'public',
  'language',
  'translate',
  'build',
  'construction',
  'design_services',
];
