class User{
  final int? id;
  final String nome;
  final String matricula;
  final String email;
  final String senha;
  final String? imagem_Path;
  final String identificador;

  User({
    this.id,
    required this.nome,
    required this.matricula,
    required this.email,
    required this.senha,
    required this.imagem_Path,
    required this.identificador
    });

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'nome': nome,
      'matricula': matricula,
      'email': email,
      'senha': senha,
      'imagem_Path': imagem_Path,
      'identificador': identificador
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['user_id'] ?? map['id'],
      nome: map['nome'],
      matricula: map['matricula'],
      email: map['email'],
      senha: map['senha'],
      imagem_Path: map['imagem_Path'],
      identificador: map['identificador']
    );
  }

}