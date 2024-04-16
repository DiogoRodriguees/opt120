class Usuario {
  final int id;
  final String nome;
  final String email;
  final String senha;

  Usuario({
    required this.id,
    this.nome = "",
    this.email = "",
    this.senha = "",
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      senha: json['senha'],
    );
  }
}
