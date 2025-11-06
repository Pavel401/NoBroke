import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/bank_account_entity.dart';
import '../../domain/usecases/account_usecases.dart';
import '../../core/utils/ui_helpers.dart';

class AccountController extends GetxController {
  final AddAccountUseCase _addAccountUseCase;
  final GetAllAccountsUseCase _getAllAccountsUseCase;
  final UpdateAccountUseCase _updateAccountUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;
  final SetDefaultAccountUseCase _setDefaultAccountUseCase;
  final GetDefaultAccountUseCase _getDefaultAccountUseCase;
  final UpdateAccountBalanceUseCase _updateAccountBalanceUseCase;

  AccountController(
    this._addAccountUseCase,
    this._getAllAccountsUseCase,
    this._updateAccountUseCase,
    this._deleteAccountUseCase,
    this._setDefaultAccountUseCase,
    this._getDefaultAccountUseCase,
    this._updateAccountBalanceUseCase,
  );

  // Observable variables
  final RxList<BankAccountEntity> _accounts = <BankAccountEntity>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  // Getters
  List<BankAccountEntity> get accounts => _accounts;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;

  @override
  void onInit() {
    super.onInit();
    loadAccounts();
  }

  Future<void> loadAccounts([BuildContext? context]) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      final accounts = await _getAllAccountsUseCase.execute();
      _accounts.value = accounts;
    } catch (e) {
      _errorMessage.value = e.toString();
      if (context != null) {
        UIHelpers.showSnackbar(
          context,
          message: 'Failed to load accounts: ${e.toString()}',
          type: SnackbarType.error,
        );
      }
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> addAccount({
    required String name,
    required String accountNumber,
    required String bankName,
    required double balance,
    required bool isDefault,
    BuildContext? context,
  }) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final account = BankAccountEntity(
        id: const Uuid().v4(),
        accountName: name,
        accountNumber: accountNumber,
        bankName: bankName,
        accountType: BankAccountType.savings, // Default to savings
        balance: balance,
        isActive: isDefault, // Using isActive for isDefault functionality
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _addAccountUseCase.execute(account);
      await loadAccounts(context); // Reload to get updated list

      Get.back(); // Navigate back to accounts screen
      if (context != null) {
        UIHelpers.showSnackbar(
          context,
          message: 'Account added successfully',
          type: SnackbarType.success,
        );
      }
    } catch (e) {
      _errorMessage.value = e.toString();
      if (context != null) {
        UIHelpers.showSnackbar(
          context,
          message: 'Failed to add account: ${e.toString()}',
          type: SnackbarType.error,
        );
      }
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> updateAccount(
    BankAccountEntity account, [
    BuildContext? context,
  ]) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      await _updateAccountUseCase.execute(account);
      await loadAccounts(context); // Reload to get updated list

      Get.back(); // Navigate back to accounts screen
      if (context != null) {
        UIHelpers.showSnackbar(
          context,
          message: 'Account updated successfully',
          type: SnackbarType.success,
        );
      }
    } catch (e) {
      _errorMessage.value = e.toString();
      if (context != null) {
        UIHelpers.showSnackbar(
          context,
          message: 'Failed to update account: ${e.toString()}',
          type: SnackbarType.error,
        );
      }
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> deleteAccount(String accountId, [BuildContext? context]) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      await _deleteAccountUseCase.execute(accountId);
      await loadAccounts(context); // Reload to get updated list

      if (context != null) {
        UIHelpers.showSnackbar(
          context,
          message: 'Account deleted successfully',
          type: SnackbarType.success,
        );
      }
    } catch (e) {
      _errorMessage.value = e.toString();
      if (context != null) {
        UIHelpers.showSnackbar(
          context,
          message: 'Failed to delete account: ${e.toString()}',
          type: SnackbarType.error,
        );
      }
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> setDefaultAccount(
    String accountId, [
    BuildContext? context,
  ]) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      await _setDefaultAccountUseCase.execute(accountId);
      await loadAccounts(context); // Reload to get updated list

      if (context != null) {
        UIHelpers.showSnackbar(
          context,
          message: 'Default account updated successfully',
          type: SnackbarType.success,
        );
      }
    } catch (e) {
      _errorMessage.value = e.toString();
      if (context != null) {
        UIHelpers.showSnackbar(
          context,
          message: 'Failed to set default account: ${e.toString()}',
          type: SnackbarType.error,
        );
      }
    } finally {
      _isLoading.value = false;
    }
  }

  Future<BankAccountEntity?> getDefaultAccount() async {
    try {
      return await _getDefaultAccountUseCase.execute();
    } catch (e) {
      _errorMessage.value = e.toString();
      return null;
    }
  }
}
