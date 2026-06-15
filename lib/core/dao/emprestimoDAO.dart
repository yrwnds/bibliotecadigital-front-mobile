import 'package:bibliotecadigital_mobile/core/dao/livroDAO.dart';
import 'package:bibliotecadigital_mobile/core/dao/userDAO.dart';
import 'package:sqflite/sqflite.dart';

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
    //  livro_ISBN: livro.isbn!,
   //   usuario_id: usuario.id!,
    );

    final result = await db.insert(table, e.toMap());

    await db.update(
      'livros',
      {'n_disponivel': livro.n_disponivel - 1},
      where: 'isbn = ?',
      whereArgs: [livro.isbn],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return result;
  }

  Future<int> atualizarEmprestimo(Emprestimo emprestimo) async {
    final db = await AppDatabase().database;

    DateTime data = DateTime.now().toUtc();
    String novoprazo = data.add(const Duration(days: 7)).toString();

    final result = await db.update(
      table,
      {'dataprazo': novoprazo},
      where: 'id = ? ',
      whereArgs: [emprestimo.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
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
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await db.update(
      'livros',
      {'n_disponivel': emprestimo.livro!.n_disponivel + 1},
      where: 'isbn = ?',
 //     whereArgs: [emprestimo.livro_ISBN],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return result;
  }

  Future<Emprestimo?> getEmprestimo(int id) async {
    final db = await AppDatabase().database;

    final List<Map<String, dynamic>> maps = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );

    final emprestimoMap = maps.first;

    final int livroIsbn = emprestimoMap['livro_ISBN'];
    final int usuarioId = emprestimoMap['usuario_id'];

    final results = await Future.wait([
      LivroDao().getLivro(livroIsbn),
      userDao().getUserId(usuarioId)
    ]);

    final Livro? livro = results[0] as Livro?;
    final User? usuario = results[1] as User?;

    if (livro == null || usuario == null) {
      throw Exception('Erro ao reconstruir empréstimo.');
    }

    return Emprestimo.fromMap(emprestimoMap, livro, usuario);
  }

  Future<int> updateEmprestimo(Emprestimo emprestimo) async {
    final db = await AppDatabase().database;

    final result = await db.update(
      table,
      emprestimo.toMap(),
      where: 'id = ?',
      whereArgs: [emprestimo.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return result;
  }

  Future<int> deleteEmprestimo(int id) async {
    final db = await AppDatabase().database;

    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Emprestimo>> getEmprestimos() async {
    final db = await AppDatabase().database;

    final List<Map<String, dynamic>> result = await db.query(table, orderBy: 'datapego DESC');

    final List<Emprestimo> emprestimos = [];

    for (var e in result) {
      final Livro? livro = await LivroDao().getLivro(e['livro_ISBN']);
      final User? usuario = await userDao().getUserId(e['usuario_id']);
      if(livro != null && usuario != null){
        emprestimos.add(Emprestimo.fromMap(e, livro, usuario));
    } else{
        throw Exception('Erro ao reconstruir empréstimo.');
      }
  }
    return emprestimos;
  }

  Future<List<Emprestimo>> getEmprestimosAtivosByUser(int userId) async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT * FROM emprestimo WHERE
    usuario_id = ?
    AND status = 'ATIVO'
    ''', [userId]);

    final List<Emprestimo> emprestimos = [];

    for (var e in result) {
      final Livro? livro = await LivroDao().getLivro(e['livro_ISBN']);
      final User? usuario = await userDao().getUserId(e['usuario_id']);
      if(livro != null && usuario != null){
        emprestimos.add(Emprestimo.fromMap(e, livro, usuario));
      } else{
        throw Exception('Erro ao reconstruir empréstimo.');
      }
    }
    return emprestimos;
  }
}
