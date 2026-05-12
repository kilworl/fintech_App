import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/config/notification_config.dart';
import '../../domain/services/notification_service.dart';

class NotificationServiceImpl implements NotificationService {
  static const _emailJsUrl = 'https://api.emailjs.com/api/v1.0/email/send';
  static const _textBeltUrl = 'https://textbelt.com/text';

  // ── Email via EmailJS ──────────────────────────────────────────────────────

  @override
  Future<NotificationResult> sendEmail({
    required String toEmail,
    required String toName,
    required String fundName,
    required double amount,
    required String action,
    required DateTime date,
  }) async {
    if (!NotificationConfig.emailConfigured) {
      await Future.delayed(const Duration(milliseconds: 800));
      return const NotificationResult(
        status: NotificationStatus.simulated,
        message: 'Email simulado (configura las credenciales de EmailJS)',
      );
    }

    try {
      final formatter = NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0);
      final dateStr = DateFormat('dd/MM/yyyy HH:mm').format(date);

      final payload = {
        'service_id': NotificationConfig.emailJsServiceId,
        'template_id': NotificationConfig.emailJsTemplateId,
        'user_id': NotificationConfig.emailJsPublicKey,
        'template_params': {
          'to_email': toEmail,
          'to_name': toName,
          'fund_name': fundName,
          'amount': formatter.format(amount),
          'action': action,
          'date': dateStr,
        },
      };

      print('NOTIFICATION_DEBUG: Sending Email via EmailJS...');
      print('URL: $_emailJsUrl');
      print('Payload: ${jsonEncode(payload)}');

      final response = await http
          .post(
            Uri.parse(_emailJsUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 10));

      print('NOTIFICATION_DEBUG: EmailJS Response Status: ${response.statusCode}');
      print('NOTIFICATION_DEBUG: EmailJS Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return const NotificationResult(
          status: NotificationStatus.sent,
          message: 'Email enviado exitosamente',
        );
      } else {
        return const NotificationResult(
          status: NotificationStatus.failed,
          message: 'El servicio de notificación por email no está disponible temporalmente.',
        );
      }
    } catch (e) {
      print('NOTIFICATION_DEBUG: Email Exception: $e');
      return const NotificationResult(
        status: NotificationStatus.failed,
        message: 'No se pudo conectar con el servicio de correo. Intenta más tarde.',
      );
    }
  }

  // ── SMS via TextBelt ───────────────────────────────────────────────────────

  @override
  Future<NotificationResult> sendSms({
    required String phone,
    required String fundName,
    required String action,
    required double amount,
  }) async {
    try {
      final formatter = NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0);
      final message =
          '[$action] BTG FinanTech: Tu $action en $fundName por ${formatter.format(amount)} COP fue procesada exitosamente.';

      final response = await http
          .post(
            Uri.parse(_textBeltUrl),
            body: {
              'phone': phone,
              'message': message,
              'key': NotificationConfig.textBeltKey,
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        if (body['success'] == true) {
          return const NotificationResult(
            status: NotificationStatus.sent,
            message: 'SMS enviado exitosamente',
          );
        } else {
          return const NotificationResult(
            status: NotificationStatus.failed,
            message: 'Servicio de SMS no disponible en tu región por ahora.',
          );
        }
      } else {
        return const NotificationResult(
          status: NotificationStatus.failed,
          message: 'Servicio de SMS temporalmente fuera de línea.',
        );
      }
    } catch (e) {
      return const NotificationResult(
        status: NotificationStatus.failed,
        message: 'Error de conexión al enviar el mensaje de texto.',
      );
    }
  }

  // ── WhatsApp via URL Launcher ──────────────────────────────────────────────

  @override
  Future<NotificationResult> sendWhatsApp({
    required String phone,
    required String fundName,
    required double amount,
    required String action,
  }) async {
    try {
      final formatter = NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0);
      
      final cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
      
      final message = 
          '🏦 *BTG FinanTech*\n\n'
          '¡Hola! Te confirmamos tu *${action.toUpperCase()}* exitosa.\n\n'
          '🔹 *Fondo:* $fundName\n'
          '💰 *Monto:* ${formatter.format(amount)} COP\n'
          '📅 *Fecha:* ${DateFormat('dd/MM/yy HH:mm').format(DateTime.now())}\n\n'
          'Gracias por confiar en nosotros.';

      final url = 'https://wa.me/$cleanPhone?text=${Uri.encodeComponent(message)}';
      
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        return const NotificationResult(
          status: NotificationStatus.sent,
          message: 'WhatsApp abierto correctamente',
        );
      } else {
        return const NotificationResult(
          status: NotificationStatus.failed,
          message: 'WhatsApp no está instalado en este dispositivo.',
        );
      }
    } catch (e) {
      return const NotificationResult(
        status: NotificationStatus.failed,
        message: 'No se pudo abrir WhatsApp temporalmente.',
      );
    }
  }
}
