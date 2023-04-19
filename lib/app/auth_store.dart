import 'package:flutter/material.dart';
import 'package:flutter_application_3/app/data/auth_service.dart';

enum AuthStatus {
  waiting,
  authenticated,
  unauthenticated,
}

class AuthStore extends ChangeNotifier {
  final AuthService _authService;

  AuthStore({
    required AuthService authService,
  }) : _authService = authService;

  AuthStatus _status = AuthStatus.waiting;

  AuthStatus get status => _status;

  void loadAuthStatus() async {
    if (await _authService.isAuthenticated()) {
      _status = AuthStatus.authenticated;
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  void logout() async {
    await _authService.logout();
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
