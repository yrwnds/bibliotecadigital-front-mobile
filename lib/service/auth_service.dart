import 'package:bibliotecadigital_mobile/core/dao/userDAO.dart';
import '../core/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  final userDao _userDAO = userDao();
  final String _baseUrl = "http://10.0.2.2:8080/poow2";
  final _storage = const FlutterSecureStorage();

  User? usuLogado;

  Future<bool> register(User usuario) async {
    print("Entrou em register");
    final client = getMyNewClient();
    final response = await client.post(
      Uri.parse('$_baseUrl/usuarios'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(usuario.toMap()),
    );
    print("recebeu status ${response.statusCode}");
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool?> login(String matricula, String senha) async {
    final client = getMyNewClient();
    final response = await client.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'matricula': matricula, 'senha': senha}),
    );
    print("Statusresponse ${response.statusCode}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("response body: ${response.body}");
      String token = jsonDecode(response.body)['token'];
      await _storage.write(key: 'jwt_token', value: token);
      return true;
    }
    return false;
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<User> getUsuLogado() async {
    final token = await getToken();
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);

    final usuMat = decodedToken['sub'] ?? '';

    final headers = await _getHeaders();

    final client = getMyNewClient();
    final response = await client.get(
      Uri.parse('$_baseUrl/usuarios/buscarmatricula/$usuMat'),
      headers: headers
    );
    if (response.statusCode == 200){
      final Map<String, dynamic> data = jsonDecode(response.body);
      print(data);
      return User.fromMap(data);
    }
    else {
      print('RESPONSE USU: ${response.body}');
      throw Exception('Falha ao buscar usuário logado');
    }
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
  }

  IOClient getMyNewClient() {
    final HttpClient httpClient = HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);

    return IOClient(httpClient);
  }
}
