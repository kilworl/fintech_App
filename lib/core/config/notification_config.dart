/// ─────────────────────────────────────────────────────────────────────────────
/// NOTIFICATION CONFIGURATION
/// ─────────────────────────────────────────────────────────────────────────────
///
/// EMAIL (EmailJS) — https://emailjs.com  — FREE 200 emails/month
/// ───────────────
///  1. Create a free account at https://emailjs.com
///  2. Go to "Email Services" → Add a service (Gmail, Outlook, etc.)
///  3. Go to "Email Templates" → Create a template. Use these variables:
///       {{to_email}}   → recipient email
///       {{to_name}}    → recipient name
///       {{fund_name}}  → fund that was subscribed
///       {{amount}}     → invested amount
///       {{action}}     → "Suscripción" or "Cancelación"
///       {{date}}       → transaction date
///  4. Go to "Account" → copy your Public Key
///  5. Fill in the constants below.
///
/// SMS (TextBelt) — https://textbelt.com — FREE 1 SMS/day (demo key)
/// ──────────────
///  Free key: 'textbelt'  → 1 SMS per day globally (enough for demos)
///  Paid key: Buy at textbelt.com for more volume (~$0.01/SMS)
///  Phone number must be in E.164 format: +573001234567
/// ─────────────────────────────────────────────────────────────────────────────
class NotificationConfig {
  // ── EmailJS ─────────────────────────────────────────────────────────────────
  static const String emailJsServiceId = 'service_xv0vmlc';
  static const String emailJsTemplateId = 'template_81v269s';
  static const String emailJsPublicKey =
      'v1lwn8QvM1LfkPt8a'; // Llave pública configurada ✅

  // ── TextBelt ─────────────────────────────────────────────────────────────────
  /// Use 'textbelt' for the free demo key (1 SMS/day).
  /// Replace with a paid key from textbelt.com for production.
  static const String textBeltKey = 'textbelt';

  // ── Helpers ───────────────────────────────────────────────────────────────────
  static bool get emailConfigured =>
      emailJsServiceId != 'YOUR_SERVICE_ID' &&
      emailJsTemplateId != 'YOUR_TEMPLATE_ID' &&
      emailJsPublicKey != 'YOUR_PUBLIC_KEY';
}
