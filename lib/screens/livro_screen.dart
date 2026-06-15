import 'dart:io';

import 'package:bibliotecadigital_mobile/screens/login_screen.dart';
import 'package:bibliotecadigital_mobile/service/auth_service.dart';
import 'package:bibliotecadigital_mobile/core/models/categoria.dart';
import 'package:bibliotecadigital_mobile/core/models/livro.dart';
import 'package:bibliotecadigital_mobile/core/models/user.dart';
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
    checkToken();
  }

  void _refresh() {
    setState(() {
      livros = _livroService.getLivros();
      emprestimos = _emprestimoService.getEmprestimos();
      categorias = _categoriaService.getCategorias();
    });
  }

  Future<void> checkToken() async {
    String? token = await _authService.getToken();
    if (token == null || token.isEmpty) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
    }
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
    if (param == '') {
      livros = _livroService.getLivros();
    } else {
      livros = _livroService.getLivroSearch(param);
    }
    setState(() {});
  }

  Widget ListaFiltro(BuildContext context, dynamic snapshot) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: snapshot.data!.length + 1,
      itemBuilder: (context, index) {
        if (index == snapshot.data!.length) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4.0,
            ),
            child: TextButton(
              onPressed: () async {
               livros = _livroService.getLivros();
               setState(() {});
              },
              child: Text(
                "Todos",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        }
        if (index <= snapshot.data!.length) {
          final categoria = snapshot.data![index];
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4.0,
            ),
            child: TextButton(
              onPressed: () async {
               setState(() {
                 livros = _livroService.getLivrosCategoria("${categoria.nome}");
               });
              },
              child: Text(categoria.nome),
            ),
          );
        }
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
              if (snapshot.hasData) {
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
                      : CircleAvatar(
                          backgroundColor: const Color(0xFF885C97),
                          child: Icon(
                            Icons.person,
                            color: const Color(0xFF4E2B80),
                          ),
                        ),
                );
              }
              return const Center(child: CircularProgressIndicator());
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
                      "Nenhum resultado encontrado.",
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
                          title: Text(
                            livro.titulo,
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(livro.autor),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Pub. ${livro.anopublicado}",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    livro.categoria.nome,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        TextButton(
                          onPressed: livro.n_disponivel == 0
                              ? null
                              : () async {
                                  try {
                                    final usulogado = await _usuLogado;
                                    bool jaPego = false;
                                    for (var emp in await emprestimos) {
                                      if (livro.isbn == emp.livro.isbn &&
                                          usulogado.id == emp.usuario.id &&
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
                                        _emprestimoService.novoEmprestimo(
                                          livro,
                                          usulogado,
                                        );
                                      } catch (e) {
                                        showErrorAlert(
                                          context,
                                          "Erro no empréstimo.",
                                        );
                                      } finally {
                                        showSuccessDialog(context);
                                        setState(() {});
                                      }
                                    }
                                  } catch (e) {
                                    showErrorAlert(
                                      context,
                                      "Erro no empréstimo.",
                                    );
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
          }
        },
      ),
      drawer: Drawer(child: novoDrawer(context)),
    );
  }
}
