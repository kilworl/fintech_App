import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../providers/fund_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/fund_card.dart';
import '../widgets/finan_alert_overlay.dart';
import '../widgets/cancellation_sheet.dart';
import '../widgets/common/finan_button.dart';
import '../../domain/entities/fund.dart';
import '../../core/navigation/app_router.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final w = size.width;
    final h = size.height;
    final provider = context.watch<FundProvider>();
    final currencyFormatter = NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0);

    // Calculate total invested and a mock return
    double totalInvested = provider.portfolioList.fold(0, (sum, item) => sum + (item.investedAmount ?? item.minAmount));
    double mockReturn = provider.portfolioList.isNotEmpty ? 12450.0 : 0.0;
    double returnPercentage = totalInvested > 0 ? (mockReturn / totalInvested) * 100 : 0.0;

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      appBar: AppBar(
        title: Text(
          'My Portfolio', 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: w * 0.05)
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.show_chart, size: w * 0.06),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Header & Chart
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(w * 0.06),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Invested', style: TextStyle(color: AppTheme.textGray, fontSize: w * 0.035)),
                      SizedBox(height: h * 0.005),
                      Text(
                        '${currencyFormatter.format(totalInvested)} COP',
                        style: TextStyle(fontSize: w * 0.055, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                      ),
                      SizedBox(height: h * 0.02),
                      Text('Total Returns', style: TextStyle(color: AppTheme.textGray, fontSize: w * 0.035)),
                      SizedBox(height: h * 0.005),
                      Row(
                        children: [
                          Text(
                            '+${currencyFormatter.format(mockReturn)} COP',
                            style: TextStyle(fontSize: w * 0.045, fontWeight: FontWeight.bold, color: AppTheme.successGreen),
                          ),
                          SizedBox(width: w * 0.02),
                          Text(
                            '(${returnPercentage.toStringAsFixed(2)}%)',
                            style: TextStyle(color: AppTheme.successGreen, fontWeight: FontWeight.bold, fontSize: w * 0.038),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Custom Donut Chart
                  SizedBox(
                    width: w * 0.25,
                    height: w * 0.25,
                    child: CustomPaint(
                      painter: DonutChartPainter(
                        hasData: provider.portfolioList.isNotEmpty,
                        strokeWidth: w * 0.04,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          if (provider.portfolioList.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Text(
                  'No funds in your portfolio.', 
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
                    final fund = provider.portfolioList[index];
                    return FundCard(
                      fund: fund,
                      isSubscribed: true,
                      customSubtitle: 'Invested on May 28, 2024\n${currencyFormatter.format(fund.investedAmount ?? fund.minAmount)} COP',
                      onTap: () {
                        _showCancelDialog(context, fund, provider);
                      },
                    );
                  },
                  childCount: provider.portfolioList.length,
                ),
              ),
            ),
          
          // Explore more button
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(w * 0.06),
              child: FinanButton(
                text: 'Explore more funds',
                onTap: () => context.go(AppRouter.market),
                color: AppTheme.darkBackground,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context, Fund fund, FundProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: CancellationSheet(fund: fund),
      ),
    );
  }
}

class DonutChartPainter extends CustomPainter {
  final bool hasData;
  final double strokeWidth;

  DonutChartPainter({required this.hasData, this.strokeWidth = 16.0});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    if (!hasData) {
      paint.color = AppTheme.textGray.withValues(alpha: 0.2);
      canvas.drawCircle(center, radius - strokeWidth / 2, paint);
      return;
    }

    // Segment 1
    paint.color = AppTheme.primaryPurple;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -math.pi / 2,
      math.pi * 1.2,
      false,
      paint,
    );

    // Segment 2
    paint.color = AppTheme.successGreen;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      math.pi * 0.8,
      math.pi * 0.5,
      false,
      paint,
    );

    // Segment 3
    paint.color = Colors.lightBlue;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      math.pi * 1.4,
      math.pi * 0.5,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
