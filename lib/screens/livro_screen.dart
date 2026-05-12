import 'package:bibliotecadigital_mobile/core/auth_service.dart';
import 'package:bibliotecadigital_mobile/core/models/categoria.dart';
import 'package:bibliotecadigital_mobile/core/models/livro.dart';
import 'package:bibliotecadigital_mobile/core/models/user.dart';

import 'package:flutter/material.dart';

import '../core/dao/categoriaDAO.dart';
import '../core/dao/livroDAO.dart';
import '../core/dao/userDAO.dart';

class  LivroScreen extends StatefulWidget {
  const LivroScreen({super.key});

  @override
  State<LivroScreen> createState() => _LivroScreenState();
}

class _LivroScreenState extends State<LivroScreen>{
  List<Livro> livros = [];
  List<Categoria> categorias = [];

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

  Future<void> getCategorias() async{
    loading = true;
    try {
      categorias = await CategoriaDao().getCategorias();
    } finally {
      loading = false;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getLivros();
    getCategorias();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Livros'),
        backgroundColor: Colors.white,
      ),
      body: loading ? Center(child: CircularProgressIndicator(color: Colors.blue))
          : ListView.builder(
        itemCount: livros.length,
        itemBuilder: (context, index) {
          return
            Padding(
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
                        Text('${livros[index].autor} ${livros[index].categoria?.nome ?? ''}'),
                        Text('${livros[index].n_exemplares} ${livros[index].n_disponiveis ?? ''}'),
                        TextButton(onPressed: () async {
                          // logica para emprestimo aqui
                        },
                            child: const Text('Pegar emprestado')
                        )
               // navbar para ver livros que ja foram emprestados
                      ],
                    ),
                  ],
                ),
              )
            )
          );
        }
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.book), label: "Livros"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Empréstimos"),
          ]),
      drawer: Drawer(
        child: ListView.builder(
          itemCount: categorias.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: TextButton(onPressed: () async {
                // logica para filtrar por categoria aqui
                 }, child: Text(categorias[index].nome))
            );
          }
        )
      )
    );
  }
}