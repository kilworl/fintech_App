import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fintech/domain/entities/fund.dart';
import 'package:fintech/domain/entities/user_balance.dart';
import 'package:fintech/domain/repositories/fund_repository.dart';
import 'package:fintech/domain/usecases/subscribe_to_fund.dart';

class MockFundRepository extends Mock implements FundRepository {}

void main() {
  late SubscribeToFund usecase;
  late MockFundRepository mockRepository;

  setUp(() {
    mockRepository = MockFundRepository();
    usecase = SubscribeToFund(mockRepository);
    
    registerFallbackValue(Fund(id: 0, name: '', minAmount: 0, category: ''));
  });

  final tFund = Fund(
    id: 1,
    name: 'Fondo Test',
    category: 'FIC',
    minAmount: 100000,
  );

  test('should return success when balance is sufficient', () async {
    // arrange
    when(() => mockRepository.getBalance())
        .thenAnswer((_) async => UserBalance(amount: 500000));
    when(() => mockRepository.subscribeToFund(any()))
        .thenAnswer((_) async => {});

    // act
    final result = await usecase(tFund);

    // assert
    // expect(result.$2, isNull); // Removed because T is void
    expect(result.$1, isNull); // first element is error, null means success
    verify(() => mockRepository.getBalance()).called(1);
    verify(() => mockRepository.subscribeToFund(tFund)).called(1);
  });

  test('should return error when balance is insufficient', () async {
    // arrange
    when(() => mockRepository.getBalance())
        .thenAnswer((_) async => UserBalance(amount: 50000));

    // act
    final result = await usecase(tFund);

    // assert
    expect(result.$1, contains('Saldo insuficiente'));
    verify(() => mockRepository.getBalance()).called(1);
    verifyNever(() => mockRepository.subscribeToFund(any()));
  });

  test('should return error when repository fails', () async {
    // arrange
    when(() => mockRepository.getBalance()).thenThrow(Exception('DB Error'));

    // act
    final result = await usecase(tFund);

    // assert
    expect(result.$1, contains('Error inesperado'));
    verify(() => mockRepository.getBalance()).called(1);
  });
}
