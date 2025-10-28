import 'package:agendadorcliente/models/empresa.dart';
import 'package:agendadorcliente/services/api_service.dart';

class EmpresaService {
  Future<Empresa> buscarEmpresaPorCpfcnpj(String cpfcnpj) async {
    return ApiService.buscar<Empresa>(
        '/api/empresas/cpfcnpj/$cpfcnpj', Empresa.fromJson);
  }
}
