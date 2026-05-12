import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fintech/presentation/providers/fund_provider.dart';
import 'package:fintech/domain/usecases/get_available_funds.dart';
import 'package:fintech/domain/usecases/subscribe_to_fund.dart';
import 'package:fintech/domain/usecases/cancel_subscription.dart';
import 'package:fintech/domain/usecases/get_transaction_history.dart';
import 'package:fintech/domain/usecases/send_notification.dart';
import 'package:fintech/domain/entities/fund.dart';
import 'package:fintech/domain/entities/user_balance.dart';
import 'package:fintech/domain/entities/transaction.dart';
import 'package:fintech/domain/repositories/fund_repository.dart';

class MockGetAvailableFunds extends Mock implements GetAvailableFunds {}
class MockSubscribeToFund extends Mock implements SubscribeToFund {}
class MockCancelSubscription extends Mock implements CancelSubscription {}
class MockGetTransactionHistory extends Mock implements GetTransactionHistory {}
class MockSendNotification extends Mock implements SendNotification {}
class MockFundRepository extends Mock implements FundRepository {}

void main() {
  late FundProvider provider;
  late MockGetAvailableFunds mockGetAvailableFunds;
  late MockSubscribeToFund mockSubscribeToFund;
  late MockCancelSubscription mockCancelSubscription;
  late MockGetTransactionHistory mockGetTransactionHistory;
  late MockSendNotification mockSendNotification;
  late MockFundRepository mockRepository;

  setUp(() {
    mockGetAvailableFunds = MockGetAvailableFunds();
    mockSubscribeToFund = MockSubscribeToFund();
    mockCancelSubscription = MockCancelSubscription();
    mockGetTransactionHistory = MockGetTransactionHistory();
    mockSendNotification = MockSendNotification();
    mockRepository = MockFundRepository();

    provider = FundProvider(
      getAvailableFunds: mockGetAvailableFunds,
      subscribeToFund: mockSubscribeToFund,
      cancelSubscription: mockCancelSubscription,
      getTransactionHistory: mockGetTransactionHistory,
      sendNotification: mockSendNotification,
      repository: mockRepository,
    );
  });

  test('initial state should be loading false and empty data', () {
    expect(provider.isLoading, false);
    expect(provider.availableFundsList, isEmpty);
    expect(provider.balance, 0.0);
  });

  test('loadInitialData should update balance and funds list', () async {
    // arrange
    final tBalance = UserBalance(amount: 1000.0);
    final tFunds = [
      Fund(id: 1, name: 'Fund 1', minAmount: 100, category: 'FIC'),
    ];

    when(() => mockRepository.getBalance()).thenAnswer((_) async => tBalance);
    when(() => mockGetAvailableFunds()).thenAnswer((_) async => (null, tFunds));
    when(() => mockRepository.getSubscribedFunds()).thenAnswer((_) async => []);
    when(() => mockGetTransactionHistory()).thenAnswer((_) async => (null, <Transaction>[]));

    // act
    await provider.loadInitialData();

    // assert
    expect(provider.balance, 1000.0);
    expect(provider.availableFundsList, tFunds);
    expect(provider.isLoading, false);
    verify(() => mockRepository.getBalance()).called(1);
    verify(() => mockGetAvailableFunds()).called(1);
  });
}
