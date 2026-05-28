import 'package:bibliotecadigital_mobile/core/auth_service.dart';
import 'package:bibliotecadigital_mobile/core/models/categoria.dart';
import 'package:bibliotecadigital_mobile/core/models/livro.dart';
import 'package:bibliotecadigital_mobile/core/models/user.dart';

import 'package:flutter/material.dart';

import '../core/dao/categoriaDAO.dart';
import '../core/dao/livroDAO.dart';
import '../core/dao/userDAO.dart';

class LivroScreen extends StatefulWidget {
  const LivroScreen({super.key});

  @override
  State<LivroScreen> createState() => _LivroScreenState();
}

class _LivroScreenState extends State<LivroScreen> {
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

  Future<void> getLivrosCategoria(String catId) async {
    loading = true;
    try{
      livros = await LivroDao().getLivrosCategoria(catId);
    } finally {
      loading = false;
    }
    setState(() {});
  }

  Future<void> getCategorias() async {
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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Livros'),
          backgroundColor: Colors.white,
        ),
        body: loading ? Center(
            child: CircularProgressIndicator(color: Colors.blue))
            : ListView.builder(
          itemCount: livros.length,
          itemBuilder: (context, index) {
            return
              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4.0),
                  child: Card(
                    elevation: 4,
                    child: Column(
                      children: [
                        Container(
                            height: 200,
                            width: double.infinity,
                            color: Colors.blue,
                            child: Icon(
                              Icons.book
                            )
                        ),
                        ListTile(
                          title: Text(livros[index].titulo),
                          subtitle: Text(livros[index].autor)),
                        Container(
                          padding: EdgeInsets.all(16),
                          alignment: Alignment.bottomLeft,
                          child: Column(
                            children: [
                              Text("Pub. ${livros[index].anopublicado}"),
                              Text("${livros[index].n_disponiveis} de ${livros[index].n_exemplares}")
                            ],
                          )
                        ),
                        TextButton(
                            onPressed: () async {
                              // logica criar emprestimo
                            },
                            child: const Text('Pegar emprestado')

                        )
                      ]
                    )
                    ),
                  );
          }
        ),
        drawer: Drawer( // card com nome do usuario
            child: Column(
              children: [
                Padding(
                  padding:  const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4.0),
                  child: DrawerHeader(
                    child: UserAccountsDrawerHeader(accountName: Text('Username'), accountEmail: Text('Email'))
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 4.0),
                  child: TextButton(onPressed: () async {
                    getLivros();
                  }, child: Text("Todos")),
                ),
                ListView.builder(
                    itemCount: categorias.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 4.0),
                          child: TextButton(onPressed: () async {
                            getLivrosCategoria("${categorias[index].id}");
                          }, child: Text(categorias[index].nome))
                      );
                    }
                )
              ],
            )
        )
    );
  }
}