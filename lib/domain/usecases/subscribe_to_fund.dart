import '../entities/fund.dart';
import '../repositories/fund_repository.dart';
import '../../core/types/either_result.dart';

class InsufficientBalanceException implements Exception {
  final String message;
  InsufficientBalanceException(this.message);
  @override
  String toString() => message;
}

class SubscribeToFund {
  final FundRepository repository;
  SubscribeToFund(this.repository);

  Future<EitherResult<void>> call(Fund fund) async {
    try {
      final currentBalance = await repository.getBalance();
      if (currentBalance.amount < fund.minAmount) {
        return failure(
          'Saldo insuficiente. El mínimo para ${fund.name} es \$${fund.minAmount.toStringAsFixed(0)} COP. '
          'Tu saldo actual es \$${currentBalance.amount.toStringAsFixed(0)} COP.',
        );
      }
      await repository.subscribeToFund(fund);
      return success(null);
    } catch (e) {
      return failure('Error inesperado al suscribirse: $e');
    }
  }
}
