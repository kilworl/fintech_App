import '../entities/fund.dart';
import '../repositories/fund_repository.dart';
import '../../core/types/either_result.dart';

class GetAvailableFunds {
  final FundRepository repository;
  GetAvailableFunds(this.repository);

  Future<EitherResult<List<Fund>>> call() async {
    try {
      final funds = await repository.getAvailableFunds();
      return success(funds);
    } catch (e) {
      return failure('Error cargando fondos: $e');
    }
  }
}
