import 'package:flutter/material.dart';

class UserMenuDeleteDialog extends StatelessWidget {
  const UserMenuDeleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const Text('Tem certeza que deseja apagar sua conta?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Não'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Sim'),
        ),
      ],
    );
  }
}
