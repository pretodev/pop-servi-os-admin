import 'package:flutter/material.dart';
import 'package:flutter_application_3/app/data/model/user_model.dart';
import 'package:flutter_application_3/app/data/user_service.dart';
import 'package:flutter_application_3/app/state/auth_store.dart';
import 'package:flutter_application_3/app/ui/user_menu/user_menu_delete_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../async_snapshot/async_snapshot.dart';

class UserMenuView extends StatefulWidget {
  const UserMenuView({super.key});

  @override
  State<UserMenuView> createState() => _UserMenuViewState();
}

class _UserMenuViewState extends State<UserMenuView> {
  final _imagePicker = ImagePicker();

  late final UserService _userService = context.read();
  late final AuthStore _authStore = context.read();

  AsyncSnapshot<UserModel> _userSnap = const AsyncSnapshot.nothing();

  void _deleteUser() async {
    final result = await showDialog(
      context: context,
      builder: (context) => const UserMenuDeleteDialog(),
    );
    if (result != null && result) {
      await _userService.deleteUser();
      _logout();
    }
  }

  void _loadUser() async {
    setState(() => _userSnap = waiting());
    final user = await _userService.user;
    setState(() => _userSnap = withData(user));
  }

  void _logout() {
    _authStore.logout();
  }

  void _uploadImage(XFile file) async {
    await _userService.setUserImage(file.path);
    _loadUser();
  }

  void _saveImageFromCamera() async {
    final image = await _imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      _uploadImage(image);
    }
  }

  void _saveImageFromGalery() async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _uploadImage(image);
    }
  }

  Future<void> _selectImageSource() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Câmera'),
                onTap: _saveImageFromCamera,
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Galeria'),
                onTap: _saveImageFromGalery,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dados do usuário'),
      ),
      body: Builder(builder: (context) {
        if (_userSnap.connectionState == ConnectionState.done) {
          final user = _userSnap.data!;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(user.photoUrl),
                    ),
                    TextButton(
                      onPressed: _selectImageSource,
                      child: const Text('Alterar imagem'),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(user.name),
                subtitle: const Text('Nome do usuário'),
              ),
              ListTile(
                leading: const Icon(Icons.email),
                title: Text(user.email),
                subtitle: const Text('E-mail do usuário'),
              ),
              ListTile(
                onTap: _deleteUser,
                iconColor: Colors.redAccent,
                textColor: Colors.redAccent,
                leading: const Icon(Icons.close),
                title: const Text('Apagar minha conta'),
              ),
              ListTile(
                onTap: _logout,
                leading: const Icon(Icons.logout),
                title: const Text('Sair'),
              ),
            ],
          );
        }

        return const Center(child: CircularProgressIndicator());
      }),
    );
  }
}
