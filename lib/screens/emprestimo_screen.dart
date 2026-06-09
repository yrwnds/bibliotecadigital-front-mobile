import 'package:bibliotecadigital_mobile/core/dao/emprestimoDAO.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/models/emprestimo.dart';

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
  List<Emprestimo> emprestimos = [];
  bool loading = true;

  Future<void> getEmprestimo() async {
    loading = true;
    try {
      emprestimos = await EmprestimoDao().getEmprestimosAtivosByUser(
        int.parse("1"),
      );
    } finally {
      loading = false;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getEmprestimo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Empréstimos")),
      body: loading
          ? Center(child: CircularProgressIndicator(color: Colors.blue))
          : ListView.builder(
              itemCount: emprestimos.length,
              itemBuilder: (context, index) {
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
                          title: Text(emprestimos[index].livro!.titulo),
                          subtitle: Text(emprestimos[index].livro!.autor),
                        ),
                        Container(
                          padding: EdgeInsets.all(16),
                          alignment: Alignment.bottomLeft,
                          child: Column(
                            children: [
                              Text(
                                "Você pegou este livro em ${emprestimos[index].datapego}",
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                "Prazo de devolução em ${emprestimos[index].dataprazo}",
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            try {
                              EmprestimoDao().atualizarEmprestimo(
                                emprestimos[index],
                              );
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
                              EmprestimoDao().devolverLivro(emprestimos[index]);
                            } catch (e) {
                              showErrorAlert(context, "Ocorreu um erro.");
                            } finally {
                              setState(() {
                                showSuccessDialog(context);
                              });
                            }
                          },
                          child: Text("Devolver"),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
