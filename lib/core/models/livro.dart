import 'categoria.dart';

class Livro{
  final int? isbn;
  final String titulo;
  final String autor;
  final String anopublicado;

  int n_exemplares;
  int n_disponivel;

   Categoria? categoria;

  Livro({
   this.isbn,
   required this.titulo,
   required this.autor,
   required this.anopublicado,
   required this.n_exemplares,
   required this.n_disponivel,
    this.categoria
  });

  Map<String, dynamic> toMap(){
    return{
      'isbn' : isbn,
      'titulo': titulo,
      'autor': autor,
      'anopublicado': anopublicado,
      'n_exemplares' : n_exemplares,
      'n_disponivel' : n_disponivel,
      'categoria' : categoria
    };
  }

  factory Livro.fromMap(Map<String, dynamic> map){
    return Livro(
      isbn : map['isbn'],
      titulo : map['titulo'],
      autor: map['autor'],
      anopublicado: map['anopublicado'],
      n_exemplares: map['n_exemplares'] ?? 0,
      n_disponivel: map['n_disponivel'] ?? 0,
      categoria: map['categoria'],
    );
  }
}