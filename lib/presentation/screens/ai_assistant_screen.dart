import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, String>> _messages = [
    {
      'role': 'assistant',
      'text': '¡Hola! Soy FinBot, tu asistente financiero. Puedo ayudarte a entender los fondos disponibles, explicarte conceptos financieros o ayudarte a decidir dónde invertir. ¿En qué te puedo ayudar hoy?'
    }
  ];

  final List<Map<String, String>> _suggestions = [
    {'text': '¿Qué fondo me recomiendas?'},
    {'text': 'Explícame qué es un FPV'},
    {'text': '¿Cuál es el fondo con menor riesgo?'},
    {'text': '¿Cómo funciona DEUDAPRIVADA?'},
  ];

  final Map<String, String> _aiResponses = {
    '¿Qué fondo me recomiendas?': 'Con un saldo de \$500,000 COP tienes varias opciones. Si prefieres bajo riesgo, te recomiendo DEUDAPRIVADA (mín. \$50,000) o FPV_BTG_PACTUAL_RECAUDADORA (mín. \$75,000). Para mayor rentabilidad con algo más de riesgo, considera FDO-ACCIONES (mín. \$250,000).',
    'Explícame qué es un FPV': 'Un Fondo de Pensiones Voluntarias (FPV) es un instrumento de ahorro e inversión a largo plazo. Te permite acumular capital con beneficios tributarios en Colombia. A diferencia de los fondos obligatorios, tú controlas cuánto y cuándo ahorras.',
    '¿Cuál es el fondo con menor riesgo?': 'DEUDAPRIVADA es generalmente el de menor riesgo del portafolio, ya que invierte en instrumentos de renta fija corporativa. Tiene el monto mínimo más bajo (\$50,000 COP) y ofrece retornos estables aunque moderados.',
    '¿Cómo funciona DEUDAPRIVADA?': 'DEUDAPRIVADA es un Fondo de Inversión Colectiva (FIC) que invierte principalmente en bonos y títulos de deuda emitidos por empresas privadas. Ofrece rendimientos superiores a los CDT bancarios con riesgo controlado.',
  };

  bool _isTyping = false;

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _isTyping = true;
    });
    _messageController.clear();
    
    await Future.delayed(const Duration(milliseconds: 1200));
    
    final response = _aiResponses[text] ?? 'Esa es una excelente pregunta sobre finanzas. En general, diversificar tu portafolio entre fondos FPV y FIC te da balance entre liquidez y crecimiento. ¿Hay algún aspecto específico sobre el que quieras saber más?';
    
    setState(() {
      _isTyping = false;
      _messages.add({'role': 'assistant', 'text': response});
    });

    await Future.delayed(const Duration(milliseconds: 100));
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(w * 0.02),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.auto_awesome, color: Colors.white, size: w * 0.04),
            ),
            SizedBox(width: w * 0.03),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('FinBot AI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: w * 0.04)),
                Text('Asistente Financiero', style: TextStyle(fontSize: w * 0.028, color: AppTheme.textGray)),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(w * 0.06),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return _buildTypingIndicator(context);
                }
                final msg = _messages[index];
                return _buildMessage(context, msg['role']!, msg['text']!);
              },
            ),
          ),

          // Suggestions
          if (_messages.length == 1)
            SizedBox(
              height: h * 0.06,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _sendMessage(_suggestions[index]['text']!),
                    child: Container(
                      margin: EdgeInsets.only(right: w * 0.02),
                      padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.012),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryPurpleLight,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.primaryPurple.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        _suggestions[index]['text']!,
                        style: TextStyle(color: AppTheme.primaryPurple, fontSize: w * 0.032, fontWeight: FontWeight.w500),
                      ),
                    ),
                  );
                },
              ),
            ),

          SizedBox(height: h * 0.01),

          // Input
          Container(
            padding: EdgeInsets.fromLTRB(w * 0.04, h * 0.01, w * 0.04, h * 0.03),
            decoration: BoxDecoration(
              color: AppTheme.surfaceWhite,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: TextStyle(fontSize: w * 0.035),
                    decoration: InputDecoration(
                      hintText: 'Escribe tu pregunta...',
                      hintStyle: TextStyle(color: AppTheme.textGray.withValues(alpha: 0.7), fontSize: w * 0.035),
                      filled: true,
                      fillColor: AppTheme.scaffoldBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.015),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                SizedBox(width: w * 0.02),
                GestureDetector(
                  onTap: () => _sendMessage(_messageController.text),
                  child: Container(
                    padding: EdgeInsets.all(w * 0.03),
                    decoration: BoxDecoration(gradient: AppTheme.primaryGradient, shape: BoxShape.circle),
                    child: Icon(Icons.send, color: Colors.white, size: w * 0.05),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(BuildContext context, String role, String text) {
    final w = MediaQuery.sizeOf(context).width;
    final isAssistant = role == 'assistant';
    return Padding(
      padding: EdgeInsets.only(bottom: w * 0.04),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isAssistant ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isAssistant) ...[
            Container(
              padding: EdgeInsets.all(w * 0.015),
              decoration: BoxDecoration(gradient: AppTheme.primaryGradient, shape: BoxShape.circle),
              child: Icon(Icons.auto_awesome, color: Colors.white, size: w * 0.035),
            ),
            SizedBox(width: w * 0.02),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.all(w * 0.04),
              decoration: BoxDecoration(
                gradient: isAssistant ? null : AppTheme.primaryGradient,
                color: isAssistant ? AppTheme.surfaceWhite : null,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isAssistant ? 4 : 16),
                  bottomRight: Radius.circular(isAssistant ? 16 : 4),
                ),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isAssistant ? AppTheme.textDark : Colors.white,
                  height: 1.5,
                  fontSize: w * 0.035,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: EdgeInsets.only(bottom: w * 0.04),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(w * 0.015),
            decoration: BoxDecoration(gradient: AppTheme.primaryGradient, shape: BoxShape.circle),
            child: Icon(Icons.auto_awesome, color: Colors.white, size: w * 0.035),
          ),
          SizedBox(width: w * 0.02),
          Container(
            padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.03),
            decoration: BoxDecoration(color: AppTheme.surfaceWhite, borderRadius: BorderRadius.circular(16)),
            child: Row(
              children: [
                _PulsingDot(delay: 0, size: w * 0.02),
                SizedBox(width: w * 0.01),
                _PulsingDot(delay: 200, size: w * 0.02),
                SizedBox(width: w * 0.01),
                _PulsingDot(delay: 400, size: w * 0.02),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  final int delay;
  final double size;
  const _PulsingDot({required this.delay, required this.size});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))
      ..repeat(reverse: true);
    _animation = Tween(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: const BoxDecoration(color: AppTheme.primaryPurple, shape: BoxShape.circle),
      ),
    );
  }
}
