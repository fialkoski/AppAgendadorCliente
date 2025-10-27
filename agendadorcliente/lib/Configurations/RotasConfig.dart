import 'package:go_router/go_router.dart';
import 'package:agendadorcliente/Screens/HistoricoScreen.dart';
import 'package:agendadorcliente/Screens/NaoEncontradoScreen.dart';
import 'package:agendadorcliente/Screens/PrincipalScreen.dart';



class RotasConfig {
  static GoRouter getRouter() {
    return GoRouter(
      routes: [
        GoRoute(
            path: '/',
            builder: (context, state) => PrincipalScreen(
                cpfcnpj: "12345") //NaoEncontradoScreen(),
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
