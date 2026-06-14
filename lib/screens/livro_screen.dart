import 'dart:io';

import 'package:bibliotecadigital_mobile/service/auth_service.dart';
import 'package:bibliotecadigital_mobile/core/dao/userDAO.dart';
import 'package:bibliotecadigital_mobile/core/models/categoria.dart';
import 'package:bibliotecadigital_mobile/core/models/livro.dart';
import 'package:bibliotecadigital_mobile/core/models/user.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_search_bar/flutter_easy_search_bar.dart';

import '../core/dao/emprestimoDAO.dart';
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
  late Future<User> _usuLogado;

  @override
  void initState() {
    super.initState();
    livros = _livroService.getLivros();
    emprestimos = _emprestimoService.getEmprestimos();
    categorias = _categoriaService.getCategorias();
    _usuLogado = _authService.getUsuLogado();
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

  Future<void> getLivroSearch(String param) async {
    loading = true;
    try {
      livros = _livroService.getLivroSearch(param);
    } finally {
      loading = false;
    }
    setState(() {});
  }

  Widget ListaFiltro(BuildContext context, dynamic snapshot) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: snapshot.data!.length + 1,
      itemBuilder: (context, index) {
        final categoria = snapshot.data![index];
        if (index == snapshot.data!.length) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4.0,
            ),
            child: TextButton(
              onPressed: () async {
                _livroService.getLivros();
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
              _livroService.getLivrosCategoria("${categoria.id}");
            },
            child: Text(categoria.nome),
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
          FutureBuilder<User>(
            future: _usuLogado,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                Center(child: Text('Erro: ${snapshot.error}'));
              }
              final user = snapshot.data!;
              return UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: const Color(0xFF4E2B80)),
                accountEmail: Text(user.email),
                accountName: Text(user.nome),
                currentAccountPicture: user.imagem_path != null
                    ? CircleAvatar(
                        child: Image.file(
                          File(user.imagem_path!),
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      )
                    : CircleAvatar(child: Icon(Icons.person)),
              );
            },
          ),
          FutureBuilder<List<Categoria>>(
            future: categorias,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Erro: ${snapshot.error}'));
              }
              return Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Filtros',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const Divider(),
                    ListaFiltro(context, snapshot),
                  ],
                ),
              );
            },
          ),
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
      body: FutureBuilder<List<Livro>>(
        future: livros,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final livro = snapshot.data![index];
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
                        child: livro.imagemPath != null
                            ? Image.file(
                                File(livro.imagemPath!),
                                fit: BoxFit.cover,
                              )
                            : Icon(Icons.book),
                      ),
                      ListTile(
                        title: Text(livro.titulo),
                        subtitle: Text(livro.autor),
                      ),
                      Container(
                        padding: EdgeInsets.all(16),
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          children: [
                            Text(
                              "Pub. ${livro.anopublicado}",
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              "${livro.n_disponivel} de ${livro.n_exemplares} disponíveis",
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: livro.n_disponivel == 0
                            ? null
                            : () async {
                                try {
                                  final usulogado = await _usuLogado;
                                  bool jaPego = false;
                                  for (var emp in await emprestimos) {
                                    if (livro == emp.livro &&
                                        usulogado == emp.usuario &&
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
                                        livro,
                                        await _usuLogado,
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
                        child: livro.n_disponivel == 0
                            ? Text("Não há exemplares disponíveis")
                            : Text("Pegar emprestado"),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      drawer: Drawer(child: novoDrawer(context)),
    );
  }
}
