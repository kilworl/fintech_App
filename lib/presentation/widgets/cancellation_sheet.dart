import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/fund.dart';
import '../../domain/services/notification_service.dart';
import '../providers/fund_provider.dart';
import '../theme/app_theme.dart';
import 'common/finan_button.dart';
import 'common/finan_text_field.dart';
import 'common/notification_selector.dart';
import 'finan_alert_overlay.dart';

class CancellationSheet extends StatefulWidget {
  final Fund fund;
  const CancellationSheet({super.key, required this.fund});

  @override
  State<CancellationSheet> createState() => _CancellationSheetState();
}

class _CancellationSheetState extends State<CancellationSheet> {
  NotificationMethod _method = NotificationMethod.email;
  final _contactController = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final h = size.height;
    final w = size.width;
    final currencyFormatter = NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0);

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.scaffoldBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: w * 0.06,
        vertical: h * 0.02,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHandle(),
                SizedBox(height: h * 0.025),
                Text(
                  'Cancelar Suscripción',
                  style: TextStyle(
                    fontSize: w * 0.055, 
                    fontWeight: FontWeight.bold, 
                    color: AppTheme.textDark
                  ),
                ),
                SizedBox(height: h * 0.01),
                Text(
                  'Estás por retirar tus fondos de ${widget.fund.name}. El saldo de ${currencyFormatter.format(widget.fund.investedAmount ?? widget.fund.minAmount)} será devuelto a tu cuenta.',
                  style: TextStyle(
                    fontSize: w * 0.038,
                    color: AppTheme.textGray, 
                    height: 1.5
                  ),
                ),
                SizedBox(height: h * 0.035),

                Text(
                  'Notificar retiro por:',
                  style: TextStyle(
                    fontSize: w * 0.04, 
                    fontWeight: FontWeight.bold, 
                    color: AppTheme.textDark
                  ),
                ),
                SizedBox(height: h * 0.012),
                NotificationSelector(
                  selectedMethod: _method,
                  onMethodChanged: (method) => setState(() {
                    _method = method;
                    _contactController.clear();
                  }),
                  activeColor: AppTheme.errorRed,
                ),
                SizedBox(height: h * 0.018),
                _buildDynamicContactField(),
                SizedBox(height: h * 0.045),

                FinanButton(
                  text: 'Confirmar Retiro',
                  onTap: _handleCancel,
                  isLoading: _isProcessing,
                  color: AppTheme.errorRed,
                ),
                SizedBox(height: h * 0.015),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Volver atrás', 
                      style: TextStyle(
                        color: AppTheme.textGray,
                        fontSize: w * 0.038
                      )
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(2)),
      ),
    );
  }

  Widget _buildDynamicContactField() {
    IconData iconData;
    String hint;
    TextInputType type;

    switch (_method) {
      case NotificationMethod.email:
        iconData = Icons.alternate_email;
        hint = 'tu@correo.com';
        type = TextInputType.emailAddress;
        break;
      case NotificationMethod.sms:
      case NotificationMethod.whatsapp:
        iconData = _method == NotificationMethod.sms ? Icons.phone_outlined : Icons.chat_outlined;
        hint = '+573001234567';
        type = TextInputType.phone;
        break;
    }

    return FinanTextField(
      controller: _contactController,
      hint: hint,
      icon: iconData,
      keyboardType: type,
    );
  }

  Future<void> _handleCancel() async {
    final provider = context.read<FundProvider>();
    final nav = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    setState(() => _isProcessing = true);

    final (success, notifMsg) = await provider.cancel(
      widget.fund,
      notificationMethod: _method,
      contact: _contactController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isProcessing = false);

    if (success) {
      nav.pop(); 
      FinanAlertOverlay.show(
        context,
        title: 'Retiro Exitoso',
        subtitle: 'Tu dinero ha sido\ndevuelto al saldo',
      );

      if (notifMsg != null) {
        Future.delayed(const Duration(seconds: 3), () {
          messenger.showSnackBar(
            SnackBar(
              content: Text(notifMsg),
              backgroundColor: AppTheme.primaryPurple,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        });
      }
    }
  }
}
