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
        final errorMsg = 'Saldo insuficiente. El mínimo para ${fund.name} es \$${fund.minAmount.toStringAsFixed(0)} COP. '
            'Tu saldo actual es \$${currentBalance.amount.toStringAsFixed(0)} COP.';
        print('API_ERROR (Subscribe): $errorMsg');
        return failure(errorMsg);
      }
      await repository.subscribeToFund(fund);
      return success(null);
    } catch (e) {
      print('API_EXCEPTION (Subscribe): $e');
      return failure('Error inesperado al suscribirse: $e');
    }
  }
}
