class Profissional {
  final int id;
  final String nome;
  final String foto;
  final List<String> horarios;

  Profissional({
    required this.id,
    required this.nome,
    required this.foto,
    required this.horarios,
  });

  factory Profissional.fromJson(Map<String, dynamic> json) {
    return Profissional(
      id: json['id'] is int ? json['id'] as int : 0,
      nome: json['nome'] as String? ?? '',
      foto: json['foto'] as String? ?? '',
      horarios: (json["horarios"] as List<dynamic>)
              .map((h) => h.toString())
              .toList(),
    );
  }
}
