import 'package:flutter_application_3/app/data/failures/exists_user_failure.dart';
import 'package:flutter_application_3/app/data/failures/invalid_credentials_failure.dart';
import 'package:flutter_application_3/app/data/http_client/services_http_client.dart';
import 'package:flutter_application_3/app/data/http_client/services_http_error.dart';
import 'package:flutter_application_3/app/data/http_client/services_token_storage.dart';
import 'package:flutter_application_3/app/data/model/credentials_model.dart';

import 'failures/user_not_exists_failure.dart';
import 'model/register_user_model.dart';

class AuthService {
  final ServicesHttpClient _httpClient;
  final ServicesTokenStorage _tokenStorage;

  AuthService({
    required ServicesHttpClient httpClient,
    required ServicesTokenStorage tokenStorage,
  })  : _httpClient = httpClient,
        _tokenStorage = tokenStorage;

  Future<void> login(CredentialsModel credentials) async {
    try {
      final data = await _httpClient.post('/login', body: {
        'email': credentials.email,
        'password': credentials.password,
      });
      await _tokenStorage.setToken(data['token']);
    } on ServicesHttpError catch (error) {
      if (error.statusCode == 404) {
        throw UserNotExistsFailure();
      }

      if (error.statusCode == 401) {
        throw InvalidCredentialsFailure();
      }
      rethrow;
    }
  }

  Future register(RegisterUserModel model) async {
    try {
      final data = await _httpClient.post('/users', body: {
        'email': model.email,
        'password': model.password,
        'name': model.name
      });
      await _tokenStorage.setToken(data['token']);
    } on ServicesHttpError catch (error) {
      if (error.statusCode == 409) {
        throw ExistsUserFailure();
      }
      rethrow;
    }
  }

  Future<bool> isAuthenticated() async {
    final token = await _tokenStorage.token;
    return token != null;
  }

  Future<void> logout() async {
    await _tokenStorage.deleteToken();
  }
}
