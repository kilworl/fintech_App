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
import 'common/notification_selector.dart';
import 'finan_alert_overlay.dart';

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
  String? _contactError;

  @override
  void dispose() {
    _contactController.dispose();
    _nameController.dispose();
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
                  'Confirmar Suscripción',
                  style: TextStyle(
                    fontSize: w * 0.055, 
                    fontWeight: FontWeight.bold, 
                    color: AppTheme.textDark
                  ),
                ),
                SizedBox(height: h * 0.01),
                Text(
                  'Vas a invertir ${currencyFormatter.format(widget.fund.minAmount)} en el fondo ${widget.fund.name}.',
                  style: TextStyle(
                    fontSize: w * 0.038,
                    color: AppTheme.textGray, 
                    height: 1.5
                  ),
                ),
                SizedBox(height: h * 0.035),
                
                FinanTextField(
                  controller: _nameController,
                  hint: 'Tu nombre',
                  icon: Icons.person_outline,
                  label: 'Nombre para la notificación',
                ),
                SizedBox(height: h * 0.02),

                Text(
                  'Notificar por:',
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
                ),
                SizedBox(height: h * 0.018),
                _buildDynamicContactField(),
                SizedBox(height: h * 0.045),

                FinanButton(
                  text: 'Suscribirme ahora',
                  onTap: _handleSubscribe,
                  isLoading: _isProcessing,
                ),
                SizedBox(height: h * 0.015),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancelar', 
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
      errorText: _contactError,
    );
  }

  bool _validateContact() {
    final text = _contactController.text.trim();
    if (text.isEmpty) {
      setState(() => _contactError = 'Campo requerido');
      return false;
    }

    if (_method == NotificationMethod.email) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(text)) {
        setState(() => _contactError = 'Email inválido (Ej: usuario@correo.com)');
        return false;
      }
    } else {
      // Phone validation (Colombia: starts with 3, 10 digits)
      final phoneRegex = RegExp(r'^3\d{9}$');
      // Strip any non-digit chars for validation if needed, but here we expect clean input or +57
      final cleanPhone = text.replaceAll(RegExp(r'\D'), '');
      if (cleanPhone.length == 12 && cleanPhone.startsWith('57')) {
        // Handle +57 format
        if (!phoneRegex.hasMatch(cleanPhone.substring(2))) {
           setState(() => _contactError = 'Número inválido');
           return false;
        }
      } else if (!phoneRegex.hasMatch(cleanPhone)) {
        setState(() => _contactError = 'Número inválido (Ej: 3001234567)');
        return false;
      }
    }

    setState(() => _contactError = null);
    return true;
  }

  Future<void> _handleSubscribe() async {
    final provider = context.read<FundProvider>();
    final nav = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    if (!_validateContact()) return;

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
      FinanAlertOverlay.show(
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
    } else {
      // Determine if it's a balance error to show a better title
      final isBalanceError = notifMsg?.contains('Saldo insuficiente') ?? false;
      
      FinanAlertOverlay.show(
        context,
        isError: true,
        title: isBalanceError ? 'Saldo Insuficiente' : 'Inversión Fallida',
        subtitle: notifMsg ?? 'No se pudo procesar la suscripción.',
      );
    }
  }
}
