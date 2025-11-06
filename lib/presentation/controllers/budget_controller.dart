import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/datasources/budget_service.dart';
import '../../core/utils/ui_helpers.dart';

class BudgetController extends GetxController {
  final BudgetService _budgetService;

  BudgetController(this._budgetService);

  // Observable variables
  final RxDouble _monthlyBudget = 0.0.obs;
  final RxList<Map<String, dynamic>> _monthlyBudgets =
      <Map<String, dynamic>>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  // Getters
  double get monthlyBudget => _monthlyBudget.value;
  List<Map<String, dynamic>> get monthlyBudgets => _monthlyBudgets;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  bool get hasBudgetSet => _monthlyBudget.value > 0.0;

  @override
  void onInit() {
    super.onInit();
    loadBudget();
    loadAllMonthlyBudgets();
  }

  /// Loads the current month's budget from storage
  Future<void> loadBudget() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final budget = await _budgetService.getMonthlyBudget();
      _monthlyBudget.value = budget;
    } catch (e) {
      _errorMessage.value = 'Failed to load budget: $e';
    } finally {
      _isLoading.value = false;
    }
  }

  /// Loads all monthly budgets
  Future<void> loadAllMonthlyBudgets() async {
    try {
      final budgets = await _budgetService.getRecentMonthlyBudgets();
      _monthlyBudgets.value = budgets;
    } catch (e) {
      print('Failed to load monthly budgets: $e');
    }
  }

  /// Sets the monthly budget for current month
  Future<void> setMonthlyBudget(double amount, [BuildContext? context]) async {
    final now = DateTime.now();
    await setMonthlyBudgetForMonth(now.year, now.month, amount, context);
  }

  /// Sets the monthly budget for a specific month and year
  Future<void> setMonthlyBudgetForMonth(
    int year,
    int month,
    double amount, [
    BuildContext? context,
  ]) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      if (amount < 0) {
        throw Exception('Budget amount cannot be negative');
      }

      await _budgetService.setMonthlyBudgetForMonth(year, month, amount);

      // Update current month budget if it's the current month
      final now = DateTime.now();
      if (year == now.year && month == now.month) {
        _monthlyBudget.value = amount;
      }

      // Reload all budgets
      await loadAllMonthlyBudgets();

      if (context != null) {
        final monthName = _budgetService.getMonthName(month);
        UIHelpers.showSnackbar(
          context,
          message: amount > 0
              ? 'Budget for $monthName $year set to ₹${amount.toStringAsFixed(0)}'
              : 'Budget for $monthName $year removed',
          type: SnackbarType.success,
        );
      }
    } catch (e) {
      _errorMessage.value = 'Failed to set budget: $e';
      if (context != null) {
        UIHelpers.showSnackbar(
          context,
          message: 'Failed to set budget',
          type: SnackbarType.error,
        );
      }
    } finally {
      _isLoading.value = false;
    }
  }

  /// Gets budget for a specific month and year
  Future<double> getBudgetForMonth(int year, int month) async {
    return await _budgetService.getMonthlyBudgetForMonth(year, month);
  }

  /// Clears the monthly budget for current month
  Future<void> clearBudget([BuildContext? context]) async {
    final now = DateTime.now();
    await clearBudgetForMonth(now.year, now.month, context);
  }

  /// Clears budget for a specific month
  Future<void> clearBudgetForMonth(
    int year,
    int month, [
    BuildContext? context,
  ]) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      await _budgetService.clearBudgetForMonth(year, month);

      // Update current month budget if it's the current month
      final now = DateTime.now();
      if (year == now.year && month == now.month) {
        _monthlyBudget.value = 0.0;
      }

      // Reload all budgets
      await loadAllMonthlyBudgets();

      if (context != null) {
        final monthName = _budgetService.getMonthName(month);
        UIHelpers.showSnackbar(
          context,
          message: 'Budget for $monthName $year cleared',
          type: SnackbarType.success,
        );
      }
    } catch (e) {
      _errorMessage.value = 'Failed to clear budget: $e';
      if (context != null) {
        UIHelpers.showSnackbar(
          context,
          message: 'Failed to clear budget',
          type: SnackbarType.error,
        );
      }
    } finally {
      _isLoading.value = false;
    }
  }

  /// Clears all monthly budgets
  Future<void> clearAllBudgets([BuildContext? context]) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      await _budgetService.clearAllBudgets();
      _monthlyBudget.value = 0.0;
      _monthlyBudgets.clear();

      if (context != null) {
        UIHelpers.showSnackbar(
          context,
          message: 'All budgets cleared',
          type: SnackbarType.success,
        );
      }
    } catch (e) {
      _errorMessage.value = 'Failed to clear all budgets: $e';
      if (context != null) {
        UIHelpers.showSnackbar(
          context,
          message: 'Failed to clear all budgets',
          type: SnackbarType.error,
        );
      }
    } finally {
      _isLoading.value = false;
    }
  }

  /// Calculates the remaining budget amount based on current month's expenses
  double getRemainingBudget(double totalExpenses) {
    return _monthlyBudget.value - totalExpenses;
  }

  /// Calculates the budget usage percentage
  double getBudgetUsagePercentage(double totalExpenses) {
    if (_monthlyBudget.value == 0) return 0.0;
    return (totalExpenses / _monthlyBudget.value) * 100;
  }

  /// Checks if the budget is exceeded
  bool isBudgetExceeded(double totalExpenses) {
    return totalExpenses > _monthlyBudget.value && _monthlyBudget.value > 0;
  }
}
