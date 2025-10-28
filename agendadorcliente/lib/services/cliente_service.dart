
import 'package:agendadorcliente/models/cliente.dart';
import 'package:agendadorcliente/repository/cliente_repository.dart';

class ClienteService {
  final ClienteRepository _clienteRepository = ClienteRepository();

  salvarClienteLocal(Cliente cliente) {
    _clienteRepository.salvarClienteLocal(cliente);
  }

  Future<Cliente> buscarClienteLocal() {
    return _clienteRepository.buscarClienteLocal();
  }
}
