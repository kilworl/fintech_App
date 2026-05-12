import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      appBar: AppBar(
        title: Text(
          'Market', 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: w * 0.05)
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, size: w * 0.06), 
            onPressed: () {}
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(w * 0.06),
        children: [
          _buildSectionHeader(context, 'Indices del Mercado'),
          SizedBox(height: h * 0.02),
          _buildMarketCard(context, 'S&P 500', '+1.24%', '5,308.13', true),
          _buildMarketCard(context, 'DOW JONES', '-0.32%', '38,852.27', false),
          _buildMarketCard(context, 'NASDAQ', '+0.95%', '16,742.39', true),
          _buildMarketCard(context, 'COLCAP', '+0.18%', '1,384.52', true),
          SizedBox(height: h * 0.03),
          _buildSectionHeader(context, 'Fondos Populares'),
          SizedBox(height: h * 0.02),
          _buildFundMarketCard(context, 'FPV_BTG_PACTUAL_RECAUDADORA', 'FPV', '+2.41%', '\$75,000 COP', true),
          _buildFundMarketCard(context, 'FPV_BTG_PACTUAL_ECOPETROL', 'FPV', '+1.87%', '\$125,000 COP', true),
          _buildFundMarketCard(context, 'DEUDAPRIVADA', 'FIC', '+0.92%', '\$50,000 COP', true),
          _buildFundMarketCard(context, 'FDO-ACCIONES', 'FIC', '-0.43%', '\$250,000 COP', false),
          _buildFundMarketCard(context, 'FPV_BTG_PACTUAL_DINAMICA', 'FPV', '+3.12%', '\$100,000 COP', true),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final w = MediaQuery.sizeOf(context).width;
    return Text(
      title,
      style: TextStyle(
        fontSize: w * 0.045,
        fontWeight: FontWeight.bold,
        color: AppTheme.textDark,
      ),
    );
  }

  Widget _buildMarketCard(BuildContext context, String name, String change, String value, bool isUp) {
    final size = MediaQuery.sizeOf(context);
    final w = size.width;
    final h = size.height;

    return Container(
      margin: EdgeInsets.only(bottom: h * 0.015),
      padding: EdgeInsets.all(w * 0.04),
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
              Text(
                name, 
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  color: AppTheme.textDark,
                  fontSize: w * 0.038
                )
              ),
              SizedBox(height: h * 0.005),
              Text(
                value, 
                style: TextStyle(
                  color: AppTheme.textGray, 
                  fontSize: w * 0.032
                )
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: h * 0.008),
            decoration: BoxDecoration(
              color: (isUp ? AppTheme.successGreen : AppTheme.errorRed).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              change,
              style: TextStyle(
                color: isUp ? AppTheme.successGreen : AppTheme.errorRed,
                fontWeight: FontWeight.bold,
                fontSize: w * 0.032,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFundMarketCard(BuildContext context, String name, String category, String change, String minAmount, bool isUp) {
    final size = MediaQuery.sizeOf(context);
    final w = size.width;
    final h = size.height;

    return Container(
      margin: EdgeInsets.only(bottom: h * 0.015),
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Container(
            width: w * 0.11,
            height: w * 0.11,
            decoration: BoxDecoration(
              color: AppTheme.primaryPurpleLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.insights, color: AppTheme.primaryPurple, size: w * 0.055),
          ),
          SizedBox(width: w * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name, 
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    color: AppTheme.textDark, 
                    fontSize: w * 0.032
                  ), 
                  maxLines: 1, 
                  overflow: TextOverflow.ellipsis
                ),
                SizedBox(height: h * 0.003),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(color: AppTheme.primaryPurpleLight, borderRadius: BorderRadius.circular(4)),
                      child: Text(
                        category, 
                        style: TextStyle(
                          color: AppTheme.primaryPurple, 
                          fontSize: w * 0.025, 
                          fontWeight: FontWeight.bold
                        )
                      ),
                    ),
                    SizedBox(width: w * 0.02),
                    Text(
                      'Min: $minAmount', 
                      style: TextStyle(color: AppTheme.textGray, fontSize: w * 0.028)
                    ),
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
              fontSize: w * 0.035,
            ),
          ),
        ],
      ),
    );
  }
}
