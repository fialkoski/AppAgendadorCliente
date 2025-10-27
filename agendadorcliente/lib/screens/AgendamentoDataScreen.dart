import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:agendadorcliente/Models/Agenda.dart';
import 'package:agendadorcliente/Models/Agendamento.dart';
import 'package:agendadorcliente/Models/Cliente.dart';
import 'package:agendadorcliente/Models/Servico.dart';
import 'package:agendadorcliente/Screens/AgendamentoClienteScreen.dart';
import 'package:agendadorcliente/Services/AgendamentoService.dart';
import 'package:agendadorcliente/Singleton/EmpresaSingleton.dart';
import 'package:agendadorcliente/Tools/Util.dart';
import '../Models/Profissional.dart';

class AgendamentoDataScreen extends StatefulWidget {
  final Servico servico;
  const AgendamentoDataScreen({super.key, required this.servico});

  @override
  AgendamentoDataScreenState createState() => AgendamentoDataScreenState();
}

class AgendamentoDataScreenState extends State<AgendamentoDataScreen> {
  AgendamentoService agendamentoService = AgendamentoService();
  Agendamento agendamento = Agendamento(
      cliente: Cliente(nome: '', cpf: '', telefone: ''),
      data: DateTime(0),
      hora: '',
      idEmpresa: 0,
      idProfissional: 0,
      nomeProfissional: '',
      idServico: 0);

  int _currentStep = 1;
  bool isLoading = false;

  late Future<List<Agenda>> listaAgenda;

  @override
  initState() {
    super.initState();
    listaAgenda = agendamentoService.buscarListaAgenda();
    agendamento.idEmpresa = EmpresaSingleton.empresa!.id;
    agendamento.idServico = widget.servico.id;
    listaAgenda.then((agenda) {
      setState(() {
        agendamento.data = DateTime.parse(Util.formatarData(agenda.first.data));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back)),
            title: const Text('Agendamento',
                style: TextStyle(color: Colors.white)),
            centerTitle: true,
            backgroundColor: Color.fromARGB(255, 14, 14, 15),
            iconTheme: IconThemeData(color: Colors.white)),
        body: FutureBuilder<List<Agenda>>(
          future: listaAgenda,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.orange)));
            } else if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Nenhuma agenda disponível.'));
            }

            final agendas = snapshot.data!;
            return Column(children: [
              Expanded(
                  child: SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStepProgresso(),
                    _buildData(context, agendas),
                    _buildProfissional(context, agendas),
                    _buildHorario(context, agendas),
                  ],
                ),
              )),
              _buildBotaoConfirmacao()
            ]);
          },
        ),
      ),
      if (isLoading)
        Container(
          color: Colors.black45,
          child: Center(
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange)),
          ),
        ),
    ]);
  }

  Widget _buildStepProgresso() {
    return EasyStepper(
      activeStep: _currentStep + 1,
      lineStyle: LineStyle(
        lineLength: 80.r,
        lineType: LineType.normal,
        lineThickness: 1,
        lineSpace: 1,
        lineWidth: 6.r,
        defaultLineColor: Theme.of(context).colorScheme.surfaceBright,
        finishedLineColor: Theme.of(context).colorScheme.surface,
        unreachedLineType: LineType.dashed,
      ),
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      stepRadius: 6,
      finishedStepTextColor: Theme.of(context).colorScheme.surfaceBright,
      activeStepBackgroundColor: Theme.of(context).colorScheme.secondary,
      steps: [
        EasyStep(
          customStep: CircleAvatar(
            radius: 8,
            backgroundColor: Theme.of(context).colorScheme.surface,
          ),
          customTitle: Text(
            widget.servico.descricao,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 11.r, color: Theme.of(context).colorScheme.surface),
          ),
        ),
        EasyStep(
          customStep: CircleAvatar(
            radius: 8,
            backgroundColor: _currentStep == 0
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.surface,
          ),
          customTitle: Text(
            !agendamento.data.isAtSameMomentAs(DateTime(0))
                ? '${Util.getWeekdayName(agendamento.data)} dia ${agendamento.data.day}'
                : 'Data',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 11.r,
                color: _currentStep == 0
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.surface),
          ),
        ),
        EasyStep(
          customStep: CircleAvatar(
            radius: 8,
            backgroundColor: _currentStep == 1
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.surface,
          ),
          customTitle: Text(
            agendamento.nomeProfissional.isNotEmpty
                ? agendamento.nomeProfissional
                : 'Barbeiro',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 11.r,
                color: _currentStep == 1
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.surface),
          ),
        ),
        EasyStep(
          customStep: CircleAvatar(
            radius: 8,
            backgroundColor: _currentStep == 2
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.surface,
          ),
          customTitle: Text(
            agendamento.hora.isNotEmpty
                ? agendamento.hora.substring(0, 5)
                : 'Horário',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 11.r,
                color: _currentStep == 2
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.surface),
          ),
        ),
      ],
    );
  }

  Widget _buildData(BuildContext context, List<Agenda> agendas) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'Datas disponíveis',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      SizedBox(height: 8.r),
      Card(
          child: Padding(
        padding: const EdgeInsets.all(24),
        child: Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: agendas.map((agenda) {
                  final DateTime data =
                      DateTime.parse(Util.formatarData(agenda.data));
                  return _buildItemData(data);
                }).toList(),
              ),
            )),
      )),
      SizedBox(height: 24.r),
    ]);
  }

  Widget _buildItemData(DateTime data) {
    return SingleChildScrollView(
      child: ElevatedButton(
          onPressed: () {
            setState(() {
              _currentStep = 1;
              agendamento.data = data;
              agendamento.idProfissional = 0;
              agendamento.nomeProfissional = '';
              agendamento.hora = '';
            });
          },
          style: Theme.of(context).elevatedButtonTheme.style,
          child: Padding(
            padding: EdgeInsetsGeometry.only(left: 8, right: 8, top: 16, bottom: 16),
            child: Column(children: [
              Text(
                '  ${data.day}  ',
                style: TextStyle(
                  fontSize: 28.r,
                  fontWeight: FontWeight.bold,
                  color: data == agendamento.data
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.surface,
                ),
              ),
              Text(Util.getWeekdayName(data),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: data == agendamento.data
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.surface,
                      )),
            ]),
          )),
    );
  }

  Widget _buildProfissional(BuildContext context, List<Agenda> agendas) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Barbeiros',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        SizedBox(height: 8.r),
        ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            child: Card(
                child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Align(
                      alignment: Alignment.center,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          alignment: WrapAlignment.center,
                          children: agendas
                              .where((agenda) =>
                                  DateTime.parse(
                                      Util.formatarData(agenda.data)) ==
                                  agendamento.data)
                              .expand((agenda) => agenda.profissionais ?? [])
                              .map((profissional) =>
                                  _buildItemProfissional(profissional))
                              .toList(),
                        ),
                      ),
                    )))),
        SizedBox(height: 24.r),
      ],
    );
  }

  Widget _buildItemProfissional(Profissional profissional) {
    return SingleChildScrollView(
        child: ElevatedButton(
      onPressed: () {
        setState(() {
          _currentStep = 2;
          agendamento.nomeProfissional = profissional.nome;
          agendamento.idProfissional = profissional.id;
          agendamento.hora = '';
        });
      },
      style: Theme.of(context).elevatedButtonTheme.style,
      child: SizedBox(
        width: 110.r,
        height: 120.r,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            profissional.foto == ''
                ? Icon(Icons.person,
                    size: 40.r,
                    color: agendamento.idProfissional == profissional.id
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.surface)
                : ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: profissional.foto,
                      fit: BoxFit.cover,
                      width: 55.r,
                      height: 55.r,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.person,
                          size: 40.r,
                          color: agendamento.idProfissional == profissional.id
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).colorScheme.surface),
                    ),
                  ),
            SizedBox(height: 4.r),
            Text(
                textAlign: TextAlign.center,
                profissional.nome,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: agendamento.idProfissional == profissional.id
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.surface,
                    )),
          ],
        ),
      ),
    ));
  }

  Widget _buildHorario(BuildContext context, List<Agenda> agendas) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'Horários disponíveis',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      SizedBox(height: 8.r),
      Card(
          child: Padding(
              padding: const EdgeInsets.all(24),
              child: Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: (agendamento.data.isAtSameMomentAs(DateTime(0)) ||
                            (agendamento.idProfissional == 0))
                        ? [
                            Text(
                                "Selecione um barbeiro para exibir os horários disponíveis",
                                style: Theme.of(context).textTheme.labelMedium)
                          ]
                        : agendas.where((agenda) {
                            final agendaDate =
                                DateTime.parse(Util.formatarData(agenda.data));
                            //agendamento.data = Util.formatarData(agenda.data);
                            return agendaDate.day == agendamento.data.day &&
                                agendaDate.month == agendamento.data.month &&
                                agendaDate.year == agendamento.data.year;
                          }).expand((agenda) {
                            // Encontramos o barbeiro selecionado na agenda
                            if (agenda.profissionais == null) {
                              return [Text("Nenhum horário disponível")];
                            } else if (agenda.profissionais!.isNotEmpty) {
                              final selectedBarber = agenda.profissionais!
                                  .firstWhere((barber) =>
                                      barber.id == agendamento.idProfissional);

                              return selectedBarber.horarios
                                  .map((horario) => _buildItemHorario(horario))
                                  .toList();
                            } else {
                              return [Text("Nenhum horário disponível")];
                            }
                          }).toList(),
                  ),
                ),
              ))),
      SizedBox(height: 16.r),
    ]);
  }

  Widget _buildItemHorario(String horario) {
    return SingleChildScrollView(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _currentStep = 3;
            agendamento.hora = horario;
          });
        },
        style: Theme.of(context).elevatedButtonTheme.style,
        child: Padding(
            padding: EdgeInsets.only(top: 8.r, bottom: 8.r),
            child: Text('    ${horario.substring(0, 5)}    ',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontSize: 14,
                      color: agendamento.hora == horario
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.surface,
                    ))),
      ),
    );
  }

  Widget _buildBotaoConfirmacao() {
    return Column(children: [
      Padding(
          padding: const EdgeInsets.only(
              left: 16.0, top: 8.0, right: 16.0, bottom: 8.0),
          child: ElevatedButton(
            onPressed: _currentStep == 3
                ? () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AgendamentoClienteScreen(
                              agendamento: agendamento,
                              servico: widget.servico),
                        ),
                      )
                    }
                : null,
            style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                  padding: WidgetStateProperty.all(
                      EdgeInsets.symmetric(vertical: 16)),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  )),
                  backgroundColor: _currentStep == 3
                      ? WidgetStateProperty.all(
                          Theme.of(context).colorScheme.secondary)
                      : WidgetStateProperty.all(
                          Color.fromARGB(255, 14, 14, 15)),
                ),
            child: Text('    Continuar agendamento    ',
                style: Theme.of(context).textTheme.labelLarge),
          ))
    ]);
  }
}
