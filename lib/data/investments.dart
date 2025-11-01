class Investment {
  final String name;
  final String symbol;
  final String emoji; // optional flair

  const Investment({
    required this.name,
    required this.symbol,
    required this.emoji,
  });
}

const investments = <Investment>[
  Investment(name: 'Amazon', symbol: 'AMZN', emoji: '🛒'),
  Investment(name: 'Meta', symbol: 'META', emoji: '💬'),
  Investment(name: 'Alphabet', symbol: 'GOOGL', emoji: '🔍'),
  Investment(name: 'Nvidia', symbol: 'NVDA', emoji: '🖥️'),
  Investment(name: 'Walmart', symbol: 'WMT', emoji: '🏪'),
  Investment(name: 'Costco', symbol: 'COST', emoji: '🛒'),
  Investment(name: 'Nike', symbol: 'NKE', emoji: '👟'),
  Investment(name: 'Eli Lilly', symbol: 'LLY', emoji: '💊'),
  Investment(name: 'McDonald’s', symbol: 'MCD', emoji: '🍔'),
  Investment(name: 'Apple', symbol: 'AAPL', emoji: '🍎'),
  Investment(name: 'Tesla', symbol: 'TSLA', emoji: '🚗'),
  Investment(name: 'SPY (S&P 500)', symbol: 'SPY', emoji: '📊'),
  Investment(name: 'VOO (S&P 500)', symbol: 'VOO', emoji: '📈'),
  Investment(name: 'QQQ (Nasdaq 100)', symbol: 'QQQ', emoji: '💹'),
  Investment(name: 'Bitcoin', symbol: 'BTC-USD', emoji: '₿'),
];
