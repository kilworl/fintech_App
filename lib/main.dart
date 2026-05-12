import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/di/injection_container.dart' as di;
import 'core/navigation/app_router.dart';
import 'presentation/providers/fund_provider.dart';
import 'presentation/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init(); 
  await initializeDateFormatting('es_CO', null);
  runApp(const FinanTechApp());
}

class FinanTechApp extends StatelessWidget {
  const FinanTechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<FundProvider>()),
      ],
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: MaterialApp.router(
          title: 'FinanTech FPV/FIC',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          routerConfig: AppRouter.router, // Navigator 2.0 integration
        ),
      ),
    );
  }
}
