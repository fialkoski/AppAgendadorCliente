import 'package:agendadorcliente/models/cliente.dart';

class Agendamento {
  int idEmpresa;
  int idProfissional;
  String nomeProfissional;
  int idServico;
  DateTime data;
  String hora;
  Cliente cliente;

  Agendamento({
    required this.idEmpresa,
    required this.idProfissional,
    required this.nomeProfissional,
    required this.idServico,
    required this.data,
    required this.hora,
    required this.cliente,
  });

  factory Agendamento.fromJson(Map<String, dynamic> json) {
    return Agendamento(
      idEmpresa: json['idEmpresa'],
      idProfissional: json['idProfissional'],
      nomeProfissional: '',
      idServico: json['idServico'],
      data: json['data'],
      hora: json['hora'],
      cliente: Cliente.fromJson(json['cliente']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idEmpresa': idEmpresa,
      'idProfissional': idProfissional,
      'idServico': idServico,
      'data': data,
      'hora': hora,
      'cliente': cliente.toJson(),
    };
  }
}
