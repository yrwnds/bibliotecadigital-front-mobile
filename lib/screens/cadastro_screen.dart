import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/auth_service.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
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
                   "Cadastre sua conta e acesse sua biblioteca de graça!"
                 )
               ]
             )
           ),
            Padding(
              padding: const EdgeInsets.only(
                left: 15.0,
                right: 15.0,
                top: 15,
                bottom: 10,
              ),
              child: TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Nome",
                  hintText: "Fulano de tal"
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
                  hintText: "12345678"
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
                  hintText: "123@gmail.com",
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
                        onPressed: () {
                          bool valido =
                              _formKey.currentState!.validate();
                          if(valido){
                            final user = AuthService().register();
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
            )
          ],
        ),
      ),
    );
  }
}