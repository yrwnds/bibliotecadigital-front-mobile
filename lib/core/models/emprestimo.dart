
import 'package:bibliotecadigital_mobile/core/models/user.dart';

import 'livro.dart';

class Emprestimo {
  final int id;
  final Livro livro;
  final User usuario;
  final DateTime datapego;
  final DateTime dataprazo;
  final String status;

  Emprestimo({
    required this.id,
    required this.livro,
    required this.usuario,
    required this.datapego,
    required this.dataprazo,
    required this.status});

  Map<String, dynamic> toMap(){
    return{
      'id' : id,
      'livro' : id,
      'usuario' : usuario,
      'datapego' : datapego,
      'dataprazo' : dataprazo,
      'status' : status
    };
  }

  factory Emprestimo.fromMap(Map<String, dynamic> map){
    return Emprestimo(
      id : map['id'],
      livro: map['livro'],
      usuario: map['usuario'],
      datapego: map['datapego'],
      dataprazo: map['dataprazo'],
      status: map['status'],
    );
  }
}