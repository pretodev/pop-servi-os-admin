import 'package:flutter/material.dart';
import 'package:flutter_application_3/app/state/auth_store.dart';
import 'package:flutter_application_3/app/ui/home/home_view.dart';
import 'package:flutter_application_3/app/ui/login/login_view.dart';
import 'package:flutter_application_3/app/ui/register/register_view.dart';
import 'package:flutter_application_3/app/ui/splash/splash_view.dart';
import 'package:flutter_application_3/app/ui/theme.dart';
import 'package:flutter_application_3/app/ui/user_menu/user_menu_view.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthStore _authStore = context.read();

  final _navigateKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _authStore.addListener(() {
      switch (_authStore.status) {
        case AuthStatus.waiting:
          break;
        case AuthStatus.authenticated:
          _navigateKey.currentState!.pushNamedAndRemoveUntil(
            '/home',
            (_) => false,
          );
          break;
        case AuthStatus.unauthenticated:
          _navigateKey.currentState!.pushNamedAndRemoveUntil(
            '/login',
            (_) => false,
          );
          break;
      }
    });
    _authStore.loadAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.instance,
      navigatorKey: _navigateKey,
      title: 'Serviços da Hora',
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashView(),
        '/login': (context) => const LoginView(),
        '/home': (context) => const HomeView(),
        '/user-menu': (context) => const UserMenuView(),
        '/register': (context) => const RegisterView(),
      },
    );
  }
}
