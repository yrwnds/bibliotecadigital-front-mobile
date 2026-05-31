import '../app_database.dart';
import '../models/emprestimo.dart';
import '../models/livro.dart';
import '../models/user.dart';

class EmprestimoDao {
  static const String table = 'emprestimo';

  Future<int> insertEmprestimo(Livro livro, User usuario) async {
    final db = await AppDatabase().database;

    DateTime data = DateTime.now().toUtc();
    DateTime dataprazo = data.add(const Duration(days: 7));

    Emprestimo e = Emprestimo(
      livro: livro,
      usuario: usuario,
      datapego: data,
      dataprazo: dataprazo,
      status: 'ATIVO',
    );

    final result = db.insert(table, e.toMap());

    await db.update(
      'livros',
      {'n_disponivel': livro.n_disponivel - 1},
      where: 'isbn = ?',
      whereArgs: [livro.isbn],
    );

    return result;
  }

  Future<int> atualizarEmprestimo(Emprestimo emprestimo) async {
    final db = await AppDatabase().database;

    DateTime data = DateTime.now().toUtc();
    DateTime novoprazo = data.add(const Duration(days: 7));

    final result = await db.update(
      table,
      {'dataprazo': novoprazo},
      where: 'id = ? ',
      whereArgs: [emprestimo.id],
    );

    return result;
  }

  Future<int> devolverLivro(Emprestimo emprestimo) async {
    final db = await AppDatabase().database;

    final result = await db.update(
      table,
      {'status': 'INATIVO'},
      where: 'id = ?',
      whereArgs: [emprestimo.id],
    );

    await db.update(
      'livros',
      {'n_disponivel': emprestimo.livro.n_disponivel + 1},
      where: 'isbn = ?',
      whereArgs: [emprestimo.livro.isbn],
    );

    return result;
  }

  Future<Emprestimo?> getEmprestimo(int id) async {
    final db = await AppDatabase().database;

    final result = await db.query(table, where: 'id = ?', whereArgs: [id]);

    return result.isNotEmpty ? Emprestimo.fromMap(result.first) : null;
  }

  Future<int> updateEmprestimo(Emprestimo emprestimo) async {
    final db = await AppDatabase().database;

    final result = await db.update(
      table,
      emprestimo.toMap(),
      where: 'id = ?',
      whereArgs: [emprestimo.id],
    );

    return result;
  }

  Future<int> deleteEmprestimo(int id) async {
    final db = await AppDatabase().database;

    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Emprestimo>> getEmprestimos() async {
    final db = await AppDatabase().database;

    final result = await db.query(table, orderBy: 'datapego DESC');

    return result.map((e) => Emprestimo.fromMap(e)).toList();
  }
}
