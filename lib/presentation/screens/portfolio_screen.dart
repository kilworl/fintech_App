import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../providers/fund_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/fund_card.dart';
import '../widgets/success_overlay.dart';
import '../widgets/cancellation_sheet.dart';
import '../../domain/entities/fund.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FundProvider>();
    final currencyFormatter = NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0);

    // Calculate total invested and a mock return
    double totalInvested = provider.portfolioList.fold(0, (sum, item) => sum + item.minAmount);
    double mockReturn = provider.portfolioList.isNotEmpty ? 12450.0 : 0.0;
    double returnPercentage = totalInvested > 0 ? (mockReturn / totalInvested) * 100 : 0.0;

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      appBar: AppBar(
        title: const Text('My Portfolio', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.show_chart),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Header & Chart
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total Invested', style: TextStyle(color: AppTheme.textGray, fontSize: 14)),
                      const SizedBox(height: 4),
                      Text(
                        '${currencyFormatter.format(totalInvested)} COP',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                      ),
                      const SizedBox(height: 16),
                      const Text('Total Returns', style: TextStyle(color: AppTheme.textGray, fontSize: 14)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '+${currencyFormatter.format(mockReturn)} COP',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.successGreen),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(${returnPercentage.toStringAsFixed(2)}%)',
                            style: const TextStyle(color: AppTheme.successGreen, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Custom Donut Chart
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CustomPaint(
                      painter: DonutChartPainter(
                        hasData: provider.portfolioList.isNotEmpty,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          if (provider.portfolioList.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Text('No funds in your portfolio.', style: TextStyle(color: AppTheme.textGray)),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final fund = provider.portfolioList[index];
                    return FundCard(
                      fund: fund,
                      isSubscribed: true,
                      customSubtitle: 'Invested on May 28, 2024\n${currencyFormatter.format(fund.minAmount)} COP',
                      onTap: () {
                        // Normally this would go to a details screen, for now we will show a dialog to cancel
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
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => DefaultTabController.of(context).animateTo(3),
                  icon: const Icon(Icons.star_border),
                  label: const Text('Explore more funds'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.darkBackground,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
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

  DonutChartPainter({required this.hasData});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2);
    final strokeWidth = 16.0;

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
