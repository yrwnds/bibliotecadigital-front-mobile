import 'package:bibliotecadigital_mobile/core/dao/userDAO.dart';
import '../core/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class AuthService{
  final userDao _userDAO = userDao();
  final String _baseUrl = "https://192.168.100.35:8080/poow2";
  final _storage = const FlutterSecureStorage();

  User? usuLogado;

  Future<bool> register(User usuario) async{
    print("Entrou em register");
    final response = await http.post(
      Uri.parse('$_baseUrl/usuarios'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(usuario.toMap())
    );
    print("recebeu status ${response.statusCode}");
    return response.statusCode == 200;
  }

  Future<bool?> login(String email, String senha) async{
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'senha': senha})
    );
    if(response.statusCode == 200){
      String token = jsonDecode(response.body)['accessToken'];
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

  Future<bool> registerDao(User user) async {
    try {
      await _userDAO.insertUser(user);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<User?> loginDao(String email, String password) async {
    return await _userDAO.getUser(email, password);
  }

}