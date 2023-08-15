import 'package:asyncstate/widget/async_state_builder.dart';

import 'package:flutter/material.dart';

import 'features/auth/login/login_page.dart';
import 'features/core/ui/barbershop_theme.dart';
import 'features/core/ui/widgets/barbershop_loader.dart';
import 'features/splash/splash_page.dart';

class BarbershopApp extends StatelessWidget {
  const BarbershopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AsyncStateBuilder(
      customLoader: const BarbershopLoader(),
      builder: (asyncNavigatorObserver) {
        return MaterialApp(
          title: 'Barbershop',
          debugShowCheckedModeBanner: false,
          theme: BarbershopTheme.themeData,
          navigatorObservers: [asyncNavigatorObserver],
          routes: {
            '/': (_) => const SplashPage(),
            '/auth/login': (_) => const LoginPage(),
          },
        );
      },
    );
  }
}
