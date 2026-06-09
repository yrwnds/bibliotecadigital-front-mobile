import 'package:bibliotecadigital_mobile/screens/emprestimo_screen.dart';
import 'package:bibliotecadigital_mobile/screens/livro_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen>{

  int _selectedIndex = 0;
  bool loading = true;

  late final List<Widget> _telas;

  @override
  void initState(){
    super.initState();
    getTelas();
  }

  Future<void> getTelas() async{
    loading = true;
    try{
      _telas = [LivroScreen(),
        EmprestimoScreen()];
    } finally{
        loading = false;
    }
  }

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
      body: loading? Center(child: CircularProgressIndicator(color: Colors.blue)) : _telas[_selectedIndex]);
  }
}