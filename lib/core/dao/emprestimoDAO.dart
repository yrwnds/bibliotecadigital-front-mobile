import '../app_database.dart';
import '../models/emprestimo.dart';

class EmprestimoDao {
  static const String table = 'emprestimos';

  Future<int> insertEmprestimo(Emprestimo emprestimo) async {
    final db = await AppDatabase().database;
    return db.insert(table, emprestimo.toMap());
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