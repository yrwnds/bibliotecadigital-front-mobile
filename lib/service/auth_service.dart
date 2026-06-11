import 'package:bibliotecadigital_mobile/core/dao/userDAO.dart';
import '../core/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';

class AuthService{
  final userDao _userDAO = userDao();
  final String _baseUrl = "http://10.0.2.2:8080/poow2";
  final _storage = const FlutterSecureStorage();

  User? usuLogado;

  Future<bool> register(User usuario) async{
    print("Entrou em register");
    final client = getMyNewClient();
    final response = await client.post(
      Uri.parse('$_baseUrl/usuarios'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(usuario.toMap())
    );
    print("recebeu status ${response.statusCode}");
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool?> login(String matricula, String senha) async{
    final client = getMyNewClient();
    final response = await client.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'matricula': matricula, 'senha': senha})
    );
    print("Statusresponse ${response.statusCode}");
    if(response.statusCode == 200 || response.statusCode == 201){
      print("response body: ${response.body}");
      String token = jsonDecode(response.body)['token'];
      await _storage.write(key: 'jwt_token', value: token);
      return true;
    }
    return false;
  }

  Future<String?> getToken() async{
    return await _storage.read(key: 'jwt_token');
  }


  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
  }

  IOClient getMyNewClient() {
    final HttpClient httpClient = HttpClient()
      ..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);

    return IOClient(httpClient);
  }

}