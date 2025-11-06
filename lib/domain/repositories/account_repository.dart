import '../entities/bank_account_entity.dart';

abstract class AccountRepository {
  Future<List<BankAccountEntity>> getAllAccounts();
  Future<BankAccountEntity?> getAccountById(String id);
  Future<BankAccountEntity?> getDefaultAccount();
  Future<void> insertAccount(BankAccountEntity account);
  Future<void> updateAccount(BankAccountEntity account);
  Future<void> deleteAccount(String id);
  Future<void> setDefaultAccount(String id);
  Future<void> updateAccountBalance(String accountId, double amount);
}
