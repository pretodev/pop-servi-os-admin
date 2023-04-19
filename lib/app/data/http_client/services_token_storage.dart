import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ServicesTokenStorage {
  final _secureStorage = const FlutterSecureStorage();

  static const _tokenKey = 'secure.auth.token';

  Future<void> setToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  Future<String?> get token async {
    return _secureStorage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _secureStorage.delete(key: _tokenKey);
  }
}
