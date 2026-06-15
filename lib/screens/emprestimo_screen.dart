import 'package:bibliotecadigital_mobile/core/dao/emprestimoDAO.dart';
import 'package:bibliotecadigital_mobile/service/auth_service.dart';
import 'package:bibliotecadigital_mobile/service/emprestimo_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/models/emprestimo.dart';
import 'login_screen.dart';

class EmprestimoScreen extends StatefulWidget {
  const EmprestimoScreen({super.key});

  @override
  State<EmprestimoScreen> createState() => _EmprestimoScreenState();
}

void showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 10),
            Text('Sucesso!'),
          ],
        ),
        content: const Text('Sucesso!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK', style: TextStyle(color: Colors.green)),
          ),
        ],
      );
    },
  );
}

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

class _EmprestimoScreenState extends State<EmprestimoScreen> {
  late Future<List<Emprestimo>> emprestimos;
  final EmprestimoService _emprestimoService = EmprestimoService();
  final AuthService _authService = AuthService();

  Future<void> checkToken() async {
    String? token = await _authService.getToken();
    if (token == null || token.isEmpty) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
    }
  }

  @override
  void initState() {
    super.initState();
    emprestimos = _emprestimoService.getEmprestimos();
    checkToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Empréstimos")),
      body: FutureBuilder<List<Emprestimo>>(
        future: emprestimos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          if (snapshot.data!.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 80,
                      color: Theme.of(context).disabledColor,
                    ),
                    const SizedBox(height: 24),

                    Text(
                      "Não há empréstimos para mostrar.",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final emp = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 4.0,
                  ),
                  child: Card(
                    elevation: 4,
                    child: Column(
                      children: [
                        Container(
                          height: 200,
                          width: double.infinity,
                          color: const Color(0xFF4E2B80),
                          child: Icon(Icons.book),
                        ),
                        ListTile(
                          title: Text(
                            emp.livro.titulo,
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(emp.livro.autor),
                        ),
                        Container(
                          padding: EdgeInsets.all(16),
                          alignment: Alignment.bottomLeft,
                          child: Column(
                            children: [
                              Text(
                                "Você pegou este livro em ${emp.datapego}",
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                "Prazo de devolução em ${emp.dataprazo}",
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            try {
                              _emprestimoService.atualizarEmprestimo(emp);
                            } catch (e) {
                              showErrorAlert(context, "Ocorreu um erro.");
                            } finally {
                              setState(() {
                                showSuccessDialog(context);
                              });
                            }
                          },
                          child: Text("Renovar empréstimo"),
                        ),
                        TextButton(
                          onPressed: () async {
                            try {
                              _emprestimoService.devolver(emp);
                              showSuccessDialog(context);
                            } catch (e) {
                              showErrorAlert(context, "Ocorreu um erro.");
                            }
                            setState(() {
                              emprestimos = _emprestimoService.getEmprestimos();
                            });

                          },
                          child: Text("Devolver"),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
