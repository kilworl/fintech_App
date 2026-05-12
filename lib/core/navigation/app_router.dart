import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/splash_screen.dart';
import '../../presentation/screens/login_screen.dart';
import '../../presentation/screens/main_screen.dart';
import '../../presentation/screens/dashboard_screen.dart';
import '../../presentation/screens/portfolio_screen.dart';
import '../../presentation/screens/ai_assistant_screen.dart';
import '../../presentation/screens/market_screen.dart';
import '../../presentation/screens/history_screen.dart';

// Global keys for navigation without context if needed
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String portfolio = '/portfolio';
  static const String aiAssistant = '/ai-assistant';
  static const String market = '/market';
  static const String history = '/history';

  static final router = GoRouter(
    initialLocation: splash,
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      // ── Splash ─────────────────────────────────────────────────────────────
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // ── Public Routes ──────────────────────────────────────────────────────
      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),

      // ── Main Shell (Tabs) ──────────────────────────────────────────────────
      // Using StatefulShellRoute to maintain state between tabs
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScreen(navigationShell: navigationShell);
        },
        branches: [
          // Branch Dashboard
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: dashboard,
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          // Branch Portfolio
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: portfolio,
                builder: (context, state) => const PortfolioScreen(),
              ),
            ],
          ),
          // Branch AI Assistant
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: aiAssistant,
                builder: (context, state) => const AiAssistantScreen(),
              ),
            ],
          ),
          // Branch Market
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: market,
                builder: (context, state) => const MarketScreen(),
              ),
            ],
          ),
          // Branch History
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: history,
                builder: (context, state) => const HistoryScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
