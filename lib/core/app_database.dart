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
    await _db?.execute('PRAGMA foreign_keys = ON');
    return _db!;
  }

  Future<Database> _initDatabase() async{
    final path = join(await getDatabasesPath(), 'bibliodigital.db');
    return openDatabase(path,
      version: 2,
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
      
      FOREIGN KEY key (categoria_id) REFERENCES categorias(id)
      );
      
      CREATE TABLE emprestimo(
      id         INTEGER PRIMARY KEY AUTOINCREMENT,
      livro_ISBN INTEGER,
      usuario_id INTEGER,
      datapego   timestamptz,
      dataprazo  timestamptz,
      status     TEXT,

      FOREIGN KEY (livro_ISBN) REFERENCES livros (ISBN),
      FOREIGN KEY (usuario_id) REFERENCES usuarios (id)
      );
      ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async{
      if (oldVersion < 2) {
        await db.execute(
            '''
            INSERT INTO categorias (nome) VALUES
            ('Romance'),
            ('Fantasia'),
            ('Sci-fi'),
            ('Terror'),
            ('Biografia'),
            ('Crime'),
            ('Clássico'),
            ('Literatura brasileira'),
            ('Ficção Histórica'),
            ('História'),
            ('Filosofia'),
            ('Psicologia'),
            ('Infantil'),
            ('Infanto-Juvenil'),
            ('Auto-Ajuda'),
            ('Poesia'),
            ('Velho-Oeste'),
            ('Religião'),
            ('Ação');
            
            INSERT INTO livros (titulo, autor, anopublicado, categoria_id, linguagem, n_exemplares, n_disponivel)
            VALUES ('Dom Casmurro', 'Machado de Assis', '1899', 8, 'Português', 5, 5),
            ('A Hora da Estrela', 'Clarice Lispector', '1977', 8, 'Português', 5, 5),
            ('A Paixão de Acordo com G.H.', 'Clarice Lispector', '1964', 8, 'Português', 5, 5),
            ('The Complete Poems of Emily Dickinson', 'Emily Dickinson', '1890', 16, 'Inglês', 5, 5),
            ('A Wizard of Earthsea', 'Ursula K Le Guin', '1968', 2, 'Inglês', 5, 5),
            ('Crime and Punishment', 'Fyodor Dostoyevsky', '1866', 7, 'Inglês', 5, 5),
            ('100 Años de Soledad', 'Gabriel García Marquez', '1967', 7, 'Espanhol', 5, 5);
           
            '''
        );
      }
      }
    );
  }

}