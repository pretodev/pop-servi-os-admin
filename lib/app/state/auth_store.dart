import 'package:flutter/material.dart';
import 'package:flutter_application_3/app/data/auth_service.dart';
import 'package:flutter_application_3/app/data/model/credentials_model.dart';

import '../data/model/register_user_model.dart';

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

  void _setStatus(AuthStatus status) {
    _status = status;
    notifyListeners();
  }

  void loadAuthStatus() async {
    _setStatus(
      await _authService.isAuthenticated()
          ? AuthStatus.authenticated
          : AuthStatus.unauthenticated,
    );
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final credentials = CredentialsModel(email: email, password: password);
    await _authService.login(credentials);
    _setStatus(AuthStatus.authenticated);
  }

  void logout() async {
    await _authService.logout();
    _setStatus(AuthStatus.unauthenticated);
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final model =
        RegisterUserModel(name: name, email: email, password: password);
    await _authService.register(model);
    _setStatus(AuthStatus.authenticated);
  }
}
