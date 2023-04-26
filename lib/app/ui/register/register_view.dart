import 'package:flutter/material.dart';
import 'package:flutter_application_3/app/state/auth_store.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  String _name = '';
  String _email = '';
  String _password = '';

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  late final AuthStore _authStore = context.read();

  final _formKey = GlobalKey<FormState>();

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await _authStore.register(
        name: _name,
        email: _email,
        password: _password,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de usuário'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                focusNode: _nameFocus,
                initialValue: _name,
                onSaved: (value) => _name = value ?? '',
                decoration: const InputDecoration(
                  labelText: 'Nome',
                ),
                onFieldSubmitted: (_) => _emailFocus.requestFocus(),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                focusNode: _emailFocus,
                initialValue: _email,
                onSaved: (value) => _email = value ?? '',
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                focusNode: _passwordFocus,
                initialValue: _password,
                onSaved: (value) => _password = value ?? '',
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                ),
                onFieldSubmitted: (_) {},
              ),
              const SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
