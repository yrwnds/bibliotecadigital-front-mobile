import 'package:bibliotecadigital_mobile/core/dao/userDAO.dart';

import 'models/user.dart';

class AuthService{
  final userDao _userDAO = userDao();

  Future<bool> register(User usuario) async{
    try {
      await _userDAO.insertUser(usuario);
      return true;
    }
    catch(e){
      return false;
    }
  }

  Future<User?> login(String email, String senha) async{
    return await _userDAO.getUser(email, senha);
  }

}