import '../entities/bank_account_entity.dart';
import '../repositories/account_repository.dart';

class GetAllAccountsUseCase {
  final AccountRepository repository;

  GetAllAccountsUseCase(this.repository);

  Future<List<BankAccountEntity>> execute() async {
    return await repository.getAllAccounts();
  }
}

class GetAccountByIdUseCase {
  final AccountRepository repository;

  GetAccountByIdUseCase(this.repository);

  Future<BankAccountEntity?> execute(String id) async {
    return await repository.getAccountById(id);
  }
}

class GetDefaultAccountUseCase {
  final AccountRepository repository;

  GetDefaultAccountUseCase(this.repository);

  Future<BankAccountEntity?> execute() async {
    return await repository.getDefaultAccount();
  }
}

class AddAccountUseCase {
  final AccountRepository repository;

  AddAccountUseCase(this.repository);

  Future<void> execute(BankAccountEntity account) async {
    return await repository.insertAccount(account);
  }
}

class UpdateAccountUseCase {
  final AccountRepository repository;

  UpdateAccountUseCase(this.repository);

  Future<void> execute(BankAccountEntity account) async {
    return await repository.updateAccount(account);
  }
}

class DeleteAccountUseCase {
  final AccountRepository repository;

  DeleteAccountUseCase(this.repository);

  Future<void> execute(String id) async {
    return await repository.deleteAccount(id);
  }
}

class SetDefaultAccountUseCase {
  final AccountRepository repository;

  SetDefaultAccountUseCase(this.repository);

  Future<void> execute(String id) async {
    return await repository.setDefaultAccount(id);
  }
}

class UpdateAccountBalanceUseCase {
  final AccountRepository repository;

  UpdateAccountBalanceUseCase(this.repository);

  Future<void> execute(String accountId, double amount) async {
    return await repository.updateAccountBalance(accountId, amount);
  }
}
