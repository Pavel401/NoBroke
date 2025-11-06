// import 'package:drift/drift.dart' as drift;
// import '../../domain/entities/bank_account_entity.dart';
// import '../models/database.dart';

// class BankAccountRepositoryImpl implements BankAccountRepository {
//   final AppDatabase _database;

//   BankAccountRepositoryImpl(this._database);

//   @override
//   Future<List<BankAccountEntity>> getAllBankAccounts() async {
//     final bankAccounts = await _database.getAllBankAccounts();
//     return bankAccounts.map(_mapToEntity).toList();
//   }

//   @override
//   Future<BankAccountEntity?> getBankAccountById(String id) async {
//     final bankAccount = await _database.getBankAccountById(id);
//     return bankAccount != null ? _mapToEntity(bankAccount) : null;
//   }

//   @override
//   Future<BankAccountEntity?> getDefaultBankAccount() async {
//     final bankAccount = await _database.getDefaultBankAccount();
//     return bankAccount != null ? _mapToEntity(bankAccount) : null;
//   }

//   @override
//   Future<String> addBankAccount(BankAccountEntity bankAccount) async {
//     final companion = _mapToCompanion(bankAccount);
//     await _database.insertBankAccount(companion);
//     return bankAccount.id;
//   }

//   @override
//   Future<bool> updateBankAccount(BankAccountEntity bankAccount) async {
//     final companion = _mapToCompanion(bankAccount);
//     return await _database.updateBankAccount(companion);
//   }

//   @override
//   Future<bool> deleteBankAccount(String id) async {
//     final result = await _database.deleteBankAccount(id);
//     return result > 0;
//   }

//   @override
//   Future<bool> setDefaultBankAccount(String id) async {
//     return await _database.setDefaultBankAccount(id);
//   }

//   // Helper methods to convert between entity and database model
//   BankAccountEntity _mapToEntity(BankAccount bankAccount) {
//     return BankAccountEntity(
//       id: bankAccount.id,
//       name: bankAccount.name,
//       accountNumber: bankAccount.accountNumber,
//       bankName: bankAccount.bankName,
//       balance: bankAccount.balance,
//       isDefault: bankAccount.isDefault,
//     );
//   }

//   BankAccountsCompanion _mapToCompanion(BankAccountEntity entity) {
//     return BankAccountsCompanion(
//       id: drift.Value(entity.id),
//       name: drift.Value(entity.name),
//       accountNumber: drift.Value(entity.accountNumber),
//       bankName: drift.Value(entity.bankName),
//       balance: drift.Value(entity.balance),
//       isDefault: drift.Value(entity.isDefault),
//     );
//   }
// }
