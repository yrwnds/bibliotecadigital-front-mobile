import 'package:bibliotecadigital_mobile/core/dao/emprestimoDAO.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/models/emprestimo.dart';

class EmprestimoScreen extends StatefulWidget {
  final String userId;
  const EmprestimoScreen({super.key, required this.userId});

  @override
  State<EmprestimoScreen> createState() => _EmprestimoScreenState();
}

// metodo atualizar emprestimo e devolver

class _EmprestimoScreenState extends State<EmprestimoScreen> {
  List<Emprestimo> emprestimos = [];
  bool loading = true;

  Future<void> getEmprestimo() async {
    loading = true;
    try {
      emprestimos = await EmprestimoDao().getEmprestimos();
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
                          color: Colors.purple,
                          child: Icon(Icons.book),
                        ),
                        ListTile(
                          title: Text(emprestimos[index].livro.titulo),
                          subtitle: Text(emprestimos[index].livro.autor),
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
                          onPressed: () async{
                            EmprestimoDao().atualizarEmprestimo(emprestimos[index]);
                            setState(() {});
                            },
                          child: Text("Renovar empréstimo"),
                        ),
                        TextButton(
                          onPressed: () async{
                            EmprestimoDao().devolverLivro(emprestimos[index]);
                            setState(() {});
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
