import 'package:flutter_application_3/app/data/failures/user_not_exists_failure.dart';
import 'package:flutter_application_3/app/data/http_client/services_http_client.dart';
import 'package:flutter_application_3/app/data/http_client/services_http_error.dart';

class UserService {
  final ServicesHttpClient _httpClient;

  UserService({
    required ServicesHttpClient httpClient,
  }) : _httpClient = httpClient;

  Future get user async {
    try {
      final data = await _httpClient.get('/user');
      print(data);
    } on ServicesHttpError catch (error) {
      if (error.statusCode == 404) {
        throw UserNotExistsFailure();
      }
      rethrow;
    }
  }

  Future setName(String name) async {
    try {
      final data = await _httpClient.patch('/user', body: {
        'name': name,
      });
    } on ServicesHttpError catch (error) {
      if (error.statusCode == 404) {
        throw UserNotExistsFailure();
      }
      rethrow;
    }
  }

  Future<void> delete() async {
    try {
      await _httpClient.delete('/user');
    } on ServicesHttpError catch (error) {
      if (error.statusCode == 404) {
        throw UserNotExistsFailure();
      }
      rethrow;
    }
  }
}
