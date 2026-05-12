import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/fund.dart';
import '../theme/app_theme.dart';

class FundCard extends StatelessWidget {
  final Fund fund;
  final VoidCallback onTap;
  final bool isSubscribed;
  final String? customSubtitle;

  const FundCard({
    super.key,
    required this.fund,
    required this.onTap,
    this.isSubscribed = false,
    this.customSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final w = size.width;
    final h = size.height;
    final currencyFormatter = NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0);

    return Container(
      margin: EdgeInsets.only(bottom: h * 0.015),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(w * 0.04),
            child: Row(
              children: [
                // Icon Box
                Container(
                  width: w * 0.12,
                  height: w * 0.12,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryPurpleLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.insights,
                    color: AppTheme.primaryPurple,
                    size: w * 0.06,
                  ),
                ),
                SizedBox(width: w * 0.04),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              fund.name,
                              style: TextStyle(
                                fontSize: w * 0.038,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textDark,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: w * 0.02),
                          // FPV/FIC Tag
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryPurpleLight.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              fund.category,
                              style: TextStyle(
                                color: AppTheme.primaryPurple,
                                fontSize: w * 0.025,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: h * 0.005),
                      Text(
                        customSubtitle ?? 'Min. Amount: ${currencyFormatter.format(fund.minAmount)} COP',
                        style: TextStyle(
                          color: AppTheme.textGray,
                          fontSize: w * 0.032,
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(width: w * 0.02),
                // Chevron
                Icon(
                  Icons.chevron_right,
                  color: AppTheme.textGray,
                  size: w * 0.05,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
