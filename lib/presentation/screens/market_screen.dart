import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Market', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionHeader('Indices del Mercado'),
          const SizedBox(height: 16),
          _buildMarketCard('S&P 500', '+1.24%', '5,308.13', true),
          _buildMarketCard('DOW JONES', '-0.32%', '38,852.27', false),
          _buildMarketCard('NASDAQ', '+0.95%', '16,742.39', true),
          _buildMarketCard('COLCAP', '+0.18%', '1,384.52', true),
          const SizedBox(height: 24),
          _buildSectionHeader('Fondos Populares'),
          const SizedBox(height: 16),
          _buildFundMarketCard('FPV_BTG_PACTUAL_RECAUDADORA', 'FPV', '+2.41%', '\$75,000 COP', true),
          _buildFundMarketCard('FPV_BTG_PACTUAL_ECOPETROL', 'FPV', '+1.87%', '\$125,000 COP', true),
          _buildFundMarketCard('DEUDAPRIVADA', 'FIC', '+0.92%', '\$50,000 COP', true),
          _buildFundMarketCard('FDO-ACCIONES', 'FIC', '-0.43%', '\$250,000 COP', false),
          _buildFundMarketCard('FPV_BTG_PACTUAL_DINAMICA', 'FPV', '+3.12%', '\$100,000 COP', true),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppTheme.textDark,
      ),
    );
  }

  Widget _buildMarketCard(String name, String change, String value, bool isUp) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(color: AppTheme.textGray, fontSize: 13)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: (isUp ? AppTheme.successGreen : AppTheme.errorRed).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              change,
              style: TextStyle(
                color: isUp ? AppTheme.successGreen : AppTheme.errorRed,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFundMarketCard(String name, String category, String change, String minAmount, bool isUp) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.primaryPurpleLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.insights, color: AppTheme.primaryPurple, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(color: AppTheme.primaryPurpleLight, borderRadius: BorderRadius.circular(4)),
                      child: Text(category, style: const TextStyle(color: AppTheme.primaryPurple, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    Text('Min: $minAmount', style: const TextStyle(color: AppTheme.textGray, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
          Text(
            change,
            style: TextStyle(
              color: isUp ? AppTheme.successGreen : AppTheme.errorRed,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
