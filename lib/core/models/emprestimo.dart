import 'package:bibliotecadigital_mobile/core/dao/livroDAO.dart';
import 'package:bibliotecadigital_mobile/core/models/user.dart';
import 'package:flutter/cupertino.dart';

import 'livro.dart';

class Emprestimo {
  final int? id;

  Livro livro;
  User usuario;

  final DateTime datapego;
  final DateTime dataprazo;
  final String status;

  Emprestimo({
    this.id,
    required this.usuario,
    required this.livro,
    required this.datapego,
    required this.dataprazo,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'livro': livro.toMap(),
      'usuario': usuario.toMap(),
      'datapego': datapego.toString(),
      'dataprazo': dataprazo.toString(),
      'status': status,
    };
  }

  factory Emprestimo.fromMap(Map<String, dynamic> map, Livro livro, User usuario) {

    return Emprestimo(
      id: map['emprestimo_id'] ?? map['id'],

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

      livro: Livro.fromMap(map['livro']),
      usuario: User.fromMap(map['usuario']),

      datapego: DateTime.parse(map['datapego']),
      dataprazo: DateTime.parse(map['dataprazo']),

      status: map['status'],
    );
  }
}
