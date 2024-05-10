import 'package:flutter/material.dart';
import 'package:crud_flutter_sqflite/model/user.dart';

class CreateUserWidget extends StatefulWidget {
  final User? user;
  final ValueChanged<User> onSubmit;

  const CreateUserWidget({
    Key? key,
    this.user,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<CreateUserWidget> createState() => _CreateUserWidgetState();
}

class _CreateUserWidgetState extends State<CreateUserWidget> {
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final numeroController = TextEditingController();
  final idController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.user != null) {
      nomeController.text = widget.user!.nome;
      emailController.text = widget.user!.email;
      numeroController.text = widget.user!.numero.toString();
      idController.text = widget.user!.id.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.user != null;
    return AlertDialog(
      title: Text(isEditing ? 'Edit User' : 'Add User'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nomeController,
              decoration: const InputDecoration(hintText: 'Nome'),
              validator: (value) =>
                  value != null && value.isEmpty ? 'Nome is required' : null,
            ),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(hintText: 'E-mail'),
              validator: (value) =>
                  value != null && value.isEmpty ? 'E-mail is required' : null,
            ),
            TextFormField(
              controller: numeroController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Número'),
              validator: (value) =>
                  value != null && value.isEmpty ? 'Número is required' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              final nome = nomeController.text;
              final email = emailController.text;
              final numero = int.tryParse(numeroController.text) ?? 0;
              final id = int.tryParse(idController.text) ?? 0;
              final newUser =
                  User(id: id, nome: nome, email: email, numero: numero);
              widget.onSubmit(newUser);
            }
          },
          child: const Text('Ok'),
        )
      ],
    );
  }
}
