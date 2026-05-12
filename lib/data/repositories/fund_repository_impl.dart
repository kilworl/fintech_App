import '../../domain/entities/fund.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/user_balance.dart';
import '../../domain/repositories/fund_repository.dart';
import '../datasources/mock_fund_data_source.dart';
import '../models/fund_model.dart';

class FundRepositoryImpl implements FundRepository {
  final MockFundDataSource dataSource;

  FundRepositoryImpl(this.dataSource);

  @override
  Future<List<Fund>> getAvailableFunds() async {
    return await dataSource.getAvailableFunds();
  }

  @override
  Future<UserBalance> getBalance() async {
    final balance = await dataSource.getBalance();
    return UserBalance(amount: balance);
  }

  @override
  Future<List<Fund>> getSubscribedFunds() async {
    return await dataSource.getSubscribedFunds();
  }

  @override
  Future<List<Transaction>> getTransactionHistory() async {
    return await dataSource.getTransactionHistory();
  }

  @override
  Future<void> cancelSubscription(Fund fund) async {
    final fundModel = FundModel(
      id: fund.id,
      name: fund.name,
      minAmount: fund.minAmount,
      category: fund.category,
    );
    await dataSource.cancelSubscription(fundModel);
  }

  @override
  Future<void> subscribeToFund(Fund fund) async {
    final fundModel = FundModel(
      id: fund.id,
      name: fund.name,
      minAmount: fund.minAmount,
      category: fund.category,
    );
    await dataSource.subscribeToFund(fundModel);
  }
}
