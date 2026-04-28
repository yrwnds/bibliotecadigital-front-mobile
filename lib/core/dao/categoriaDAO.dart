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

  Future<int> updateCategoria(Categoria categoria) async{
    final db = await AppDatabase().database;
    final result = await db.update(table, categoria.toMap(), where: 'id = ?', whereArgs: [categoria.id]);
    return result;
  }

  Future<int> deleteCategoria(int id) async {
    final db = await AppDatabase().database;
    return await db.delete('categorias', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Categoria>> getCategorias() async {
    final db = await AppDatabase().database;
    final result = await db.query(
      'categorias',
      orderBy: 'nome ASC',
    );
    return result.map((e) => Categoria.fromMap(e)).toList();
  }
}