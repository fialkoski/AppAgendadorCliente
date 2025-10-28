import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Util {
  static void showMensagem(BuildContext context, String mensagem) {
    final snackBar = SnackBar(
      content: Text(mensagem),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showToast(String msg, Color colorFunfo) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: colorFunfo,
      textColor: Colors.black87,
      fontSize: 16.0,
      timeInSecForIosWeb: 2,
      webPosition: "center",
      webBgColor: "linear-gradient(to right, #f5dc84, #e6b405)",
    );
  }

  static String getWeekdayName(DateTime date) {
    const weekdays = [
      'Segunda',
      'Terça',
      'Quarta',
      'Quinta',
      'Sexta',
      'Sábado',
      'Domingo',
    ];
    return weekdays[date.weekday - 1];
  }

  static salvaDadosLocal(String chave, String valor) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(chave, valor);
  }

  static Future<String> buscarDadosLocal(String chave) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(chave) ?? '';
  }

  static String formatarData(String data, {apenasDataFormatada = false}) {
    if (apenasDataFormatada) {
      DateTime dateTime = DateTime.parse(data);
      return DateFormat('yyyy-MM-dd').format(dateTime);
    } else {
      String ano = '';
      String mes = '';
      String dia = '';
      List<String> partes = data.split('-');

      // Reorganiza as partes no formato desejado
      if (partes[2].length == 4) {
        ano = partes[2];
        mes = partes[1];
        dia = partes[0];
        return "$ano-$mes-$dia";
      } else {
        return data;
      }
    }
  }

  static String formatarDataDmy(String data) {
    try {
      final date = DateTime.parse(data);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return data;
    }
  }

  static bool validarCPF(String cpf) {
    cpf = cpf.replaceAll(RegExp(r'\D'), '');
    if (cpf.length != 11 || RegExp(r'^(\d)\1*$').hasMatch(cpf)) return false;

    List<int> digits = cpf.split('').map(int.parse).toList();

    // Validação do primeiro dígito verificador
    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += digits[i] * (10 - i);
    }
    int firstCheck = (sum * 10) % 11;
    if (firstCheck == 10) firstCheck = 0;
    if (firstCheck != digits[9]) return false;

    // Validação do segundo dígito verificador
    sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += digits[i] * (11 - i);
    }
    int secondCheck = (sum * 10) % 11;
    if (secondCheck == 10) secondCheck = 0;
    if (secondCheck != digits[10]) return false;

    return true;
  }
}
