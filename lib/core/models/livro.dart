import 'categoria.dart';

class Livro{
  final int isbn;
  final String titulo;
  final String autor;
  final String anopublicado;

  final int n_exemplares;
  final int n_disponiveis;

  final Categoria categoria;

  Livro({
   required this.isbn,
   required this.titulo,
   required this.autor,
   required this.anopublicado,
   required this.n_exemplares,
   required this.n_disponiveis,
   required this.categoria
  });

  Map<String, dynamic> toMap(){
    return{
      'isbn' : isbn,
      'titulo': titulo,
      'autor': autor,
      'anopublicado': anopublicado,
      'n_exemplares' : n_exemplares,
      'n_disponiveis' : n_disponiveis,
      'categoria' : categoria
    };
  }

  factory Livro.fromMap(Map<String, dynamic> map){
    return Livro(
      isbn : map['isbn'],
      titulo : map['titulo'],
      autor: map['autor'],
      anopublicado: map['anopublicado'],
      n_exemplares: map['n_exemplares'],
      n_disponiveis: map['n_disponiveis'],
      categoria: map['categoria'],
    );
  }
}