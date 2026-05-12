import '../entities/transaction.dart';
import '../repositories/fund_repository.dart';
import '../../core/types/either_result.dart';

class GetTransactionHistory {
  final FundRepository repository;
  GetTransactionHistory(this.repository);

  Future<EitherResult<List<Transaction>>> call() async {
    try {
      final history = await repository.getTransactionHistory();
      return success(history);
    } catch (e) {
      return failure('Error cargando historial: $e');
    }
  }
}
