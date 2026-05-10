import 'package:bibliotecadigital_mobile/core/models/livro.dart';
import 'package:flutter/material.dart';

import '../core/dao/livroDAO.dart';

class  LivroScreen extends StatefulWidget {
  const LivroScreen({super.key});

  @override
  State<LivroScreen> createState() => _LivroScreenState();
}

class _LivroScreenState extends State<LivroScreen>{
  List<Livro> livros = [];

  bool loading = true;

  Future<void> getLivros() async {
    loading = true;
    try {
      livros = await LivroDao().getLivros();
    } finally {
      loading = false;
    }
    setState(() {});
  }

  // criar metodo de emprestimo

  @override
  void initState() {
    super.initState();
    getLivros();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.white,
      ),
      body: loading ? Center(child: CircularProgressIndicator(color: Colors.blue))
          : ListView.builder(
        itemCount: livros.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${livros[index].titulo} ${livros[index].anopublicado ?? ''}'),
                        Text('${livros[index].autor} ${livros[index].categoria ?? ''}'),
                        Text('${livros[index].n_exemplares} ${livros[index].n_disponiveis ?? ''}'),
                        // button para realizar emprestimo aqui
                        // navbar para ver livros que ja foram emprestados
                      ],
                    ),
                  ],
                ),
              )
            )
          );
        }
      )
    );
  }
}