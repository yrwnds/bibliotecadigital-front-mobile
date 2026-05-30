import 'package:bibliotecadigital_mobile/screens/emprestimo_screen.dart';
import 'package:bibliotecadigital_mobile/screens/livro_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {

  @override
  State<HomeScreen> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen>{

  int _selectedIndex = 0;

  final List<Widget> _telas = [
    LivroScreen(),
    EmprestimoScreen()
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (int index) {
            _selectedIndex = index;
            setState(() {});
        },
        items: const<BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Livros"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Empréstimos"),
        ],
      ),
      body: _telas[_selectedIndex]);
  }
}