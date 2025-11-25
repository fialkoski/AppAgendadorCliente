import 'package:agendadorcliente/screens/historico_screen.dart';
import 'package:agendadorcliente/screens/nao_encontrado_screen.dart';
import 'package:agendadorcliente/screens/principal_screen.dart';
import 'package:go_router/go_router.dart';

class RotasConfig {
  static GoRouter getRouter() {
    return GoRouter(
      routes: [
        GoRoute(
            path: '/',
            builder: (context, state) => PrincipalScreen(
                cpfcnpj: "09269626989") //NaoEncontradoScreen(),
            ),
        GoRoute(
          path: '/agenda/:cnpjcpf',
          builder: (context, state) {
            final cnpjCpfParamentro = state.pathParameters['cnpjcpf'];
            return (cnpjCpfParamentro == null)
                ? NaoEncontradoScreen(mensagem: "CNPJ/CPF não informado")
                : PrincipalScreen(cpfcnpj: cnpjCpfParamentro);
          },
        ),
        GoRoute(
            path: '/historico', builder: (context, state) => HistoricoScreen()),
      ],
    );
  }
}
