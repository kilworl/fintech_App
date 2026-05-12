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
import 'success_overlay.dart';

class SubscriptionSheet extends StatefulWidget {
  final Fund fund;
  const SubscriptionSheet({super.key, required this.fund});

  @override
  State<SubscriptionSheet> createState() => _SubscriptionSheetState();
}

class _SubscriptionSheetState extends State<SubscriptionSheet> {
  NotificationMethod _method = NotificationMethod.email;
  final _contactController = TextEditingController();
  final _nameController = TextEditingController(text: 'Andrés');
  bool _isProcessing = false;

  @override
  void dispose() {
    _contactController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0);

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.scaffoldBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHandle(),
          const SizedBox(height: 24),
          const Text(
            'Confirmar Suscripción',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textDark),
          ),
          const SizedBox(height: 8),
          Text(
            'Vas a invertir ${currencyFormatter.format(widget.fund.minAmount)} en el fondo ${widget.fund.name}.',
            style: const TextStyle(color: AppTheme.textGray, height: 1.5),
          ),
          const SizedBox(height: 32),
          
          FinanTextField(
            controller: _nameController,
            hint: 'Tu nombre',
            icon: Icons.person_outline,
            label: 'Nombre para la notificación',
          ),
          const SizedBox(height: 20),

          const Text(
            'Notificar por:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textDark),
          ),
          const SizedBox(height: 12),
          NotificationSelector(
            selectedMethod: _method,
            onMethodChanged: (method) => setState(() {
              _method = method;
              _contactController.clear();
            }),
          ),
          const SizedBox(height: 16),
          _buildDynamicContactField(),
          const SizedBox(height: 40),

          FinanButton(
            text: 'Suscribirme ahora',
            onTap: _handleSubscribe,
            isLoading: _isProcessing,
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: AppTheme.textGray)),
            ),
          ),
        ],
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

  Future<void> _handleSubscribe() async {
    final provider = context.read<FundProvider>();
    final nav = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    setState(() => _isProcessing = true);

    final (success, notifMsg) = await provider.subscribe(
      widget.fund,
      notificationMethod: _method,
      contact: _contactController.text.trim(),
      userName: _nameController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isProcessing = false);

    if (success) {
      nav.pop(); 
      SuccessOverlay.show(
        context,
        title: '¡Suscripción Exitosa!',
        subtitle: 'Tu inversión ha sido\nprocesada correctamente',
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
