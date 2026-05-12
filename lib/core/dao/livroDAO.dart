import 'package:bibliotecadigital_mobile/core/dao/categoriaDAO.dart';

import '../app_database.dart';
import '../models/categoria.dart';
import '../models/livro.dart';

class LivroDao{
  static const String table = 'livros';

  Future<int> insertLivro (Livro livro) async{
    final db = await AppDatabase().database;
    return db.insert(table, livro.toMap());
  }

  Future<Livro?> getLivro(int isbn) async {
    final db = await AppDatabase().database;
    final result = await db.query(
      table,
      where: 'isbn = ?',
      whereArgs : [isbn],
    );
    return result.isNotEmpty ? Livro.fromMap(result.first) : null;
  }

  Future<int> updateLivro(Livro livro) async{
    final db = await AppDatabase().database;
    final result = await db.update(table, livro.toMap(), where: 'isbn = ?', whereArgs: [livro.isbn]);
    return result;
  }

  Future<int> deleteLivro(int isbn) async {
    final db = await AppDatabase().database;
    return await db.delete('livros', where: 'isbn = ?', whereArgs: [isbn]);
  }

  Future<List<Livro>> getLivros() async {
    final db = await AppDatabase().database;
    final result = await db.query(
    'livros',
    orderBy: 'titulo ASC',
    );
    final List<Categoria> categorias = await CategoriaDao().getCategorias();
    final List<Livro> livros = result.map((e) => Livro.fromMap(e)).toList();
    livros.map(
            (e) => e.categoria = categorias.firstWhere(
                (c) => result.firstWhere(
                    (r) => r["isbn"] == e.isbn)["categoria_id"] == c.id
        )
    );
    return livros;
  }
}