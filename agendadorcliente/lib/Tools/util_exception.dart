import 'dart:convert';
import 'package:agendadorcliente/models/errorequisicao.dart';
import 'package:http/http.dart';

class UtilException {
  static Exception exceptionRequisicaoApi(Response response) {
    if (response.statusCode == 403) {
      return Exception('Oops! Parece que você não tem acesso a esta página. Tente atualizar a página para continuar');
    } else if (response.body.isEmpty) {
      return Exception('Erro HTTP: ${response.statusCode}');
    }

    final Map<String, dynamic> data = json.decode(response.body);
    ErroRequisicao erro = ErroRequisicao.fromJson(data);
    return Exception(erro.mensagemFormatada());
  }
}
