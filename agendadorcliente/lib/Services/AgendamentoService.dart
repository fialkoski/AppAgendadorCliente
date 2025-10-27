import 'dart:async';
import 'dart:convert';
import 'package:agendadorcliente/Models/Agenda.dart';
import 'package:agendadorcliente/Models/AgendamentoRetorno.dart';
import 'package:agendadorcliente/Models/Cliente.dart';
import 'package:agendadorcliente/Models/ErroRequisicao.dart';
import 'package:agendadorcliente/Models/Servico.dart';
import 'package:agendadorcliente/Services/ApiService.dart';
import 'package:agendadorcliente/Singleton/EmpresaSingleton.dart';
import 'package:agendadorcliente/Tools/Util.dart';

class AgendamentoService {
  Future<List<Servico>> buscarListaServico() async {
    return ApiService.buscarLista<Servico>(
        '/api/${EmpresaSingleton.empresa!.id}/servicos', Servico.fromJson);
  }

  Future<List<Agenda>> buscarListaAgenda() async {
    return ApiService.buscarLista<Agenda>(
        '/api/${EmpresaSingleton.empresa!.id}/agendas', Agenda.fromJson);
  }

  Future<String> salvarAgendamento(int idProfissional, String data,
      String hora, Servico servico, Cliente cliente) async {
    String retorno = '';

    final Map<String, dynamic> dados = {
      "idEmpresa": EmpresaSingleton.empresa!.id,
      "idProfissional": idProfissional,
      "data": data,
      "hora": hora,
      "idServico": servico.id,
      "cliente": {
        "nome": cliente.nome,
        "cpf": cliente.cpf,
        "telefone": cliente.telefone
      }
    };

    final response = await ApiService.post(
        '/api/${EmpresaSingleton.empresa!.id}/agendamentos', dados);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      AgendamentoRetorno agendamento = AgendamentoRetorno.fromJson(jsonData);
      String dataVisual = Util.formatarDataDmy(agendamento.data);
      retorno =
          'Agendado ${servico.descricao} dia $dataVisual às ${agendamento.hora.substring(0, 5)} hrs';
    } else {
      final Map<String, dynamic> data = json.decode(response.body);
      ErroRequisicao erro = ErroRequisicao.fromJson(data);
      retorno = erro.mensagemFormatada();
    }

    return retorno;
  }

  Future<bool> cancelarAgendamento(int idProfissional, String data, String hora) async {
    final Map<String, dynamic> dados = {
      "idEmpresa": EmpresaSingleton.empresa!.id,
      "idProfissional": idProfissional,
      "data": data,
      "hora": hora
    };

    final response = await ApiService.post(
        '/api/${EmpresaSingleton.empresa!.id}/agendamentos/cancelar', dados);
    if (response.statusCode == 200) {
      return true;
    } else {
      final Map<String, dynamic> data = json.decode(response.body);
      ErroRequisicao erro = ErroRequisicao.fromJson(data);
      throw Exception('Erro ao formatar os dados: ${erro.mensagemFormatada()}');
    }
  }
}
