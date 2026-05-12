import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/mock_fund_data_source.dart';
import '../../data/repositories/fund_repository_impl.dart';
import '../../data/services/notification_service_impl.dart';
import '../../domain/repositories/fund_repository.dart';
import '../../domain/services/notification_service.dart';
import '../../domain/usecases/cancel_subscription.dart';
import '../../domain/usecases/get_available_funds.dart';
import '../../domain/usecases/get_transaction_history.dart';
import '../../domain/usecases/send_notification.dart';
import '../../domain/usecases/subscribe_to_fund.dart';
import '../../presentation/providers/fund_provider.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);

  // Data sources
  sl.registerLazySingleton(() => MockFundDataSource(sl()));

  // Services
  sl.registerLazySingleton<NotificationService>(() => NotificationServiceImpl());

  // Repository
  sl.registerLazySingleton<FundRepository>(() => FundRepositoryImpl(sl()));

  // Use cases
  sl.registerLazySingleton(() => GetAvailableFunds(sl()));
  sl.registerLazySingleton(() => SubscribeToFund(sl()));
  sl.registerLazySingleton(() => CancelSubscription(sl()));
  sl.registerLazySingleton(() => GetTransactionHistory(sl()));
  sl.registerLazySingleton(() => SendNotification(sl()));

  // Provider
  sl.registerFactory(
    () => FundProvider(
      getAvailableFunds: sl(),
      subscribeToFund: sl(),
      cancelSubscription: sl(),
      getTransactionHistory: sl(),
      sendNotification: sl(),
      repository: sl(),
    ),
  );
}
