import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'cadastro_screen.dart';
import 'livro_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            Center(
              child: SizedBox(
                height: 100,
                child: Row(
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => CadastroScreen()),
                        );
                      },
                      child: const Text(
                        "Crie uma conta",
                        style: TextStyle(color: Colors.purple, fontSize: 15),
                      ),
                    ),
                    Text(
                      "e acesse nosso catálogo!",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
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
                      print("screen apos login");
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.login, size: 20, color: Colors.black),
                        const Text(
                          "Login",
                          style: TextStyle(color: Colors.black, fontSize: 18),
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
