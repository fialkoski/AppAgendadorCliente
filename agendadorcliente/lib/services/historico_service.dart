import 'package:agendadorcliente/models/historico.dart';
import 'package:agendadorcliente/services/api_service.dart';
import 'package:agendadorcliente/singleton/empresa_singleton.dart';

class HistoricoService {
  Future<List<Historico>> buscarHistoricoPorCpf(String cpf) async {
    return ApiService.buscarLista<Historico>(
        '/api/${EmpresaSingleton.empresa!.id}/historicos/$cpf',
        Historico.fromJson);
  }

}
