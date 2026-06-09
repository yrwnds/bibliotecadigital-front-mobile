class User{
  final int? id;
  final String nome;
  final String matricula;
  final String email;
  final String senha;
  final String? imagemPath;

  User({
    this.id,
    required this.nome,
    required this.matricula,
    required this.email,
    required this.senha,
    required this.imagemPath
    });

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'nome': nome,
      'matricula': matricula,
      'email': email,
      'senha': senha,
      'imagemPath': imagemPath
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['user_id'] ?? map['id'],
      nome: map['nome'],
      matricula: map['matricula'],
      email: map['email'],
      senha: map['senha'],
      imagemPath: map['imagemPath']
    );
  }

}