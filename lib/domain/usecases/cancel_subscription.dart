import '../entities/fund.dart';
import '../repositories/fund_repository.dart';
import '../../core/types/either_result.dart';

class CancelSubscription {
  final FundRepository repository;
  CancelSubscription(this.repository);

  Future<EitherResult<void>> call(Fund fund) async {
    try {
      await repository.cancelSubscription(fund);
      return success(null);
    } catch (e) {
      return failure('Error al cancelar la suscripción: $e');
    }
  }
}
