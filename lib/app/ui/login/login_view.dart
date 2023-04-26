import 'package:flutter/material.dart';
import 'package:flutter_application_3/app/data/failures/user_not_exists_failure.dart';
import 'package:flutter_application_3/app/state/auth_store.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final AuthStore _authStore = context.read();

  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';

  void _showRegister() {
    Navigator.of(context).pushNamed('/register');
  }

  void _submitData() async {
    try {
      final valid = _formKey.currentState?.validate() ?? false;
      if (valid) {
        _formKey.currentState?.save();
        await _authStore.login(email: _email, password: _password);
      }
    } on UserNotExistsFailure {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Usuário não cadastrado. Faça seu cadastro.'),
          action: SnackBarAction(
            label: 'Registrar agora',
            onPressed: _showRegister,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  onSaved: (value) => _email = value ?? '',
                  validator: (value) =>
                      value?.isEmpty ?? false ? 'Campo obrigatório' : null,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  validator: (value) =>
                      value?.isEmpty ?? false ? 'Campo obrigatório' : null,
                  onSaved: (value) => _password = value ?? '',
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: _submitData,
                  child: const Text('Entrar'),
                ),
                const SizedBox(height: 8.0),
                TextButton(
                  onPressed: _showRegister,
                  child: const Text('Cadastrar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
