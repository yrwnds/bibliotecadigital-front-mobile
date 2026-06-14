import 'dart:convert';

import 'package:bibliotecadigital_mobile/core/models/emprestimo.dart';
import 'package:http/http.dart' as http;

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
    final headers =  await _getHeaders();
    final response = await http.get(
        Uri.parse('$_baseUrl/listar'), headers: headers);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Emprestimo.fromMapGet(json)).toList();
    } else {
      print('STATUSCODE: ${response.statusCode}');
      print('RESPONSE: ${response.body}');
      throw Exception('Falha ao carregar livros');
    }
  }
}