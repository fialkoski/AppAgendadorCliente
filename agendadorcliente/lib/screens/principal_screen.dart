import 'package:agendadorcliente/screens/agendamento_servico_screen.dart';
import 'package:agendadorcliente/screens/historico_screen.dart';
import 'package:agendadorcliente/singleton/empresa_singleton.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;

class PrincipalScreen extends StatefulWidget {
  final String cpfcnpj;

  const PrincipalScreen({super.key, required this.cpfcnpj});

  @override
  PrincipalScreenState createState() => PrincipalScreenState();
}

class PrincipalScreenState extends State<PrincipalScreen> {
  List<Widget> get _pages => [
        AgendamentoServicoScreen(cpfcnpj: widget.cpfcnpj),
        HistoricoScreen(),
      ];

  void _onItemTapped(int index) {
    NavigationController.selectedIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<int>(
        valueListenable: NavigationController.selectedIndex,
        builder: (context, index, _) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            },
            child: KeyedSubtree(
              key: ValueKey(index),
              child: _pages[index],
            ),
          );
        },
      ),
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: NavigationController.selectedIndex,
        builder: (context, index, _) {
          switch (index) {
            case 0:
              html.document.title = 'Agendamento - Barbearia';
              break;
            case 1:
              html.document.title = 'Histórico - Barbearia';
              break;
          }
          return BottomNavigationBar(
            selectedItemColor: Theme.of(context).colorScheme.secondary,
            backgroundColor: const Color.fromARGB(255, 14, 14, 15),
            unselectedItemColor: Colors.grey[400],
            currentIndex: index,
            onTap: _onItemTapped,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month),
                label: 'Agendamento',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history_toggle_off),
                label: 'Histórico',
              ),
            ],
          );
        },
      ),
    );
  }
}
