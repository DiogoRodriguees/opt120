class Titles {
  final String titulo;

  const Titles({
    required this.titulo,
  });

  factory Titles.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'titulo': String titulo,
      } =>
        Titles(
          titulo: titulo,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}
