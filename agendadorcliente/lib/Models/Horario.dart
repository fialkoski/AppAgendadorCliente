class Horario {
  final String horario;

  Horario({required this.horario});

  factory Horario.fromJson(Map<String, dynamic> json) {
    return Horario(
      horario: json['Horario'] ?? '',
    );
  }
}