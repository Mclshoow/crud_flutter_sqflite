import 'package:crud_flutter_sqflite/database/user_db.dart';
import 'package:crud_flutter_sqflite/model/user.dart';
import 'package:crud_flutter_sqflite/widget/create_user_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  Future<List<User>>? futureUsers;
  final userDB = UserDB();

  @override
  void initState() {
    super.initState();

    fetchUsers();
  }

  void fetchUsers() {
    setState(() {
      futureUsers = userDB.fetchAll();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Users List'),
        ),
        body: FutureBuilder<List<User>>(
          future: futureUsers,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              final users = snapshot.data!;

              return users.isEmpty
                  ? const Center(
                      child: Text(
                        'No users...',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                    )
                  : ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return ListTile(
                          title: Text(
                            user.nome,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(user.email),
                          trailing: IconButton(
                            onPressed: () async {
                              await userDB.delete(user.id);
                              fetchUsers();
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => CreateUserWidget(
                                user: user,
                                onSubmit: (user) async {
                                  await userDB.update(
                                      id: user.id,
                                      nome: user.nome,
                                      numero: user.numero,
                                      email: user.email);
                                  fetchUsers();
                                  if (!mounted) return;
                                  Navigator.of(context).pop();
                                },
                              ),
                            );
                          },
                        );
                      },
                    );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => CreateUserWidget(
                onSubmit: (user) async {
                  await userDB.create(
                    nome: user.nome,
                    numero: user.numero,
                    email: user.email,
                  );
                  if (!mounted) return;
                  fetchUsers();
                  Navigator.of(context).pop();
                },
              ),
            );
          },
        ),
      );
}
