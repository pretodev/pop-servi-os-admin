import 'package:flutter_application_3/app/data/failures/invalid_image_file_failure.dart';
import 'package:flutter_application_3/app/data/failures/user_not_exists_failure.dart';
import 'package:flutter_application_3/app/data/http_client/services_http_client.dart';
import 'package:flutter_application_3/app/data/http_client/services_http_error.dart';

import 'model/user_model.dart';

class UserService {
  final ServicesHttpClient _httpClient;

  UserService({
    required ServicesHttpClient httpClient,
  }) : _httpClient = httpClient;

  Future<UserModel> get user async {
    try {
      final data = await _httpClient.get('/user');
      return UserModel.fromMap(data);
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

  Future<void> setUserImage(String imagePath) async {
    try {
      await _httpClient.uploadFile('/user/image', filePath: imagePath);
    } on ServicesHttpError catch (error) {
      if (error.statusCode == 400) {
        throw InvalidImageFileFailure();
      }
      rethrow;
    }
  }

  Future<void> deleteUser() async {
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
