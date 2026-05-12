import '../entities/fund.dart';
import '../entities/transaction.dart';
import '../entities/user_balance.dart';

abstract class FundRepository {
  Future<UserBalance> getBalance();
  Future<void> updateBalance(double balance);
  Future<List<Fund>> getAvailableFunds();
  Future<List<Fund>> getSubscribedFunds();
  Future<List<Transaction>> getTransactionHistory();
  Future<void> subscribeToFund(Fund fund);
  Future<void> cancelSubscription(Fund fund);
}
