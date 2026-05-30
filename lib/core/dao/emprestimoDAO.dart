import '../app_database.dart';
import '../models/emprestimo.dart';
import '../models/livro.dart';
import '../models/user.dart';

class EmprestimoDao {
  static const String table = 'emprestimos';

  Future<int> insertEmprestimo(Livro livro, User usuario) async {
    final db = await AppDatabase().database;
    DateTime data = DateTime.now().toUtc();
    DateTime dataprazo = data.add(const Duration(days: 7));
    // if(){
    //
    // } else{
    //
    // } Logica se usuario ja pegou livro emprestado nao deixar
    livro.n_disponivel = livro.n_disponivel-1;
    Emprestimo e = Emprestimo(livro: livro, usuario: usuario, datapego: data, dataprazo: dataprazo, status: 'ATIVO');
    return db.insert(table, e.toMap());
  }

  Future<int> atualizarEmprestimo(Emprestimo emprestimo) async{
    final db = await AppDatabase().database;
    DateTime data = DateTime.now().toUtc();
    DateTime novoprazo = data.add(const Duration(days: 7));
    final result = await db.update(table,
    {'dataprazo': novoprazo},
    where: 'id = ? ',
    whereArgs: [emprestimo.id]);
    return result;
  }

  Future<int> devolverLivro(Emprestimo emprestimo) async{
    final db = await AppDatabase().database;
    emprestimo.livro.n_disponivel = emprestimo.livro.n_disponivel+1;
    final result = await db.update(table,
    {'status': 'INATIVO'},
        where: 'id = ?',
        whereArgs: [emprestimo.id]);
    return result;
  }

  Future<Emprestimo?> getEmprestimo(int id) async {
    final db = await AppDatabase().database;
    final result = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? Emprestimo.fromMap(result.first) : null;
  }

  Future<int> updateEmprestimo(Emprestimo emprestimo) async{
    final db = await AppDatabase().database;
    final result = await db.update(table, emprestimo.toMap(), where: 'id = ?', whereArgs: [emprestimo.id]);
    return result;
  }

  Future<int> deleteEmprestimo(int id) async {
    final db = await AppDatabase().database;
    return await db.delete('emprestimos', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Emprestimo>> getEmprestimos() async {
    final db = await AppDatabase().database;
    final result = await db.query(
      'emprestimos',
      orderBy: 'nome ASC',
    );
    return result.map((e) => Emprestimo.fromMap(e)).toList();
  }
}