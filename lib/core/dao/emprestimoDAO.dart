import '../app_database.dart';
import '../models/emprestimo.dart';

class EmprestimoDao {
  static const String table = 'livros';

  Future<int> insertEmprestimo(Emprestimo livro) async {
    final db = await AppDatabase().database;
    return db.insert(table, livro.toMap());
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
}