import 'dart:io';

import 'package:bibliotecadigital_mobile/service/auth_service.dart';
import 'package:bibliotecadigital_mobile/core/dao/userDAO.dart';
import 'package:bibliotecadigital_mobile/core/models/categoria.dart';
import 'package:bibliotecadigital_mobile/core/models/livro.dart';
import 'package:bibliotecadigital_mobile/core/models/user.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_search_bar/flutter_easy_search_bar.dart';

import '../core/dao/categoriaDAO.dart';
import '../core/dao/emprestimoDAO.dart';
import '../core/dao/livroDAO.dart';
import '../core/models/emprestimo.dart';
import '../service/categoria_service.dart';
import '../service/emprestimo_service.dart';
import '../service/livro_service.dart';

class LivroScreen extends StatefulWidget {
  const LivroScreen({super.key});

  @override
  State<LivroScreen> createState() => _LivroScreenState();
}

class _LivroScreenState extends State<LivroScreen> {
  final LivroService _livroService = LivroService();
  final CategoriaService _categoriaService = CategoriaService();
  final EmprestimoService _emprestimoService = EmprestimoService();
  final AuthService _authService = AuthService();

  late Future<List<Livro>> livros;
  late Future<List<Categoria>> categorias;
  late Future<List<Emprestimo>> emprestimos;

  late Future<String?> token = _authService.getToken();

  late User _usuLogado;


  @override
  void initState() {
    super.initState();
    livros = _livroService.getLivros();
    emprestimos = _emprestimoService.getEmprestimos();
    categorias = _categoriaService.getCategorias();
    _usuLogado =
  }

  void _refresh() {
    setState(() {
      livros = _livroService.getLivros();
      emprestimos = _emprestimoService.getEmprestimos();
      categorias = _categoriaService.getCategorias();
    });
  }



  bool loading = true;

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
          content: const Text('O empréstimo foi realizado com sucesso.'),
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

  Future<void> getEmprestimos() async {
    loading = true;
    try {
      emprestimos = await EmprestimoDao().getEmprestimos();
    } finally {
      loading = false;
    }
    setState(() {});
  }

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
    try {
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

  Future<void> getLivroSearch(String param) async {
    loading = true;
    try {
      livros = await LivroDao().getLivrosSearch(param);
    } finally {
      loading = false;
    }
    setState(() {});
  }

  Future<void> getUsuLogado() async {
    loading = true;
    try {
      _usuLogado = await userDao().getUserId(int.parse("1"));
      setState(() {});
    } finally {
      loading = false;
    }
  }

  @override
  void initState() {
    super.initState();
    getLivros();
    getCategorias();
    getUsuLogado();
    getEmprestimos();
  }

  Widget ListaFiltro(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categorias.length + 1,
      itemBuilder: (context, index) {
        if (index == categorias.length) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4.0,
            ),
            child: TextButton(
              onPressed: () async {
                getLivros();
              },
              child: Text(
                "Todos",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: TextButton(
            onPressed: () async {
              getLivrosCategoria("${categorias[index].id}");
            },
            child: Text(categorias[index].nome),
          ),
        );
      },
    );
  }

  Widget novoDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: const Color(0xFF4E2B80)),
            accountEmail: Text(_usuLogado!.email),
            accountName: Text(_usuLogado!.nome),
            currentAccountPicture: _usuLogado?.imagem_path != null
                ? CircleAvatar(
                    child: Image.file(
                      File(_usuLogado!.imagem_path!),
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  )
                : CircleAvatar(child: Icon(Icons.person)),
          ),
          Divider(height: 1, thickness: 1),
          Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Filtros', style: Theme.of(context).textTheme.bodyLarge),
                const Divider(),
              ],
            ),
          ),
          ListaFiltro(context),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EasySearchBar(
        title: Text('Home'),
        onSearch: (value) => getLivroSearch(value),
        backgroundColor: Colors.white,
      ),
      body: loading
          ? Center(child: CircularProgressIndicator(color: Colors.blue))
          : ListView.builder(
              itemCount: livros.length,
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
                          child: livros[index].imagemPath != null
                              ? Image.file(
                                  File(livros[index].imagemPath!),
                                  fit: BoxFit.cover,
                                )
                              : Icon(Icons.book),
                        ),
                        ListTile(
                          title: Text(livros[index].titulo),
                          subtitle: Text(livros[index].autor),
                        ),
                        Container(
                          padding: EdgeInsets.all(16),
                          alignment: Alignment.bottomLeft,
                          child: Column(
                            children: [
                              Text(
                                "Pub. ${livros[index].anopublicado}",
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                "${livros[index].n_disponivel} de ${livros[index].n_exemplares} disponíveis",
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: livros[index].n_disponivel == 0
                              ? null
                              : () async {
                                  try {
                                    bool jaPego = false;
                                    for (var emp in emprestimos) {
                                      if (livros[index] == emp.livro &&
                                          _usuLogado == emp.usuario &&
                                          emp.status == 'ATIVO') {
                                        jaPego = true;
                                      }
                                    }
                                    if (jaPego) {
                                      showErrorAlert(
                                        context,
                                        "Você já pegou este livro emprestado.",
                                      );
                                    } else {
                                      try {
                                        EmprestimoDao().insertEmprestimo(
                                          livros[index],
                                          _usuLogado!,
                                        );
                                      } catch (e) {
                                        showErrorAlert(
                                          context,
                                          "Erro no empréstimo.",
                                        );
                                      } finally {
                                        setState(() {});
                                      }
                                    }
                                  } finally {
                                    showSuccessDialog(context);
                                    setState(() {});
                                  }
                                },
                          child: livros[index].n_disponivel == 0
                              ? Text("Não há exemplares disponíveis")
                              : Text("Pegar emprestado"),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      drawer: Drawer(child: novoDrawer(context)),
    );
  }
}
