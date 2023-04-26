import 'dart:convert';

import 'package:flutter_application_3/app/data/http_client/services_http_error.dart';
import 'package:flutter_application_3/app/data/http_client/services_token_storage.dart';
import 'package:http/http.dart' as http;

class ServicesHttpClient {
  static const _baseUrl = 'http://10.0.3.2:8055';

  final ServicesTokenStorage _tokenStorage;

  ServicesHttpClient({
    required ServicesTokenStorage tokenStorage,
  }) : _tokenStorage = tokenStorage;

  dynamic _parseResponse(http.Response response) {
    final map = jsonDecode(response.body);
    if (response.statusCode >= 400) {
      final message = map['message'] ?? map['error'];

      throw ServicesHttpError(
        message: message,
        statusCode: response.statusCode,
      );
    }
    return map;
  }

  Future<Map<String, String>> _withToken(
    Map<String, String> headers,
  ) async {
    final token = await _tokenStorage.token;
    final requestHeaders = <String, String>{...headers};
    if (token != null) {
      requestHeaders['Authorization'] = 'Bearer $token';
    }
    return requestHeaders;
  }

  Future<dynamic> post(
    String path, {
    Map<String, dynamic> body = const {},
    Map<String, String> headers = const {},
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$path'),
      body: jsonEncode(body),
      headers: await _withToken(headers),
    );
    return _parseResponse(response);
  }

  Future<dynamic> get(
    String path, {
    Map<String, String> headers = const {},
  }) async {
    final response = await http.get(
      Uri.parse('$_baseUrl$path'),
      headers: await _withToken(headers),
    );
    return _parseResponse(response);
  }

  Future<dynamic> patch(
    String path, {
    Map<String, dynamic> body = const {},
    Map<String, String> headers = const {},
  }) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl$path'),
      body: jsonEncode(body),
      headers: await _withToken(headers),
    );
    return _parseResponse(response);
  }

  Future<dynamic> delete(
    String path, {
    Map<String, String> headers = const {},
  }) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl$path'),
      headers: await _withToken(headers),
    );
    return _parseResponse(response);
  }

  Future<void> uploadFile(
    String path, {
    required String filePath,
    Map<String, String> headers = const {},
  }) async {
    final request = http.MultipartRequest('POST', Uri.parse('$_baseUrl$path'));
    final requestHeaders = await _withToken(headers);
    for (final key in requestHeaders.keys) {
      final value = requestHeaders[key];
      if (value != null) {
        request.headers[key] = value;
      }
    }
    request.files.add(await http.MultipartFile.fromPath('image', filePath));
    final response = await request.send();
    if (response.statusCode >= 400) {
      final map = jsonDecode(await response.stream.join());
      final message = map['message'] ?? map['error'];
      throw ServicesHttpError(
        message: message,
        statusCode: response.statusCode,
      );
    }
  }
}
