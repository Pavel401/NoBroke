import '../../domain/entities/bank_account_entity.dart';
import '../../domain/repositories/account_repository.dart';
import '../models/database.dart';
import 'package:drift/drift.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AppDatabase _database;

  AccountRepositoryImpl(this._database);

  @override
  Future<List<BankAccountEntity>> getAllAccounts() async {
    final accounts = await _database.getAllBankAccounts();
    return accounts.map((account) => _mapToEntity(account)).toList();
  }

  @override
  Future<BankAccountEntity?> getAccountById(String id) async {
    final account = await _database.getBankAccountById(id);
    return account != null ? _mapToEntity(account) : null;
  }

  @override
  Future<BankAccountEntity?> getDefaultAccount() async {
    final account = await _database.getDefaultBankAccount();
    return account != null ? _mapToEntity(account) : null;
  }

  @override
  Future<void> insertAccount(BankAccountEntity account) async {
    final companion = BankAccountsCompanion(
      id: Value(account.id),
      name: Value(account.accountName),
      accountNumber: Value(account.accountNumber),
      bankName: Value(account.bankName),
      balance: Value(account.balance),
      isDefault: Value(account.isActive), // Using isActive as isDefault for now
    );
    await _database.insertBankAccount(companion);
  }

  @override
  Future<void> updateAccount(BankAccountEntity account) async {
    final companion = BankAccountsCompanion(
      id: Value(account.id),
      name: Value(account.accountName),
      accountNumber: Value(account.accountNumber),
      bankName: Value(account.bankName),
      balance: Value(account.balance),
      isDefault: Value(account.isActive), // Using isActive as isDefault for now
    );
    await _database.updateBankAccount(companion);
  }

  @override
  Future<void> deleteAccount(String id) async {
    await _database.deleteBankAccount(id);
  }

  @override
  Future<void> setDefaultAccount(String id) async {
    await _database.setDefaultBankAccount(id);
  }

  @override
  Future<void> updateAccountBalance(String accountId, double amount) async {
    final account = await getAccountById(accountId);
    if (account != null) {
      final updatedAccount = account.copyWith(
        balance: account.balance + amount,
        updatedAt: DateTime.now(),
      );
      await updateAccount(updatedAccount);
    }
  }

  BankAccountEntity _mapToEntity(BankAccount account) {
    return BankAccountEntity(
      id: account.id,
      accountName: account.name,
      accountNumber: account.accountNumber,
      bankName: account.bankName,
      accountType: BankAccountType.savings, // Default to savings for now
      balance: account.balance,
      isActive: account.isDefault, // Using isDefault as isActive for now
      createdAt: DateTime.now(), // Default date for now
      updatedAt: DateTime.now(), // Default date for now
    );
  }
}
