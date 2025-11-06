class BudgetEntity {
  final String id;
  final int year;
  final int month;
  final double budgetAmount;
  final double spentAmount;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const BudgetEntity({
    required this.id,
    required this.year,
    required this.month,
    required this.budgetAmount,
    this.spentAmount = 0.0,
    required this.createdAt,
    this.updatedAt,
  });

  double get remainingAmount => budgetAmount - spentAmount;
  double get spentPercentage =>
      budgetAmount > 0 ? (spentAmount / budgetAmount) * 100 : 0;
  bool get isOverBudget => spentAmount > budgetAmount;

  String get monthName {
    const monthNames = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return monthNames[month];
  }

  BudgetEntity copyWith({
    String? id,
    int? year,
    int? month,
    double? budgetAmount,
    double? spentAmount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BudgetEntity(
      id: id ?? this.id,
      year: year ?? this.year,
      month: month ?? this.month,
      budgetAmount: budgetAmount ?? this.budgetAmount,
      spentAmount: spentAmount ?? this.spentAmount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'BudgetEntity(id: $id, year: $year, month: $month, budgetAmount: $budgetAmount, spentAmount: $spentAmount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BudgetEntity &&
        other.id == id &&
        other.year == year &&
        other.month == month &&
        other.budgetAmount == budgetAmount &&
        other.spentAmount == spentAmount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        year.hashCode ^
        month.hashCode ^
        budgetAmount.hashCode ^
        spentAmount.hashCode;
  }
}
