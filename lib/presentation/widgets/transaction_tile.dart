import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/transaction.dart';
import '../theme/app_theme.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final w = size.width;
    final h = size.height;
    final isSubscription = transaction.type == TransactionType.subscribe;
    final currencyFormatter = NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0);
    final dateFormatter = DateFormat('MMM dd, yyyy • hh:mm a');

    return Container(
      margin: EdgeInsets.only(bottom: h * 0.02),
      child: Row(
        children: [
          // Icon
          Container(
            width: w * 0.12,
            height: w * 0.12,
            decoration: BoxDecoration(
              color: isSubscription 
                  ? AppTheme.primaryPurpleLight.withValues(alpha: 0.5)
                  : AppTheme.successGreen.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isSubscription ? Icons.arrow_downward : Icons.arrow_upward,
              color: isSubscription ? AppTheme.primaryPurple : AppTheme.successGreen,
              size: w * 0.06,
            ),
          ),
          SizedBox(width: w * 0.04),
          
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateFormatter.format(transaction.date),
                  style: TextStyle(
                    color: AppTheme.textGray,
                    fontSize: w * 0.03,
                  ),
                ),
                SizedBox(height: h * 0.005),
                Text(
                  isSubscription ? 'Subscription' : 'Cancellation',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSubscription ? AppTheme.primaryPurple : AppTheme.successGreen,
                    fontSize: w * 0.035,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  transaction.fundName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                    fontSize: w * 0.035,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: w * 0.02),
          
          // Amount
          Text(
            "${isSubscription ? '-' : '+'}${currencyFormatter.format(transaction.amount)} COP",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
              fontSize: w * 0.035,
            ),
          ),
        ],
      ),
    );
  }
}
