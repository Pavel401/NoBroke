class Item {
  final String name;
  final double defaultPrice;
  final String emoji;

  const Item({
    required this.name,
    required this.defaultPrice,
    required this.emoji,
  });
}

// A small starter set; easy to expand to 100+ later.
const items = <Item>[
  Item(name: 'Pizza', defaultPrice: 12, emoji: '🍕'),
  Item(name: 'Hoodie', defaultPrice: 40, emoji: '👕'),
  Item(name: 'Bubble Tea', defaultPrice: 6.5, emoji: '🧋'),
  Item(name: 'Game Pass', defaultPrice: 10, emoji: '🎮'),
  Item(name: 'Sneakers', defaultPrice: 120, emoji: '👟'),
  Item(name: 'AirPods', defaultPrice: 129, emoji: '🎧'),
  Item(name: 'Starbucks Drink', defaultPrice: 7, emoji: '☕'),
];
