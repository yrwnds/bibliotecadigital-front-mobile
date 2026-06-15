import 'dart:async';
import 'dart:io';

import 'package:bibliotecadigital_mobile/screens/emprestimo_screen.dart';
import 'package:bibliotecadigital_mobile/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../service/auth_service.dart';
import '../core/models/user.dart';
import '../service/image_picker_widget.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _nomeController = TextEditingController();

  final _matriculaController = TextEditingController();

  File? _imageFile;

  final AuthService _authService = AuthService();

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
                    "UFSMLib",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.1),
                  Text(
                    "Cadastre-se",
                    style: Theme
                        .of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        ImagePickerWidget(
                          onImageSelected: (File? image) {
                            _imageFile = image;
                          },
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value
                                .trim()
                                .isEmpty) {
                              return 'Nome é obrigatório.';
                            }
                            return null;
                          },
                          controller: _nomeController,
                          decoration: const InputDecoration(
                            hintText: 'Nome',
                            filled: true,
                            fillColor: Color(0xFFF5FCF9),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0 * 1.5,
                              vertical: 16.0,
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value
                                  .trim()
                                  .isEmpty) {
                                return 'Matrícula é obrigatória.';
                              } else if (value.length < 8) {
                                return 'Matrícula deve possuir 8 caracteres.';
                              } else if (num.tryParse(value) == null) {
                                return 'Matrícula deve conter apenas números.';
                              }
                              return null;
                            },
                            controller: _matriculaController,
                            decoration: const InputDecoration(
                              hintText: 'Matrícula',
                              filled: true,
                              fillColor: Color(0xFFF5FCF9),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0 * 1.5,
                                vertical: 16.0,
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value
                                .trim()
                                .isEmpty) {
                              return 'E-mail é obrigatório.';
                            } else if (!EmailValidator.validate(value)) {
                              return 'E-mail deve ser um e-mail válido.';
                            }
                            return null;
                          },
                          controller: _emailController,
                          decoration: const InputDecoration(
                            hintText: 'E-mail',
                            filled: true,
                            fillColor: Color(0xFFF5FCF9),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0 * 1.5,
                              vertical: 16.0,
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value
                                  .trim()
                                  .isEmpty) {
                                return 'Senha é obrigatória.';
                              } else if (value.length < 8){
                                return 'Senha deve possuir 8 caracteres.';
                              }
                              return null;
                            },
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: 'Senha',
                              filled: true,
                              fillColor: Color(0xFFF5FCF9),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0 * 1.5,
                                vertical: 16.0,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xFF4E2B80),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                            shape: const StadiumBorder(),
                          ),
                          child: const Text("Cadastrar"),
                        ),
                        const SizedBox(height: 16.0),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => LoginScreen()),
                            );
                          },
                          child: Text.rich(
                            const TextSpan(
                              text: "Já possui uma conta? ",
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

  void _register() async {
    print("entrou em _register");
    if (_formKey.currentState!.validate()) {
      print("formkey validou");
      final user = User(
          nome: _nomeController.text,
          matricula: _matriculaController.text,
          senha: _passwordController.text,
          email: _emailController.text,
          imagem_Path: _imageFile?.path,
          identificador: 'USER'
      );
      try {
        final success = await _authService
            .register(user);
        if (success) {
          showSuccessDialog(context);
          print("success");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => LoginScreen()),
          );
        } else {
          print("error alert");
          showErrorAlert(context, "Ocorreu um erro ao realizar o cadastro.");
        }
      } on TimeoutException catch (e) {
        showErrorAlert(context, "Falha ao conectar à API. (TimeoutException)");
        print(e);
      } on SocketException catch (e) {
        print(e);
        showErrorAlert(context, "Falha ao conectar à API. (SocketException)");
      }
    } else {
      print("error alert");
      showErrorAlert(context, "Cheque a validade dos dados e tente novamente.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return NovoCadastro(context);
  }
}
