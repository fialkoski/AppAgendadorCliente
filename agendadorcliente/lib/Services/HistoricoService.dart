import 'package:agendadorcliente/Models/Historico.dart';
import 'package:agendadorcliente/Services/ApiService.dart';
import 'package:agendadorcliente/Singleton/EmpresaSingleton.dart';

class HistoricoService {
  Future<List<Historico>> buscarHistoricoPorCpf(String cpf) async {
    return ApiService.buscarLista<Historico>(
        '/api/${EmpresaSingleton.empresa!.id}/historicos/$cpf',
        Historico.fromJson);
  }

}
