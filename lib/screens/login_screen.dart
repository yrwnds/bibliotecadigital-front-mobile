import 'package:bibliotecadigital_mobile/screens/emprestimo_screen.dart';
import 'package:bibliotecadigital_mobile/screens/home-screen.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import '../service/auth_service.dart';
import '../core/models/user.dart';
import 'cadastro_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _matriculaController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  //
  // Widget VelhoLogin(BuildContext context){
  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     appBar: AppBar(backgroundColor: Colors.white70),
  //     body: SingleChildScrollView(
  //       child: Column(
  //         children: <Widget>[
  //           Container(
  //             padding: const EdgeInsets.only(top: 60.0, bottom: 10),
  //             child: Padding(
  //                 padding: EdgeInsets.only(left: 15, top: 100),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   children: [
  //                     SizedBox(
  //                       height: 70,
  //                       child: Row(
  //                         children: <Widget>[
  //                           Text(
  //                             "UFSMLib",
  //                             style: TextStyle(
  //                               fontSize: 60,
  //                               fontWeight: FontWeight.bold,
  //                             ),
  //                           ),
  //                           Icon(Icons.menu_book, size: 60),
  //                         ],
  //                       ),
  //                     )
  //                   ],
  //                 )
  //
  //             ),
  //           ),
  //           Center(
  //             child: SizedBox(
  //               height: 100,
  //               child: Row(
  //                 children: <Widget>[
  //                   TextButton(
  //                     onPressed: () {
  //                       Navigator.push(
  //                         context,
  //                         MaterialPageRoute(builder: (_) => CadastroScreen()),
  //                       );
  //                     },
  //                     child: const Text(
  //                       "Crie uma conta",
  //                       style: TextStyle(color: Colors.purple, fontSize: 15),
  //                     ),
  //                   ),
  //                   Text(
  //                     "e acesse nosso catálogo!",
  //                     style: TextStyle(fontSize: 15),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //           Form(
  //               key: _formKey,
  //               child: Column(
  //                 children: [Padding(
  //                   padding: EdgeInsets.symmetric(horizontal: 15),
  //                   child: TextFormField(
  //                     controller: _emailController,
  //                     decoration: const InputDecoration(
  //                       border: OutlineInputBorder(),
  //                       labelText: "Email",
  //                       hintText: "Exemplo: 123@gmail.com",
  //                     ),
  //                   ),
  //                 ),
  //                   Padding(
  //                     padding: const EdgeInsets.only(
  //                       left: 15.0,
  //                       right: 15.0,
  //                       top: 15,
  //                       bottom: 10,
  //                     ),
  //                     child: TextFormField(
  //                       controller: _passwordController,
  //                       obscureText: true,
  //                       decoration: const InputDecoration(
  //                         border: OutlineInputBorder(),
  //                         labelText: "Senha",
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(
  //                       height: 20
  //                   ),
  //                   Padding(
  //                       padding: EdgeInsets.only(right: 15),
  //                       child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.end,
  //                           children: [Container(
  //                             height: 40,
  //                             width: 150,
  //                             decoration: BoxDecoration(
  //                               color: Colors.white,
  //                               border: Border.all(width: 1),
  //                             ),
  //                             child: TextButton(
  //                               onPressed: (){},
  //                               child: Row(
  //                                 mainAxisAlignment: MainAxisAlignment.center,
  //                                 children: <Widget>[
  //                                   Icon(Icons.login, size: 20, color: Colors.black),
  //                                   const Text(
  //                                     "Login",
  //                                     style: TextStyle(color: Colors.black, fontSize: 18),
  //                                   )
  //                                 ],
  //                               ),
  //                             ),
  //                           ),]
  //                       )
  //                   )],
  //               )
  //           )
  //
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget NovoLogin(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(height: constraints.maxHeight * 0.1),
                  Icon(Icons.library_books, size: 50),
                  Text("UFSMLib", style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(height: constraints.maxHeight * 0.1),
                  Text(
                    "Entre na sua conta",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _matriculaController,
                          decoration: const InputDecoration(
                            hintText: 'Matrícula',
                            filled: true,
                            fillColor: Color(0xFFF5FCF9),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0 * 1.5, vertical: 16.0),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                              BorderRadius.all(Radius.circular(50)),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: 'Senha',
                              filled: true,
                              fillColor: Color(0xFFF5FCF9),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0 * 1.5, vertical: 16.0),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                BorderRadius.all(Radius.circular(50)),
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _login(context),
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xFF4E2B80),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                            shape: const StadiumBorder(),
                          ),
                          child: const Text("Login"),
                        ),
                        const SizedBox(height: 16.0),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Esqueceu sua senha?',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .color!
                                  .withOpacity(0.64),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => CadastroScreen()),
                            );
                          },
                          child: Text.rich(
                            const TextSpan(
                              text: "Não possui uma conta?",
                              children: [
                                TextSpan(
                                  text: " Cadastre-se",
                                  style: TextStyle(color: Color(0xFF4E2B80)),
                                ),
                              ],
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .color!
                                  .withOpacity(0.64),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final user = await _authService.login(
        _matriculaController.text,
        _passwordController.text,
      );
      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      } else{
        showErrorAlert(context, "Matrícula ou senha incorretos.");
      }
    } else{
      showErrorAlert(context, "Matrícula ou senha incorretos.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return NovoLogin(context);
  }
}
