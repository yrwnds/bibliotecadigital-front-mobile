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

  var cardImage = NetworkImage(
      'https://png.pngtree.com/png-vector/20210604/ourmid/pngtree-gray-network-placeholder-png-image_3416659.jpg');


  Future<void> getLivros() async {
    loading = true;
    try {
      livros = await LivroDao().getLivros();
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
                            color: Colors.blue,
                            child: Ink.image(
                              image: cardImage,
                              fit: BoxFit.cover
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
                              // logica para emprestimo aqui
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
            child: ListView.builder(
                itemCount: categorias.length,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 4.0),
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