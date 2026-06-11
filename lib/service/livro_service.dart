import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/models/livro.dart';
import 'auth_service.dart';

class LivroService {
  final AuthService _authService = AuthService();
  final String _baseUrl = "http://10.0.2.2:8080/poow2/livros";

  Future<Map<String, String>> _getHeaders() async {
    final token = await _authService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }


  Future<List<Livro>> getLivros() async {
    final headers =  await _getHeaders();
    final response = await http.get(
        Uri.parse(_baseUrl), headers: headers);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Livro.fromMap(json)).toList();
    } else {
      throw Exception('Falha ao carregar livros');
    }
  }
}

