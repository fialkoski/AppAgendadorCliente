import 'package:flutter/material.dart';
import 'package:agendadorcliente/Models/Cliente.dart';
import 'package:agendadorcliente/Models/Historico.dart';
import 'package:agendadorcliente/Services/AgendamentoService.dart';
import 'package:agendadorcliente/Services/ClienteService.dart';
import 'package:agendadorcliente/Services/HistoricoService.dart';
import 'package:agendadorcliente/Tools/Util.dart';

class HistoricoScreen extends StatefulWidget {
  const HistoricoScreen({super.key});

  @override
  State<HistoricoScreen> createState() => _HistoricoScreenState();
}

class _HistoricoScreenState extends State<HistoricoScreen> {
  final HistoricoService historicoService = HistoricoService();
  final AgendamentoService agendamentoService = AgendamentoService();
  final ClienteService clienteService = ClienteService();
  Cliente cliente = Cliente(nome: '', cpf: '', telefone: '');

  @override
  void initState() {
    super.initState();
    _carregarCliente();
  }

  void _carregarCliente() async {
    Cliente cli = await clienteService.buscarClienteLocal();
    setState(() {
      cliente = cli;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.0, top: 24, right: 16),
            child: Text(
              "Histórico de agendamento",
              style: TextStyle(fontSize: 14, color: Colors.grey[400]),
            ),
          ),
          SizedBox(height: 8),
          if (cliente.cpf.isEmpty)
            Expanded(
                child: Center(
              child: Text(
                "Nenhum agendamento.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[400]),
              ),
            )),
          if (cliente.cpf.isNotEmpty)
            Expanded(
              child: FutureBuilder<List<Historico>>(
                future: historicoService.buscarHistoricoPorCpf(
                    cliente.cpf.replaceAll(RegExp(r'\D'), '')),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Erro ao carregar histórico: ${snapshot.error}",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final List<Historico> historicos = snapshot.data ?? [];
                    if (historicos.isEmpty) {
                      return Center(
                        child: Text(
                          "Nenhum agendamento.",
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[400]),
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: historicos.length,
                      itemBuilder: (context, index) {
                        final Historico historico = historicos[index];
                        final Color corTexto =
                            (historico.dataMaiorQueDataAtual())
                                ? Colors.black
                                : Colors.grey[400]!;
                        final double tamanhoButton =
                            (historico.dataMaiorQueDataAtual()) ? 32 : 16;

                        return Card(
                          color: (historico.dataMaiorQueDataAtual())
                              ? Colors.grey[100]!
                              : Theme.of(context).cardTheme.color,
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          margin: EdgeInsets.only(bottom: tamanhoButton),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(
                              historico.descricaoServico,
                              style: TextStyle(fontSize: 20, color: corTexto),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (historico.dataMaiorQueDataAtual())
                                  PopupMenuButton<String>(
                                    icon: Icon(
                                      Icons.more_vert,
                                      color: corTexto,
                                    ),
                                    onSelected: (value) async {
                                      if (value == 'cancelar') {
                                        final confirmar = await showDialog<bool>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            insetPadding: const EdgeInsets.all(32),
                                            buttonPadding: EdgeInsets.all(16),
                                            contentPadding: EdgeInsets.all(16),
                                            backgroundColor:
                                                Theme.of(context).cardTheme.color,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            title: Row(
                                              children: [
                                                Icon(
                                                  Icons.warning_amber_rounded,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  size: 28,
                                                ),
                                                const SizedBox(width: 8),
                                                Text('Cancelar agendamento', style: TextStyle(
                                                color: Colors.grey[200],
                                              ),),
                                              ],
                                            ),
                                            content: Text(
                                              'Deseja realmente cancelar este agendamento?',
                                              style: TextStyle(
                                                color: Colors.grey[200],
                                                fontSize: 16,
                                              ),
                                            ),
                                            actionsPadding:
                                                const EdgeInsets.all(16),
                                            actions: [
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  foregroundColor:
                                                      Colors.grey[400],
                                                ),
                                                onPressed: () =>
                                                    Navigator.of(context).pop(
                                                        false),
                                                child: const Text('  Não  '),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                  foregroundColor: Colors.black,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(8),
                                                  ),
                                                ),
                                                onPressed: () =>
                                                    Navigator.of(context).pop(
                                                        true),
                                                child: const Text('  Sim  '),
                                              ),
                                            ],
                                          ),
                                        );

                                        if (confirmar == true) {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (context) => const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          );

                                          try {
                                            final success =
                                                await agendamentoService
                                                    .cancelarAgendamento(
                                              historico.idProfissional,
                                              historico.data,
                                              historico.hora,
                                            );
                                            if (!mounted) return;
                                            Navigator.of(this.context).pop();
                                            if (success) {
                                              ScaffoldMessenger.of(this.context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    backgroundColor:
                                                        Colors.green[600],
                                                    content: Text(
                                                        'Agendamento cancelado!')),
                                              );
                                              setState(() {
                                                historicos.removeAt(index);
                                              });
                                            } else {
                                              ScaffoldMessenger.of(this.context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Falha ao cancelar o agendamento.')),
                                              );
                                            }
                                          } catch (error) {
                                            if (!mounted) return;
                                            Navigator.of(this.context).pop();
                                            ScaffoldMessenger.of(this.context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'Falha ao cancelar o agendamento: $error')),
                                            );
                                          }
                                        }
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 'cancelar',
                                        child: Text('Cancelar agendamento'),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            subtitle: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.person,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                    const SizedBox(width: 8),
                                    Text(
                                      historico.nomeProfissional,
                                      style: TextStyle(
                                          fontSize: 16, color: corTexto),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.date_range,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${Util.formatarDataDmy(historico.data)} às ${historico.hora.substring(0, 5)}',
                                      style: TextStyle(
                                          fontSize: 16, color: corTexto),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Text(
                        "Nenhum agendamento.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                      ),
                    );
                  }
                },
              ),
            )
        ],
      ),
    );
  }
}
