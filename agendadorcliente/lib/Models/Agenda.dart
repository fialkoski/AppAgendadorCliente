import 'package:agendadorcliente/Models/Profissional.dart';

class Agenda {
  final String data;
  final String dataPorExtenso;
  final List<Profissional>? profissionais;

  Agenda({
    required this.data,
    required this.dataPorExtenso,
    this.profissionais,
  });

  factory Agenda.fromJson(Map<String, dynamic> json) {
    return Agenda(
      data: json['data'] as String,
      dataPorExtenso: json['dataPorExtenso'] as String,
      profissionais: (json['profissionais'] as List<dynamic>?)
              ?.map((e) => Profissional.fromJson(e))
              .toList() ??
          [],
    );
  }
}
