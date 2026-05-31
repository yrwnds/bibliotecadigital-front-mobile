
import 'package:bibliotecadigital_mobile/core/models/user.dart';

import 'livro.dart';

class Emprestimo {
  final int? id;
  final Livro livro;
  final User usuario;
  final DateTime datapego;
  final DateTime dataprazo;
  final String status;

  Emprestimo({
    this.id,
    required this.livro,
    required this.usuario,
    required this.datapego,
    required this.dataprazo,
    required this.status});

  Map<String, dynamic> toMap(){
    return{
      'id' : id,
      'livro_ISBN' : livro.isbn,
      'usuario_id' : usuario.id,
      'datapego' : datapego.toString(),
      'dataprazo' : dataprazo.toString(),
      'status' : status
    };
  }

  factory Emprestimo.fromMap(Map<String, dynamic> map){
    return Emprestimo(
      id : map['emprestimo_id'] ?? map['id'],
      livro: Livro.fromMap(map),
      usuario: User.fromMap(map),
      datapego: map['datapego'],
      dataprazo: map['dataprazo'],
      status: map['status'],
    );
  }
}