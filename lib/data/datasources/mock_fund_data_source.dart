import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/transaction.dart';
import '../models/fund_model.dart';
import '../models/transaction_model.dart';

class MockFundDataSource {
  static const _balanceKey = 'user_balance';
  static const _subscribedKey = 'subscribed_funds';
  static const _transactionsKey = 'transaction_history';
  static const _initialBalance = 500000.0;

  final SharedPreferences _prefs;

  MockFundDataSource(this._prefs);

  // ── Master fund catalog (never changes) ────────────────────────────────────
  final List<FundModel> _catalog = [
    FundModel(id: 1, name: 'FPV_BTG_PACTUAL_RECAUDADORA', minAmount: 75000, category: 'FPV'),
    FundModel(id: 2, name: 'FPV_BTG_PACTUAL_ECOPETROL', minAmount: 125000, category: 'FPV'),
    FundModel(id: 3, name: 'DEUDAPRIVADA', minAmount: 50000, category: 'FIC'),
    FundModel(id: 4, name: 'FDO-ACCIONES', minAmount: 250000, category: 'FIC'),
    FundModel(id: 5, name: 'FPV_BTG_PACTUAL_DINAMICA', minAmount: 100000, category: 'FPV'),
  ];

  // ── Balance ─────────────────────────────────────────────────────────────────

  Future<double> getBalance() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _prefs.getDouble(_balanceKey) ?? _initialBalance;
  }

  Future<void> saveBalance(double value) => 
      _prefs.setDouble(_balanceKey, value).then((_) {});

  // ── Subscribed funds (persisted as JSON array) ───────────────────────────────

  Future<List<FundModel>> getSubscribedFunds() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _loadSubscribedFunds();
  }

  List<FundModel> _loadSubscribedFunds() {
    final raw = _prefs.getString(_subscribedKey);
    if (raw == null || raw.isEmpty) return [];
    final List<dynamic> decoded = jsonDecode(raw);
    return decoded
        .map((e) => FundModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _saveSubscribedFunds(List<FundModel> funds) async {
    final encoded = jsonEncode(funds.map((f) => f.toJson()).toList());
    await _prefs.setString(_subscribedKey, encoded);
  }

  // ── Available funds (catalog minus already subscribed) ─────────────────────

  Future<List<FundModel>> getAvailableFunds() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return List.of(_catalog);
  }

  // ── Transaction history (persisted as JSON array) ───────────────────────────

  Future<List<TransactionModel>> getTransactionHistory() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _loadTransactions();
  }

  List<TransactionModel> _loadTransactions() {
    final raw = _prefs.getString(_transactionsKey);
    if (raw == null || raw.isEmpty) return [];
    final List<dynamic> decoded = jsonDecode(raw);
    return decoded
        .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _saveTransactions(List<TransactionModel> txs) async {
    final encoded = jsonEncode(txs.map((t) => t.toJson()).toList());
    await _prefs.setString(_transactionsKey, encoded);
  }

  // ── Mutations ───────────────────────────────────────────────────────────────

  Future<void> subscribeToFund(FundModel fund) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));

      // Update balance
      final currentBalance = await getBalance();
      await saveBalance(currentBalance - fund.minAmount);

      // Update subscribed list
      final subscribed = _loadSubscribedFunds();
      final existingIndex = subscribed.indexWhere((f) => f.id == fund.id);
      
      if (existingIndex != -1) {
        // Increment existing investment
        final existing = subscribed[existingIndex];
        final newAmount = (existing.investedAmount ?? existing.minAmount) + fund.minAmount;
        subscribed[existingIndex] = FundModel(
          id: existing.id,
          name: existing.name,
          minAmount: existing.minAmount,
          category: existing.category,
          investedAmount: newAmount,
        );
      } else {
        // First time subscription
        subscribed.add(FundModel(
          id: fund.id,
          name: fund.name,
          minAmount: fund.minAmount,
          category: fund.category,
          investedAmount: fund.minAmount,
        ));
      }
      await _saveSubscribedFunds(subscribed);

      // Append transaction
      final txs = _loadTransactions();
      txs.add(TransactionModel(
        id: '${DateTime.now().millisecondsSinceEpoch}${Random().nextInt(999)}',
        type: TransactionType.subscribe,
        date: DateTime.now(),
        fundId: fund.id,
        fundName: fund.name,
        amount: fund.minAmount,
      ));
      await _saveTransactions(txs);
    } catch (e) {
      print('MOCK_API_ERROR (Subscribe): $e');
      rethrow;
    }
  }

  Future<void> cancelSubscription(FundModel fund) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));

      // Get the actual invested amount before removing
      final subscribed = _loadSubscribedFunds();
      final existing = subscribed.firstWhere((f) => f.id == fund.id);
      final amountToRestore = existing.investedAmount ?? existing.minAmount;

      // Restore full balance
      final currentBalance = await getBalance();
      await saveBalance(currentBalance + amountToRestore);

      // Remove from subscribed list
      subscribed.removeWhere((f) => f.id == fund.id);
      await _saveSubscribedFunds(subscribed);

      // Append transaction
      final txs = _loadTransactions();
      txs.add(TransactionModel(
        id: '${DateTime.now().millisecondsSinceEpoch}${Random().nextInt(999)}',
        type: TransactionType.cancel,
        date: DateTime.now(),
        fundId: fund.id,
        fundName: fund.name,
        amount: amountToRestore,
      ));
      await _saveTransactions(txs);
    } catch (e) {
      print('MOCK_API_ERROR (Cancel): $e');
      rethrow;
    }
  }
}
