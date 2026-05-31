import 'package:bibliotecadigital_mobile/core/dao/userDAO.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/user.dart';

class AuthService{
  final userDao _userDAO = userDao();
  static const String _userKey = 'logged_in_user';

  User? usuLogado;

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

    User? usuario = await _userDAO.getUser(email, senha);

    if(usuario!=null){
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, usuario.id.toString());
    }

    return usuario;
  }


  Future<void> logoutUsu() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

}