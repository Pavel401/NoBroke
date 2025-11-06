import 'package:get/get.dart';
import '../../data/models/database.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../../data/repositories/bank_account_repository_impl.dart';
import '../../data/datasources/sms_service.dart';
import '../../data/datasources/gemini_service.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/usecases/transaction_usecases.dart';
import '../../presentation/controllers/transaction_controller.dart';
import '../constants/app_constants.dart';

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

    // Repositories
    Get.lazyPut<TransactionRepository>(
      () => TransactionRepositoryImpl(Get.find<AppDatabase>()),
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
        Get.find<SmsService>(),
        Get.find<GeminiService>(),
      ),
      fenix: true,
    );
  }
}
