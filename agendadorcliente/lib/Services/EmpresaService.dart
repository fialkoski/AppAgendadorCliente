import '../Models/Empresa.dart';
import 'package:agendadorcliente/Services/ApiService.dart';

class EmpresaService {
  Future<Empresa> buscarEmpresaPorCpfcnpj(String cpfcnpj) async {
    return ApiService.buscar<Empresa>(
        '/api/empresas/cpfcnpj/$cpfcnpj', Empresa.fromJson);
  }
}
