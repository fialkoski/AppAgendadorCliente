import 'dart:async';

import 'package:agendadorcliente/models/agendamento.dart';
import 'package:agendadorcliente/models/cliente.dart';
import 'package:agendadorcliente/models/servico.dart';
import 'package:agendadorcliente/services/agendamento_service.dart';
import 'package:agendadorcliente/services/cliente_service.dart';
import 'package:agendadorcliente/singleton/empresa_singleton.dart';
import 'package:agendadorcliente/tools/util.dart';
import 'package:agendadorcliente/tools/util_texto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AgendamentoClienteScreen extends StatefulWidget {
  final Agendamento agendamento;
  final Servico servico;

  const AgendamentoClienteScreen(
      {super.key, required this.agendamento, required this.servico});

  @override
  AgendamentoClienteScreenState createState() =>
      AgendamentoClienteScreenState();
}

class AgendamentoClienteScreenState extends State<AgendamentoClienteScreen> {
  AgendamentoService agendamentoService = AgendamentoService();
  ClienteService clienteService = ClienteService();
  late Cliente cliente;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  bool isLoading = false;
  bool isSucesso = false;

  @override
  void initState() {
    super.initState();
    _carregarCliente();
  }

  void _carregarCliente() async {
    cliente = await clienteService.buscarClienteLocal();
    setState(() {
      _nomeController.text = cliente.nome;
      _cpfController.text = cliente.cpf;
      _telefoneController.text = cliente.telefone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Center(
              child: Form(
                  key: _formKey,
                  child: Card(
                      child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 32.r),
                              Center(
                                child: Icon(Icons.person,
                                    size: 80,
                                    color:
                                        Theme.of(context).colorScheme.surface),
                              ),
                              SizedBox(
                                height: 8.r,
                              ),
                              Text(
                                textAlign: TextAlign.center,
                                "Estamos quase lá!",
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              Text(
                                textAlign: TextAlign.center,
                                "Só precisamos que confirme seus dados.",
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              SizedBox(
                                height: 16.r,
                              ),
                              TextFormField(
                                controller: _nomeController,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.surface),
                                cursorColor:
                                    Theme.of(context).colorScheme.surfaceBright,
                                decoration: InputDecoration(
                                  labelText: 'Nome',
                                  labelStyle: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surface),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surfaceBright,
                                        width: 2),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        width: 2),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Por favor, insira o nome';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 15),
                              TextFormField(
                                controller: _cpfController,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.surface),
                                cursorColor:
                                    Theme.of(context).colorScheme.surfaceBright,
                                decoration: InputDecoration(
                                  labelText: 'CPF',
                                  labelStyle: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surface),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surfaceBright,
                                        width: 2),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        width: 2),
                                  ),
                                ),
                                inputFormatters: [UtilTexto.cpfFormatter()],
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Por favor, insira o CPF';
                                  }
                                  String cpfNumeros =
                                      value.replaceAll(RegExp(r'\D'), '');
                                  if (cpfNumeros.length != 11 ||
                                      !Util.validarCPF(cpfNumeros)) {
                                    return 'CPF inválido';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 15),
                              TextFormField(
                                controller: _telefoneController,
                                keyboardType: TextInputType.phone,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.surface),
                                cursorColor:
                                    Theme.of(context).colorScheme.surfaceBright,
                                decoration: InputDecoration(
                                  labelText: 'Telefone',
                                  labelStyle: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surface),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surfaceBright,
                                        width: 2),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        width: 2),
                                  ),
                                ),
                                inputFormatters: [
                                  UtilTexto.telefoneFormatter()
                                ],
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Por favor, insira o telefone';
                                  }
                                  if (value.length < 15) {
                                    return 'Insira um telefone válido (10-11 dígitos)';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 16.r,
                              ),
                              ElevatedButton(
                                onPressed: isLoading || isSucesso
                                    ? null
                                    : () async {
                                        if (_formKey.currentState!.validate() &&
                                            !isLoading) {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          try {
                                            cliente.nome =
                                                _nomeController.text.trim();
                                            cliente.cpf =
                                                _cpfController.text.trim();
                                            cliente.telefone =
                                                _telefoneController.text.trim();

                                            await agendamentoService
                                                .salvarAgendamento(
                                                    widget.agendamento
                                                        .idProfissional,
                                                    Util.formatarData(
                                                        widget.agendamento.data
                                                            .toString(),
                                                        apenasDataFormatada:
                                                            true),
                                                    widget.agendamento.hora,
                                                    widget.servico,
                                                    cliente)
                                                .then((resultado) {
                                              clienteService
                                                  .salvarClienteLocal(cliente);

                                              setState(() {
                                                isSucesso = resultado
                                                    .contains('Agendado');
                                              });
                                              if (!mounted) return;
                                              _onAlert(this.context, isSucesso,
                                                  resultado);
                                            });
                                          } finally {
                                            setState(() {
                                              isLoading = false;
                                            });
                                          }
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.secondary,
                                  foregroundColor:
                                      Theme.of(context).colorScheme.surface,
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                child: Text(
                                  isLoading
                                      ? '    Aguarde...    '
                                      : ((isSucesso)
                                          ? '    Enviado    '
                                          : '    Confirmar    '),
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ),
                              SizedBox(height: 32.r),
                            ],
                          )))),
            )));
  }

  _onAlert(context, bool isSussesso, String mensagem) {
    var alertStyle = AlertStyle(
        animationType: AnimationType.grow,
        isCloseButton: false,
        isOverlayTapDismiss: false,
        descStyle: TextStyle(fontWeight: FontWeight.bold),
        animationDuration: Duration(milliseconds: 400),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
          side: BorderSide(
            color: Colors.grey,
          ),
        ),
        titleStyle: TextStyle(
          color: isSussesso ? Colors.green[900] : Colors.red[800],
        ),
        overlayColor: Color(0x55000000),
        alertElevation: 0,
        alertAlignment: Alignment.center);

    Alert(
      context: context,
      style: alertStyle,
      type: isSussesso ? AlertType.success : AlertType.error,
      title: isSussesso ? 'CONFIRMADO!' : 'Ops!',
      desc: mensagem,
      buttons: [
        isSussesso
            ? DialogButton(
                onPressed: () async {
                  // 1) Fecha o alerta
                  Navigator.of(context, rootNavigator: true).pop();
                  // 2) Volta até a primeira rota (a PrincipalScreen)
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  // 3) Pequena espera para garantir que a tela principal esteja visível
                  await Future.delayed(const Duration(milliseconds: 200));
                  // 4) Atualiza a aba
                  NavigationController.selectedIndex.value = 1;
                },
                width: 100.r,
                child: Text(
                  "OK",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              )
            : DialogButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                width: 100.r,
                child: Text(
                  "Entendi",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              )
      ],
    ).show();
  }
}
