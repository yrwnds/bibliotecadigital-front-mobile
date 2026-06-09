class User{
  final int? id;
  final String nome;
  final String matricula;
  final String email;
  final String senha;
  final String? imagem_path;
  final int qt_livros_emprestados;

  User({
    this.id,
    required this.nome,
    required this.matricula,
    required this.email,
    required this.senha,
    required this.imagem_path,
    required this.qt_livros_emprestados
    });

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'nome': nome,
      'matricula': matricula,
      'email': email,
      'senha': senha,
      'imagem_path': imagem_path,
      'qt_livros_emprestados': qt_livros_emprestados
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['user_id'] ?? map['id'],
      nome: map['nome'],
      matricula: map['matricula'],
      email: map['email'],
      senha: map['senha'],
      imagem_path: map['imagem_path'],
      qt_livros_emprestados: map['qt_livros_emprestados']
    );
  }

}