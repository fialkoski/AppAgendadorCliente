import 'dart:ui';

import 'package:agendadorcliente/models/empresa.dart';
import 'package:agendadorcliente/models/servico.dart';
import 'package:agendadorcliente/screens/agendamento_data_screen.dart';
import 'package:agendadorcliente/screens/nao_encontrado_screen.dart';
import 'package:agendadorcliente/services/agendamento_service.dart';
import 'package:agendadorcliente/services/empresa_service.dart';
import 'package:agendadorcliente/singleton/empresa_singleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class AgendamentoServicoScreen extends StatefulWidget {
  final String cpfcnpj;
  const AgendamentoServicoScreen({super.key, required this.cpfcnpj});

  @override
  AgendamentoServicoScreenState createState() =>
      AgendamentoServicoScreenState();
}

class AgendamentoServicoScreenState extends State<AgendamentoServicoScreen> {
  AgendamentoService agendamentoService = AgendamentoService();
  EmpresaService empresaService = EmpresaService();

  Future<List<Servico>> _futureListaServico = Future.value([]);
  late Future<Empresa> _futureEmpresa;

  @override
  void initState() {
    super.initState();
    if (EmpresaSingleton.empresa?.cpfCnpj == widget.cpfcnpj) {
      setState(() {
        _futureEmpresa = Future.value(EmpresaSingleton.empresa);
        _futureListaServico = agendamentoService.buscarListaServico();
      });
    } else {
      _futureEmpresa = empresaService.buscarEmpresaPorCpfcnpj(widget.cpfcnpj);
      _futureEmpresa.then((empresa) {
        EmpresaSingleton.empresa = empresa;
        setState(() {
          _futureListaServico = agendamentoService.buscarListaServico();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
              child: Column(
                children: [_buildEmpresa(), _buildServicos()],
              ));
        },
      ),
    );
  }

  Widget _buildEmpresa() {
    return FutureBuilder<Empresa>(
      future: _futureEmpresa,
      builder: (context, snapshot2) {
        if (snapshot2.connectionState == ConnectionState.waiting) {
          return Shimmer.fromColors(
            baseColor: Color.fromARGB(255, 14, 14, 15),
            highlightColor: Color.fromARGB(255, 36, 36, 39),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 16.r),
                Container(
                  width: 100.r,
                  height: 50.r,
                  color: Color.fromARGB(255, 14, 14, 15),
                ),
                SizedBox(height: 16.r),
                Container(
                  width: 200.r,
                  height: 24.r,
                  color: Color.fromARGB(255, 14, 14, 15),
                ),
                SizedBox(height: 4.r),
                Container(
                  width: 150.r,
                  height: 20.r,
                  color: Color.fromARGB(255, 14, 14, 15),
                ),
                SizedBox(height: 16.r),
              ],
            ),
          );
        } else if (snapshot2.hasError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NaoEncontradoScreen(
                      mensagem: snapshot2.error
                          .toString()
                          .replaceFirst('Exception: ', ''))),
            );
          });
          return Center(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                      snapshot2.error
                          .toString()
                          .replaceFirst('Exception: ', ''),
                      style: Theme.of(context).textTheme.titleSmall)));
        } else if (snapshot2.hasData) {
          final empresa = snapshot2.data!;
          return Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 16.r),
                  (empresa.foto.isEmpty) ? SizedBox(height: 16.r) :
                  Image.network(empresa.foto,
                    fit: BoxFit.fill,
                    width: 100.r,
                    height: 50.r,
                  ),
                  SizedBox(height: 16.r),
                  Text(
                    empresa.nome,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 4.r),
                  Text(
                    '${empresa.endereco.rua}, ${empresa.endereco.numero} - ${empresa.endereco.cidade}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(height: 16.r),
                ],
              ));
        } else {
          return const Center(child: Text('Nenhum serviço disponível.'));
        }
      },
    );
  }

  Widget _buildServicos() {
    return Expanded(
      flex: 2,
      child: FutureBuilder<List<Servico>>(
        future: _futureListaServico,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.orange)));
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
                    snapshot.error.toString().replaceFirst('Exception: ', '')));
          } else if (snapshot.hasData) {
            final servicos = snapshot.data!;
            return Column(children: [
              Row(
                children: [
                  SizedBox(width: 8.r),
                  Text(
                    'Serviços',
                    style: Theme.of(context).textTheme.headlineMedium,
                  )
                ],
              ),
              SizedBox(height: 8.r),
              Expanded(
                  child: SingleChildScrollView(
                      child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(
                            dragDevices: {
                              PointerDeviceKind.touch,
                              PointerDeviceKind.mouse,
                            },
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Card(
                                  child: Padding(
                                      padding: const EdgeInsets.all(24),
                                      child: SingleChildScrollView(
                                        child: Wrap(
                                          spacing: 16,
                                          runSpacing: 16,
                                          alignment: WrapAlignment.center,
                                          children: servicos
                                              .map((servico) =>
                                                  _buildItemServico(servico))
                                              .toList(),
                                        ),
                                      ))),
                            ],
                          ))))
            ]);
          } else {
            return const Center(child: Text('Nenhum serviço disponível.'));
          }
        },
      ),
    );
  }

  Widget _buildItemServico(Servico servico) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AgendamentoDataScreen(
              servico: servico,
            ),
          ),
        );
      },
      style: Theme.of(context).elevatedButtonTheme.style,
      child: SizedBox(
        width: 120.r,
        height: 150.r,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 16.r,
            ),
            Icon(getIconForServico(servico.descricao),
                size: 40.r, color: Colors.grey[600]),
            SizedBox(
              height: 8.r,
            ),
            Text(
              textAlign: TextAlign.center,
              servico.descricao,
              style: TextStyle(fontSize: 16, color: Colors.grey[200]),
            ),
            const Spacer(),
            if (servico.tempo.toString().isNotEmpty)
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.access_time,
                        size: 14.r,
                        color: Theme.of(context).colorScheme.secondary),
                    SizedBox(width: 4.0),
                    Text('${servico.tempo} min',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelSmall)
                  ],
                ),
              ),
            SizedBox(
              height: 8.r,
            ),
          ],
        ),
      ),
    );
  }

  IconData getIconForServico(String descricao) {
    final desc = descricao.toLowerCase();

    if (desc.contains('sobrancelha')) return Icons.remove_red_eye;
    if (desc.contains('barba')) return Icons.face_retouching_natural;
    if (desc.contains('cabelo') || desc.contains('corte')) return Icons.cut;
    if (desc.contains('hidrata') ||
        desc.contains('progressiva') ||
        desc.contains('alisamento')) {
      return Icons.water_drop;
    }
    if (desc.contains('tintura') || desc.contains('pintura')) {
      return Icons.palette;
    }
    if (desc.contains('massagem')) return Icons.spa;
    return Icons.content_cut; // padrão
  }
}
