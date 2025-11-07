import 'package:get/get.dart';
import 'package:moneyapp/core/constants/app_constants.dart';
import 'package:moneyapp/data/datasources/budget_service.dart';
import 'package:moneyapp/data/datasources/gemini_service.dart';
import 'package:moneyapp/data/datasources/sms_service.dart';
import 'package:moneyapp/data/models/database.dart';
import 'package:moneyapp/data/repositories/account_repository_impl.dart';
import 'package:moneyapp/data/repositories/transaction_repository_impl.dart';
import 'package:moneyapp/domain/repositories/account_repository.dart';
import 'package:moneyapp/domain/repositories/transaction_repository.dart';
import 'package:moneyapp/domain/usecases/account_usecases.dart';
import 'package:moneyapp/domain/usecases/transaction_usecases.dart';
import 'package:moneyapp/presentation/controllers/account_controller.dart';
import 'package:moneyapp/presentation/controllers/budget_controller.dart';
import 'package:moneyapp/presentation/controllers/transaction_controller.dart';

class DependencyInjection {
  static void init() {
    // Database
    Get.lazyPut<AppDatabase>(() => AppDatabase(), fenix: true);

    // Services
    Get.lazyPut<SmsService>(() => SmsService(), fenix: true);
    Get.lazyPut<GeminiService>(
      () => GeminiService(AppConstants.geminiApiKey),
      fenix: true,
    );
    Get.lazyPut<BudgetService>(
      () => BudgetService(Get.find<AppDatabase>()),
      fenix: true,
    );

    // Repositories
    Get.lazyPut<TransactionRepository>(
      () => TransactionRepositoryImpl(Get.find<AppDatabase>()),
      fenix: true,
    );
    Get.lazyPut<AccountRepository>(
      () => AccountRepositoryImpl(Get.find<AppDatabase>()),
      fenix: true,
    );

    // Use Cases
    Get.lazyPut<AddTransactionUseCase>(
      () => AddTransactionUseCase(Get.find<TransactionRepository>()),
      fenix: true,
    );
    Get.lazyPut<GetAllTransactionsUseCase>(
      () => GetAllTransactionsUseCase(Get.find<TransactionRepository>()),
      fenix: true,
    );
    Get.lazyPut<GetTransactionsByTypeUseCase>(
      () => GetTransactionsByTypeUseCase(Get.find<TransactionRepository>()),
      fenix: true,
    );
    Get.lazyPut<GetTransactionsByCategoryUseCase>(
      () => GetTransactionsByCategoryUseCase(Get.find<TransactionRepository>()),
      fenix: true,
    );
    Get.lazyPut<GetTransactionsByDateRangeUseCase>(
      () =>
          GetTransactionsByDateRangeUseCase(Get.find<TransactionRepository>()),
      fenix: true,
    );
    Get.lazyPut<UpdateTransactionUseCase>(
      () => UpdateTransactionUseCase(Get.find<TransactionRepository>()),
      fenix: true,
    );
    Get.lazyPut<DeleteTransactionUseCase>(
      () => DeleteTransactionUseCase(Get.find<TransactionRepository>()),
      fenix: true,
    );
    Get.lazyPut<GetCategoryWiseExpensesUseCase>(
      () => GetCategoryWiseExpensesUseCase(Get.find<TransactionRepository>()),
      fenix: true,
    );
    Get.lazyPut<GetTotalAmountByTypeUseCase>(
      () => GetTotalAmountByTypeUseCase(Get.find<TransactionRepository>()),
      fenix: true,
    );

    // Account Use Cases
    Get.lazyPut<GetAllAccountsUseCase>(
      () => GetAllAccountsUseCase(Get.find<AccountRepository>()),
      fenix: true,
    );
    Get.lazyPut<GetAccountByIdUseCase>(
      () => GetAccountByIdUseCase(Get.find<AccountRepository>()),
      fenix: true,
    );
    Get.lazyPut<GetDefaultAccountUseCase>(
      () => GetDefaultAccountUseCase(Get.find<AccountRepository>()),
      fenix: true,
    );
    Get.lazyPut<AddAccountUseCase>(
      () => AddAccountUseCase(Get.find<AccountRepository>()),
      fenix: true,
    );
    Get.lazyPut<UpdateAccountUseCase>(
      () => UpdateAccountUseCase(Get.find<AccountRepository>()),
      fenix: true,
    );
    Get.lazyPut<DeleteAccountUseCase>(
      () => DeleteAccountUseCase(Get.find<AccountRepository>()),
      fenix: true,
    );
    Get.lazyPut<SetDefaultAccountUseCase>(
      () => SetDefaultAccountUseCase(Get.find<AccountRepository>()),
      fenix: true,
    );
    Get.lazyPut<UpdateAccountBalanceUseCase>(
      () => UpdateAccountBalanceUseCase(Get.find<AccountRepository>()),
      fenix: true,
    );

    // Controllers
    Get.lazyPut<TransactionController>(
      () => TransactionController(
        Get.find<AddTransactionUseCase>(),
        Get.find<GetAllTransactionsUseCase>(),
        Get.find<GetTransactionsByTypeUseCase>(),
        Get.find<GetTransactionsByCategoryUseCase>(),
        Get.find<GetTransactionsByDateRangeUseCase>(),
        Get.find<UpdateTransactionUseCase>(),
        Get.find<DeleteTransactionUseCase>(),
        Get.find<GetCategoryWiseExpensesUseCase>(),
        Get.find<GetTotalAmountByTypeUseCase>(),
        Get.find<UpdateAccountBalanceUseCase>(),
        Get.find<SmsService>(),
        Get.find<GeminiService>(),
      ),
      fenix: true,
    );

    // Account Controller
    Get.lazyPut<AccountController>(
      () => AccountController(
        Get.find<AddAccountUseCase>(),
        Get.find<GetAllAccountsUseCase>(),
        Get.find<UpdateAccountUseCase>(),
        Get.find<DeleteAccountUseCase>(),
        Get.find<SetDefaultAccountUseCase>(),
        Get.find<GetDefaultAccountUseCase>(),
        Get.find<UpdateAccountBalanceUseCase>(),
      ),
      fenix: true,
    );

    // Budget Controller
    Get.lazyPut<BudgetController>(
      () => BudgetController(Get.find<BudgetService>()),
      fenix: true,
    );
  }
}
