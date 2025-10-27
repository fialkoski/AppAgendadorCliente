import 'dart:convert';

class Servico {
  final int id;
  final int tempo;
  final String descricao;
  final double preco;

  Servico(
      {required this.id,
      required this.descricao,
      required this.tempo,
      required this.preco});

  factory Servico.fromJson(Map<String, dynamic> json) {
    return Servico(
      id: json['id'] ?? 0,
      descricao: json['descricao'] ?? '',
      tempo: json['tempo'] ?? 0,
      preco: json['preco'] ?? 0,
    );
  }
}
