import 'package:agendadorcliente/models/cliente.dart';

class AgendamentoRetorno {
  final int idEmpresa;
  final int idProfissional;
  final int idServico;
  final String data;
  final String hora;
  final Cliente cliente;

  AgendamentoRetorno({
    required this.idEmpresa,
    required this.idProfissional,
    required this.idServico,
    required this.data,
    required this.hora,
    required this.cliente,
  });

  // Método para converter JSON em um objeto Agendamento
  factory AgendamentoRetorno.fromJson(Map<String, dynamic> json) {
    return AgendamentoRetorno(
      idEmpresa: json['idEmpresa'],
      idProfissional: json['idProfissional'],
      idServico: json['idServico'],
      data: json['data'],
      hora: json['hora'],
      cliente: Cliente.fromJson(json['cliente']),
    );
  }

  // Método para converter objeto Agendamento em JSON
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
