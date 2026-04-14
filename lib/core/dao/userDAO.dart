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


}