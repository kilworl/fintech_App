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
    final size = MediaQuery.sizeOf(context);
    final w = size.width;
    final h = size.height;
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
        title: Text(
          'Transaction History', 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: w * 0.05)
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt_outlined, size: w * 0.06),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Tabs
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.06, vertical: h * 0.02),
              child: Row(
                children: [
                  Expanded(child: _buildTab(context, 'All')),
                  SizedBox(width: w * 0.02),
                  Expanded(child: _buildTab(context, 'Subs')),
                  SizedBox(width: w * 0.02),
                  Expanded(child: _buildTab(context, 'Cancels')),
                ],
              ),
            ),
          ),

          // Grouped List
          if (filteredHistory.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Text(
                  'No transactions found.', 
                  style: TextStyle(color: AppTheme.textGray, fontSize: w * 0.038)
                ),
              ),
            )
          else
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.06),
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
                            padding: EdgeInsets.symmetric(vertical: h * 0.02),
                            child: Text(
                              DateFormat('MMMM yyyy').format(transaction.date),
                              style: TextStyle(
                                fontSize: w * 0.04,
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

  Widget _buildTab(BuildContext context, String title) {
    final isSelected = _selectedTab.startsWith(title.substring(0, 3));
    final size = MediaQuery.sizeOf(context);
    final w = size.width;
    final h = size.height;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (title == 'All') _selectedTab = 'All';
          if (title == 'Subs') _selectedTab = 'Subscriptions';
          if (title == 'Cancels') _selectedTab = 'Cancellations';
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: h * 0.012),
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
            fontSize: w * 0.03,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
