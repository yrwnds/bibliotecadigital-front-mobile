import 'dart:convert';

import 'package:bibliotecadigital_mobile/core/models/emprestimo.dart';
import 'package:http/http.dart' as http;

import '../core/models/livro.dart';
import '../core/models/user.dart';
import 'auth_service.dart';

class EmprestimoService {
  final AuthService _authService = AuthService();
  final String _baseUrl = "http://10.0.2.2:8080/poow2/emprestimos";

  Future<Map<String, String>> _getHeaders() async {
    final token = await _authService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }


  Future<List<Emprestimo>> getEmprestimos() async {
    final headers = await _getHeaders();
    final usuario = await _authService.getUsuLogado();
    final response = await http.get(
        Uri.parse('$_baseUrl/listarativos'), headers: headers);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final List<Emprestimo> emprestimos = data.map((json) => Emprestimo.fromMapGet(json)).toList();
      return emprestimos.where((emprestimo) => emprestimo.usuario.id == usuario.id).toList();
    } else {
      print('STATUSCODE: ${response.statusCode}');
      print('RESPONSE: ${response.body}');
      throw Exception('Falha ao carregar livros');
    }
  }

  Future<void> novoEmprestimo(Livro livro, User usuario) async {
    if (livro.n_disponivel <= 0) {
      throw Exception("Livro indisponível.");
    }

    final headers = await _getHeaders();

    DateTime data = DateTime.now().toUtc();
    DateTime dataprazo = data.add(const Duration(days: 7));

    Emprestimo e = Emprestimo(usuario: usuario,
        livro: livro,
        datapego: data,
        dataprazo: dataprazo,
        status: 'ATIVO');

    livro.n_disponivel = livro.n_disponivel - 1;

    final response = await http.post(
        Uri.parse('$_baseUrl/emprestar/${e.livro.isbn}/${e.usuario.id}'),
        headers: headers,
        body: jsonEncode(e.toMap())
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Erro ao criar emprestimo.');
    }
  }

  Future<void> atualizarEmprestimo(Emprestimo emprestimo) async {
    final headers = await _getHeaders();

    DateTime data = DateTime.now().toUtc();
    DateTime novoprazo = data.add(const Duration(days: 7));

    Emprestimo e = Emprestimo(livro: emprestimo.livro,
      usuario: emprestimo.usuario,
      datapego: emprestimo.datapego,
      dataprazo: novoprazo,
      status: 'ATIVO',);

    final response = await http.post(
        Uri.parse('$_baseUrl/atualizar/${e.livro.isbn}/${e.usuario.id}'),
        headers: headers,
        body: jsonEncode(e.toMap())
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Erro ao atualizar emprestimo");
    }
  }

  Future<void> devolver(Emprestimo emprestimo) async {
    final headers = await _getHeaders();

    emprestimo.livro.n_disponivel = emprestimo.livro.n_disponivel + 1;

    Emprestimo e = Emprestimo(usuario: emprestimo.usuario,
        livro: emprestimo.livro,
        status: 'INATIVO',
        dataprazo: emprestimo.dataprazo,
        datapego: emprestimo.datapego);

    final response = await http.post(
        Uri.parse('$_baseUrl/devolver/${e.livro.isbn}/${e.usuario.id}'),
        headers: headers,
        body: jsonEncode(e.toMap())
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      print("RESPONSE: ${response.body}");
      throw Exception("Erro ao atualizar emprestimo");
    }
  }
}