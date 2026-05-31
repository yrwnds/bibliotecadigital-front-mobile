import 'package:bibliotecadigital_mobile/screens/login_screen.dart';
import 'package:flutter/material.dart';

import '../core/auth_service.dart';
import '../core/models/user.dart';

class CadastroScreen extends StatefulWidget{
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final nomeController = TextEditingController();

  final matriculaController = TextEditingController();


  void showErrorAlert(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erro ocorreu.'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget NovoCadastro(BuildContext context) {
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
                  Text(
                    "UFSMLib", style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(height: constraints.maxHeight * 0.1),
                  Text(
                    "Cadastre-se",
                    style: Theme
                        .of(context)
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
                          controller: nomeController,
                          decoration: const InputDecoration(
                            hintText: 'Nome',
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
                            controller: matriculaController,
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
                        ),
                        TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            hintText: 'E-mail',
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
                            controller: passwordController,
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
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              final newuser = User(matricula: matriculaController.text, senha: passwordController.text, nome: nomeController.text, email: emailController.text);
                              final user = await AuthService().register(newuser);
                              if(user){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => LoginScreen()),
                                );
                              } else{
                                showErrorAlert(context, "Não foi possível criar o usuário. Tente novamente.");
                              }
                            } else{
                              showErrorAlert(context, "Cheque a validade dos dados e tente novamente.");
                            }
                          },
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => LoginScreen()),
                            );
                          },
                          child: Text.rich(
                            const TextSpan(
                              text: "Já possui uma conta?",
                              children: [
                                TextSpan(
                                  text: "Faça login agora!",
                                  style: TextStyle(color: Color(0xFF4E2B80)),
                                ),
                              ],
                            ),
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                              color: Theme
                                  .of(context)
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

  Widget velhoCadastro(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white70),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 60.0, bottom: 10),
              child: Padding(
                  padding: EdgeInsets.only(left: 15, top: 100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 70,
                        child: Row(
                          children: <Widget>[
                            Text(
                              "UFSMLib",
                              style: TextStyle(
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(Icons.menu_book, size: 60),
                          ],
                        ),
                      )
                    ],
                  )

              ),
            ),
            Container(
                padding: const EdgeInsets.only(left: 15, top: 50, bottom: 50),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                          "Cadastre sua conta e acesse nosso catálogo!"
                      )
                    ]
                )
            ),
            Form(
                key: _formKey,
                child: Column(
                    children: [Padding(
                      padding: const EdgeInsets.only(
                        left: 15.0,
                        right: 15.0,
                        top: 15,
                        bottom: 0,
                      ),
                      child: TextFormField(
                        controller: nomeController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Nome",
                            hintText: "Exemplo: Ana Silva"
                        ),
                      ),
                    ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 15.0,
                          right: 15.0,
                          top: 15,
                          bottom: 10,
                        ),
                        child: TextFormField(
                          controller: matriculaController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Matrícula",
                              hintText: "Exemplo: 12345678"
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Email",
                            hintText: "Exemplo: 123@gmail.com",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 15.0,
                          right: 15.0,
                          top: 15,
                          bottom: 10,
                        ),
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Senha",
                          ),
                        ),
                      ),
                      SizedBox(
                          height: 20
                      ),
                      Padding(
                          padding: EdgeInsets.only(right: 15),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [Container(
                                height: 40,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(width: 1),
                                ),
                                child: TextButton(
                                  onPressed: () async {
                                    bool valido =
                                    _formKey.currentState!.validate();
                                    if(valido){
                                      final newuser = User(matricula: matriculaController.text, senha: passwordController.text, nome: nomeController.text, email: emailController.text);
                                      final user = await AuthService().register(newuser);
                                      if(user){
                                        print("Salvou");
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) => LoginScreen()),
                                        );
                                      } else{
                                        print("Erro");
                                      }
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.login, size: 20, color: Colors.black),
                                      const Text(
                                        "Criar conta",
                                        style: TextStyle(color: Colors.black, fontSize: 20),
                                      )
                                    ],
                                  ),
                                ),
                              ),]
                          )
                      )]
                )
            )

          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NovoCadastro(context);
  }
}