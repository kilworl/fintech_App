import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../../core/navigation/app_router.dart';
import '../widgets/common/finan_button.dart';
import '../widgets/common/finan_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController(text: 'andres@btg.com');
  final _passwordController = TextEditingController(text: '123456');
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _error;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  static const _validEmail = 'andres@btg.com';
  static const _validPassword = '123456';

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    await Future.delayed(const Duration(milliseconds: 1200));

    if (_emailController.text.trim() == _validEmail &&
        _passwordController.text == _validPassword) {
      if (!mounted) return;
      context.go(AppRouter.dashboard);
    } else {
      setState(() {
        _isLoading = false;
        _error = 'Correo o contraseña incorrectos. Usa andres@btg.com / 123456';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final w = size.width;
    final h = size.height;

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          _buildGlows(context),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(w * 0.08),
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: SizedBox(
                    height: h * 0.85, // Ensure it fills enough space to center properly
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildHeader(context),
                        SizedBox(height: h * 0.05),
                        _buildWelcomeText(context),
                        SizedBox(height: h * 0.04),
                        FinanTextField(
                          controller: _emailController,
                          hint: 'andres@btg.com',
                          icon: Icons.alternate_email,
                          label: 'Correo Electrónico',
                          isDark: true,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: h * 0.025),
                        FinanTextField(
                          controller: _passwordController,
                          hint: '••••••••',
                          icon: Icons.lock_outline,
                          label: 'Contraseña',
                          isDark: true,
                          obscure: _obscurePassword,
                          suffix: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              color: Colors.white54,
                              size: w * 0.05,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        _buildForgotPassword(context),
                        if (_error != null) _buildErrorMessage(context),
                        SizedBox(height: h * 0.04),
                        FinanButton(
                          text: 'Iniciar Sesión',
                          onTap: _login,
                          isLoading: _isLoading,
                        ),
                        SizedBox(height: h * 0.04),
                        Center(
                          child: Text(
                            '¿No tienes cuenta? Regístrate',
                            style: TextStyle(color: Colors.white54, fontSize: w * 0.032),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0D0A1A), Color(0xFF1E1040), Color(0xFF13111C)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.5, 1.0],
        ),
      ),
    );
  }

  Widget _buildGlows(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final w = size.width;
    final h = size.height;
    return Stack(
      children: [
        Positioned(
          top: -h * 0.1,
          right: -w * 0.2,
          child: _glow(w * 0.8, AppTheme.primaryPurple.withValues(alpha: 0.35)),
        ),
        Positioned(
          bottom: -h * 0.08,
          left: -w * 0.15,
          child: _glow(w * 0.65, AppTheme.primaryPurple.withValues(alpha: 0.2)),
        ),
      ],
    );
  }

  Widget _glow(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, Colors.transparent]),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final w = size.width;
    final h = size.height;

    return Center(
      child: Column(
        children: [
          Container(
            width: w * 0.18,
            height: w * 0.18,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryPurple.withValues(alpha: 0.5),
                  blurRadius: 24,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: h * 0.02),
          Text(
            'FinanTech',
            style: TextStyle(
              color: Colors.white,
              fontSize: w * 0.08,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: h * 0.008),
          Text(
            'BTG Pactual · Gestión de Fondos',
            style: TextStyle(color: Colors.white54, fontSize: w * 0.032),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeText(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Bienvenido de vuelta',
          style: TextStyle(color: Colors.white, fontSize: w * 0.065, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: h * 0.008),
        Text(
          'Ingresa para gestionar tus fondos',
          style: TextStyle(color: Colors.white54, fontSize: w * 0.038),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildForgotPassword(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        child: Text(
          '¿Olvidaste tu contraseña?',
          style: TextStyle(
            color: AppTheme.primaryPurple.withValues(alpha: 0.85),
            fontSize: w * 0.032
          ),
        ),
      ),
    );
  }

  Widget _buildErrorMessage(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final w = size.width;
    final h = size.height;

    return Container(
      margin: EdgeInsets.only(top: h * 0.015),
      padding: EdgeInsets.all(w * 0.03),
      decoration: BoxDecoration(
        color: AppTheme.errorRed.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.errorRed.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: AppTheme.errorRed, size: w * 0.045),
          SizedBox(width: w * 0.02),
          Expanded(
            child: Text(
              _error!, 
              style: TextStyle(color: AppTheme.errorRed, fontSize: w * 0.032)
            )
          ),
        ],
      ),
    );
  }
}
