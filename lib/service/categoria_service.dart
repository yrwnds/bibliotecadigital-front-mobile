import 'dart:convert';

import 'package:bibliotecadigital_mobile/core/models/categoria.dart';
import 'package:http/http.dart' as http;

import 'auth_service.dart';

class CategoriaService {
  final AuthService _authService = AuthService();
  final String _baseUrl = "http://10.0.2.2:8080/poow2/categorias";

  Future<Map<String, String>> _getHeaders() async {
    final token = await _authService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }


  Future<List<Categoria>> getCategorias() async {
    final headers =  await _getHeaders();
    final response = await http.get(
        Uri.parse('$_baseUrl/listar'), headers: headers);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Categoria.fromMap(json)).toList();
    } else {
      throw Exception('Falha ao carregar livros');
    }
  }
}