class Atividade {
  final int id;
  final String titulo;
  final String descricao;

  Atividade({
    required this.id,
    required this.titulo,
    required this.descricao,
  });

  factory Atividade.fromJson(Map<String, dynamic> json) {
    return Atividade(
      id: json['id'],
      titulo: json['titulo'],
      descricao: json['descricao'],
    );
  }
}
