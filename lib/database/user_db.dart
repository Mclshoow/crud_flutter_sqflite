import 'package:crud_flutter_sqflite/database/database_service.dart';
import 'package:crud_flutter_sqflite/model/user.dart';
import 'package:sqflite/sqflite.dart';

class UserDB {
  final tableName = 'users';

  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName(
      "id" INTEGER NOT NULL,
      "nome" TEXT NOT NULL,
      "numero" INTEGER NOT NULL,
      "email" TEXT NOT NULL,
      PRIMARY KEY("id" AUTOINCREMENT)
      );""");
  }

  Future<int> create(
      {required String nome,
      required int numero,
      required String email}) async {
    final database = await DatabaseService().database;
    return await database.rawInsert(
      '''INSERT INTO $tableName (nome,numero,email) VALUES (?,?,?)''',
      [nome, numero, email],
    );
  }

  Future<List<User>> fetchAll() async {
    final database = await DatabaseService().database;
    final users =
        await database.rawQuery('''SELECT * FROM $tableName ORDER BY id''');
    return users.map((user) => User.fromSqfliteDatabase(user)).toList();
  }

  Future<User> fetchById(int id) async {
    final database = await DatabaseService().database;
    final user = await database
        .rawQuery('''SELECT * FROM $tableName WHERE id = ?''', [id]);
    return User.fromSqfliteDatabase(user.first);
  }

  Future<int> update(
      {required int id,
      required String? nome,
      required int numero,
      required String? email}) async {
    final database = await DatabaseService().database;
    return await database.update(
      tableName,
      {
        if (nome != null && numero != 0 && email != null) 'nome': nome,
        'numero': numero,
        'email': email
      },
      where: 'id = ?',
      conflictAlgorithm: ConflictAlgorithm.rollback,
      whereArgs: [id],
    );
  }

  Future<void> delete(int id) async {
    final database = await DatabaseService().database;
    await database.rawDelete('''DELETE FROM $tableName WHERE id = ?''', [id]);
  }
}
