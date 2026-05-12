import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/transaction.dart';
import '../providers/fund_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/transaction_tile.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedTab = 'All';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FundProvider>();

    List<Transaction> filteredHistory = List.of(provider.historyList);
    if (_selectedTab == 'Subscriptions') {
      filteredHistory = filteredHistory.where((t) => t.type == TransactionType.subscribe).toList();
    } else if (_selectedTab == 'Cancellations') {
      filteredHistory = filteredHistory.where((t) => t.type == TransactionType.cancel).toList();
    }

    // Sort descending by date
    filteredHistory.sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Transaction History', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Tabs
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                children: [
                  Expanded(child: _buildTab('All')),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTab('Subscriptions')),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTab('Cancellations')),
                ],
              ),
            ),
          ),

          // Grouped List
          if (filteredHistory.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Text('No transactions found.', style: TextStyle(color: AppTheme.textGray)),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final transaction = filteredHistory[index];
                    
                    // Simple month grouping logic for display
                    bool showMonthHeader = false;
                    if (index == 0) {
                      showMonthHeader = true;
                    } else {
                      final prevTransaction = filteredHistory[index - 1];
                      if (transaction.date.month != prevTransaction.date.month || 
                          transaction.date.year != prevTransaction.date.year) {
                        showMonthHeader = true;
                      }
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (showMonthHeader)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(
                              DateFormat('MMMM yyyy').format(transaction.date),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textDark,
                              ),
                            ),
                          ),
                        TransactionTile(transaction: transaction),
                      ],
                    );
                  },
                  childCount: filteredHistory.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTab(String title) {
    final isSelected = _selectedTab == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected ? AppTheme.primaryGradient : null,
          color: isSelected ? null : AppTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? null : Border.all(color: Colors.black.withValues(alpha: 0.05)),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textGray,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
