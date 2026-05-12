import 'package:flutter/material.dart';
import '../../domain/entities/fund.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/fund_repository.dart';
import '../../domain/services/notification_service.dart';
import '../../domain/usecases/cancel_subscription.dart';
import '../../domain/usecases/get_available_funds.dart';
import '../../domain/usecases/get_transaction_history.dart';
import '../../domain/usecases/send_notification.dart';
import '../../domain/usecases/subscribe_to_fund.dart';

class FundProvider extends ChangeNotifier {
  final GetAvailableFunds getAvailableFunds;
  final SubscribeToFund subscribeToFund;
  final CancelSubscription cancelSubscription;
  final GetTransactionHistory getTransactionHistory;
  final SendNotification sendNotification;
  final FundRepository repository;

  FundProvider({
    required this.getAvailableFunds,
    required this.subscribeToFund,
    required this.cancelSubscription,
    required this.getTransactionHistory,
    required this.sendNotification,
    required this.repository,
  });

  bool _isLoading = false;
  String? _errorMessage;
  double _balance = 0.0;
  List<Fund> _availableFundsList = [];
  List<Fund> _portfolioList = [];
  List<Transaction> _historyList = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  double get balance => _balance;
  List<Fund> get availableFundsList => _availableFundsList;
  List<Fund> get portfolioList => _portfolioList;
  List<Transaction> get historyList => _historyList;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> loadInitialData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final userBalance = await repository.getBalance();
    _balance = userBalance.amount;

    final (fundsError, funds) = await getAvailableFunds();
    if (fundsError != null) {
      _errorMessage = fundsError;
    } else {
      _availableFundsList = funds ?? [];
    }

    _portfolioList = await repository.getSubscribedFunds();

    final (historyError, history) = await getTransactionHistory();
    if (historyError != null) {
      _errorMessage = historyError;
    } else {
      _historyList = history ?? [];
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Subscribes to a fund and optionally sends a notification.
  /// Returns (success, notificationMessage)
  Future<(bool, String?)> subscribe(
    Fund fund, {
    required NotificationMethod notificationMethod,
    required String contact, // email or phone
    String userName = 'Andrés',
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // 1. Subscribe via use case (validates balance with Either)
    final (error, _) = await subscribeToFund(fund);
    if (error != null) {
      _errorMessage = error;
      _isLoading = false;
      notifyListeners();
      return (false, null);
    }

    // 2. Reload state
    await loadInitialData();

    // 3. Send notification (non-blocking for UX — errors are shown but don't fail the flow)
    String? notifMsg;
    if (contact.trim().isNotEmpty) {
      final (notifError, result) = await sendNotification(
        method: notificationMethod,
        contact: contact.trim(),
        userName: userName,
        fund: fund,
        amount: fund.minAmount,
        action: 'Suscripción',
      );
      notifMsg = notifError ?? result?.message;
    }

    return (true, notifMsg);
  }

  /// Cancels a subscription and optionally sends a notification.
  Future<(bool, String?)> cancel(
    Fund fund, {
    NotificationMethod notificationMethod = NotificationMethod.email,
    String contact = '',
    String userName = 'Andrés',
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final (error, _) = await cancelSubscription(fund);
    if (error != null) {
      _errorMessage = error;
      _isLoading = false;
      notifyListeners();
      return (false, null);
    }

    await loadInitialData();

    String? notifMsg;
    if (contact.trim().isNotEmpty) {
      final (notifError, result) = await sendNotification(
        method: notificationMethod,
        contact: contact.trim(),
        userName: userName,
        fund: fund,
        amount: fund.minAmount,
        action: 'Cancelación',
      );
      notifMsg = notifError ?? result?.message;
    }

    return (true, notifMsg);
  }
}
