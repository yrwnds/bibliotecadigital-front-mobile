import '../app_database.dart';
import '../models/categoria.dart';

class CategoriaDao {
  static const String table = 'livros';

  Future<int> insertCategoria(Categoria livro) async {
    final db = await AppDatabase().database;
    return db.insert(table, livro.toMap());
  }

  Future<Categoria?> getCategoria(int id) async {
    final db = await AppDatabase().database;
    final result = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? Categoria.fromMap(result.first) : null;
  }
}