import 'package:bibliotecadigital_mobile/core/app_database.dart';

import '../models/user.dart';

class userDao{
  static const String table = 'usuarios';

  Future<int> insertUser(User usuario) async {
    final db = await AppDatabase().database;
    return db.insert(table, usuario.toMap());
  }

    Future<User?> getUser(String email, String senha) async {
      final db = await AppDatabase().database;
      final result = await db.query(
        table,
        where: 'email = ? AND senha = ?',
        whereArgs : [email, senha],
      );
      return result.isNotEmpty ? User.fromMap(result.first) : null;
    }

    Future<User?> getUserId(int id) async {
    final db = await AppDatabase().database;
    final result = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id]
    );
    return result.isNotEmpty? User.fromMap(result.first) : null;
    }

    Future<int> updateUser(User user) async{
    final db = await AppDatabase().database;
    final result = await db.update(table, user.toMap(), where: 'id = ?', whereArgs: [user.id]);
    return result;
    }

  Future<int> deleteUser(int id) async {
    final db = await AppDatabase().database;
    return await db.delete('usuarios', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<User>> getUsers() async {
    final db = await AppDatabase().database;
    final result = await db.query(
      'usuarios',
      orderBy: 'nome ASC',
    );
    return result.map((e) => User.fromMap(e)).toList();
  }


}