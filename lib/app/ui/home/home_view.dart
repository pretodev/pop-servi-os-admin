import 'package:flutter/material.dart';
import 'package:flutter_application_3/app/auth_store.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final authStore = context.read<AuthStore>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tela inicial"),
      ),
      body: Center(
        child: TextButton(
          onPressed: authStore.logout,
          child: const Text('Sair'),
        ),
      ),
    );
  }
}
