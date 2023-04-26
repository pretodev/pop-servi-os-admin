import 'package:flutter/material.dart';
import 'package:flutter_application_3/app/state/auth_store.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final authStore = context.read<AuthStore>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tela inicial"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/user-menu');
            },
            icon: const Icon(Icons.person),
          ),
        ],
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
