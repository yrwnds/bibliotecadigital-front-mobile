class User{
  final int id;
  final String nome;
  final String matricula;
  final String email;
  final String senha;

  User({
    required this.id,
    required this.nome,
    required this.matricula,
    required this.email,
    required this.senha
    });

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'nome': nome,
      'matricula': matricula,
      'email': email,
      'senha': senha
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      nome: map['nome'],
      matricula: map['matricula'],
      email: map['email'],
      senha: map['senha']
    );
  }

}