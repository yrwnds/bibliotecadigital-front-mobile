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
        Uri.parse('$_baseUrl/listar'), headers: headers);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Livro.fromMap(json)).toList();
    } else {
      throw Exception('Falha ao carregar livros');
    }
  }

  Future<List<Livro>> getLivrosCategoria(String id) async{
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$_baseUrl/buscar/categoria/$id'), headers: headers
    );
    if(response.statusCode == 200){
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Livro.fromMap(json)).toList();
    } else{
      throw Exception('Falha ao carregar livros');
    }
  }

  Future<List<Livro>> getLivroSearch(String param) async{
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$_baseUrl/buscar/$param'), headers: headers
    );
    if(response.statusCode == 200){
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Livro.fromMap(json)).toList();
    } else{
      print('RESPONSE LIVROS: ${response.body}');
      throw Exception('Falha ao carregar livros');
    }
  }
}

