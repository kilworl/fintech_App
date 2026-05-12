import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/fund_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/fund_card.dart';
import '../widgets/subscription_sheet.dart';
import '../widgets/common/finan_button.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final w = size.width;
    final h = size.height;
    final provider = context.watch<FundProvider>();
    final currencyFormatter = NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0);

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      body: RefreshIndicator(
        onRefresh: () => provider.loadInitialData(),
        child: CustomScrollView(
          slivers: [
            // Dark Header Section
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.only(
                  top: h * 0.08, 
                  left: w * 0.06, 
                  right: w * 0.06, 
                  bottom: h * 0.04
                ),
                decoration: const BoxDecoration(
                  color: AppTheme.darkBackground,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Good morning,', style: TextStyle(color: Colors.white70, fontSize: w * 0.035)),
                            Text('Andrés 👋', style: TextStyle(color: Colors.white, fontSize: w * 0.05, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => _showComingSoon(context, 'Notificaciones'),
                              child: Container(
                                padding: EdgeInsets.all(w * 0.02),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.notifications_none, color: Colors.white, size: w * 0.05),
                              ),
                            ),
                            SizedBox(width: w * 0.03),
                            GestureDetector(
                              onTap: () => _showComingSoon(context, 'Mi Perfil'),
                              child: CircleAvatar(
                                radius: w * 0.05,
                                backgroundColor: AppTheme.primaryPurple,
                                child: Text('A', style: TextStyle(color: Colors.white, fontSize: w * 0.035)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: h * 0.04),

                    GestureDetector(
                      onLongPress: () async {
                        await provider.restoreMissingFunds();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('¡Saldo recuperado! Se han añadido 250 COP.'),
                              backgroundColor: AppTheme.successGreen,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(w * 0.06),
                        decoration: BoxDecoration(
                          gradient: AppTheme.darkCardGradient,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryPurple.withValues(alpha: 0.3),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Available Balance', style: TextStyle(color: Colors.white70, fontSize: w * 0.035)),
                            SizedBox(height: h * 0.01),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Text(
                                    provider.isBalanceVisible 
                                        ? currencyFormatter.format(provider.balance)
                                        : '••••••••',
                                    style: TextStyle(color: Colors.white, fontSize: w * 0.09, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: h * 0.008, left: w * 0.02),
                                  child: Text('COP', style: TextStyle(color: Colors.white70, fontSize: w * 0.04)),
                                ),
                                SizedBox(width: w * 0.02),
                                GestureDetector(
                                  onTap: () => provider.toggleBalanceVisibility(),
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: h * 0.008),
                                    child: Icon(
                                      provider.isBalanceVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined, 
                                      color: Colors.white54, 
                                      size: w * 0.05
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: h * 0.03),

                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildActionButton(context, Icons.add, 'Add Funds', 'Añadir Fondos', isPurple: true),
                        _buildActionButton(context, Icons.account_balance_wallet_outlined, 'Invest', 'Invertir'),
                        _buildActionButton(context, Icons.arrow_upward_outlined, 'Withdraw', 'Retirar'),
                        _buildActionButton(context, Icons.more_horiz, 'More', 'Más Opciones'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Available Funds Section
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: h * 0.03, left: w * 0.06, right: w * 0.06, bottom: h * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Available Funds',
                      style: TextStyle(fontSize: w * 0.045, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                    ),
                    GestureDetector(
                      onTap: () => _showComingSoon(context, 'Ver Todos los Fondos'),
                      child: Text(
                        'See all',
                        style: TextStyle(fontSize: w * 0.035, fontWeight: FontWeight.w600, color: AppTheme.primaryPurple),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (provider.isLoading && provider.availableFundsList.isEmpty)
              const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
            else
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final fund = provider.availableFundsList[index];
                      return FundCard(
                        fund: fund,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SubscriptionSheet(fund: fund),
                              fullscreenDialog: true,
                            ),
                          );
                        },
                      );
                    },
                    childCount: provider.availableFundsList.length,
                  ),
                ),
              ),
            SliverToBoxAdapter(child: SizedBox(height: h * 0.03)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label, String tooltip, {bool isPurple = false}) {
    final size = MediaQuery.sizeOf(context);
    final w = size.width;
    final h = size.height;

    return GestureDetector(
      onTap: () => _showComingSoon(context, tooltip),
      child: Column(
        children: [
          Container(
            width: w * 0.14,
            height: w * 0.14,
            decoration: BoxDecoration(
              color: isPurple ? AppTheme.primaryPurple : Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white, size: w * 0.06),
          ),
          SizedBox(height: h * 0.01),
          Text(label, style: TextStyle(color: Colors.white, fontSize: w * 0.03)),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    final size = MediaQuery.sizeOf(context);
    final w = size.width;
    final h = size.height;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.all(w * 0.08),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: w * 0.12,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            SizedBox(height: h * 0.03),
            Container(
              padding: EdgeInsets.all(w * 0.04),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.construction_rounded, color: Colors.white, size: w * 0.08),
            ),
            SizedBox(height: h * 0.025),
            Text(
              feature,
              style: TextStyle(fontSize: w * 0.055, fontWeight: FontWeight.bold, color: AppTheme.textDark),
            ),
            SizedBox(height: h * 0.01),
            Text(
              'Esta funcionalidad estará disponible próximamente.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textGray, height: 1.5, fontSize: w * 0.038),
            ),
            SizedBox(height: h * 0.03),
            FinanButton(
              text: 'Entendido',
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
