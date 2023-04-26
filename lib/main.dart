import 'package:flutter/material.dart';
import 'package:flutter_application_3/app.dart';
import 'package:flutter_application_3/app/data/auth_service.dart';
import 'package:flutter_application_3/app/data/http_client/services_http_client.dart';
import 'package:flutter_application_3/app/data/http_client/services_token_storage.dart';
import 'package:flutter_application_3/app/data/user_service.dart';
import 'package:flutter_application_3/app/state/auth_store.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(MultiProvider(
    providers: [
      Provider(
        create: (context) => ServicesTokenStorage(),
      ),
      Provider(
        create: (context) => ServicesHttpClient(
          tokenStorage: context.read(),
        ),
      ),
      Provider(
        create: (context) => AuthService(
          httpClient: context.read(),
          tokenStorage: context.read(),
        ),
      ),
      Provider(
        create: (context) => UserService(
          httpClient: context.read(),
        ),
      ),
      ChangeNotifierProvider(
        create: (context) => AuthStore(
          authService: context.read(),
        ),
      ),
    ],
    child: const App(),
  ));
}
