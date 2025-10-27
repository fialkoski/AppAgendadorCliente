import 'dart:convert';

class Historico {
  final String nomeProfissional;
  final String descricaoServico;
  final String data;
  final String hora;
  final int idProfissional;

  Historico(
      {required this.nomeProfissional,
      required this.descricaoServico,
      required this.data,
      required this.hora,
      required this.idProfissional});

  factory Historico.fromJson(Map<String, dynamic> json) {
    return Historico(
        nomeProfissional: json['nomeProfissional'] ?? '',
        descricaoServico: utf8.decode(json['descricaoServico'].toString().codeUnits),
        data: json['data'] ?? '',
        hora: json['hora'] ?? '',
        idProfissional: json['idProfissional'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {
      'nomeProfissional': nomeProfissional,
      'descricaoServico': descricaoServico,
      'data': data,
      'hora': hora,
      'idProfissional': idProfissional,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  bool dataMaiorQueDataAtual() {
    final historicoDateTime = DateTime.parse('$data $hora');
    return historicoDateTime.isAfter(DateTime.now());
  }
}
