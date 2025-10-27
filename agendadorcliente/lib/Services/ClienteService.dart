import 'package:agendadorcliente/Models/Cliente.dart';
import 'package:agendadorcliente/Repository/ClienteRepository.dart';

class ClienteService {
  final ClienteRepository _clienteRepository = ClienteRepository();

  salvarClienteLocal(Cliente cliente) {
    _clienteRepository.salvarClienteLocal(cliente);
  }

  Future<Cliente> buscarClienteLocal() {
    return _clienteRepository.buscarClienteLocal();
  }
}
