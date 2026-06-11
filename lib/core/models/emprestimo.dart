import 'package:bibliotecadigital_mobile/core/dao/livroDAO.dart';
import 'package:bibliotecadigital_mobile/core/models/user.dart';
import 'package:flutter/cupertino.dart';

import 'livro.dart';

class Emprestimo {
  final int? id;

  Livro? livro;
  final int livro_ISBN;

  User? usuario;
  final int usuario_id;

  final DateTime datapego;
  final DateTime dataprazo;
  final String status;

  Emprestimo({
    this.id,
    this.livro,
    required this.livro_ISBN,
    this.usuario,
    required this.usuario_id,
    required this.datapego,
    required this.dataprazo,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'livro_ISBN': livro_ISBN,
      'usuario_id': usuario_id,
      'datapego': datapego.toString(),
      'dataprazo': dataprazo.toString(),
      'status': status,
    };
  }

  factory Emprestimo.fromMap(Map<String, dynamic> map, Livro livro, User usuario) {

    return Emprestimo(
      id: map['emprestimo_id'] ?? map['id'],

      livro_ISBN: map['livro_ISBN'],
      usuario_id: map['usuario_id'],

      livro: livro,
      usuario: usuario,

      datapego: DateTime.parse(map['datapego']),
      dataprazo: DateTime.parse(map['dataprazo']),

      status: map['status'],
    );
  }

  factory Emprestimo.fromMapGet(Map<String, dynamic> map){
    return Emprestimo(
      id: map['emprestimo_id'] ?? map['id'],

      livro_ISBN: map['livro_ISBN'],
      usuario_id: map['usuario_id'],

      livro: null,
      usuario: null,

      datapego: DateTime.parse(map['datapego']),
      dataprazo: DateTime.parse(map['dataprazo']),

      status: map['status'],
    );
  }
}
