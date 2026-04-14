import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();

  static Database? _db;

  factory AppDatabase() => _instance;

  AppDatabase._internal();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async{
    final path = join(await getDatabasesPath(), 'bibliodigital.db');
    return openDatabase(path,
      version: 1,
      onCreate: (db, version) async{
      await db.execute('''
      CREATE TABLE usuarios(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT,
      matricula TEXT,
      email TEXT,
      senha TEXT
      );
      
      CREATE TABLE categorias(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT);
      
      CREATE TABLE livros(
      isbn INTEGER PRIMARY KEY AUTOINCREMENT,
      titulo TEXT,
      autor TEXT,
      anopublicado TEXT,
      
      categoria_id INTEGER,
      
      n_exemplares INTEGER,
      n_disponivel INTEGER
      
      foreign key (categoria_id) references categorias(id)
      );
      
      CREATE TABLE emprestimo(
      id         INTEGER PRIMARY KEY AUTOINCREMENT,
      livro_ISBN INTEGER,
      usuario_id INTEGER,
      datapego   timestamptz,
      dataprazo  timestamptz,
      status     TEXT,

      foreign key (livro_ISBN) references livros (ISBN),
      foreign key (usuario_id) references usuarios (id)
      );
      ''');
      }
    );
  }

}