

import 'package:agendadorcliente/models/cliente.dart';
import 'package:agendadorcliente/tools/util.dart';

class ClienteRepository {
  salvarClienteLocal(Cliente cliente) {
    Util.salvaDadosLocal('clienteNome', cliente.nome);
    Util.salvaDadosLocal('clienteCPF', cliente.cpf);
    Util.salvaDadosLocal('clienteTelefone', cliente.telefone);
  }

  Future<Cliente> buscarClienteLocal() async {
    return Cliente(
        nome: await Util.buscarDadosLocal('clienteNome'),
        cpf: await Util.buscarDadosLocal('clienteCPF'),
        telefone: await Util.buscarDadosLocal('clienteTelefone'));
  }
}
