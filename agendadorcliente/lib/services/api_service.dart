import 'dart:async';
import 'dart:convert';
import 'package:agendadorcliente/tools/util.dart';
import 'package:agendadorcliente/tools/util_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ApiService {
  static String URLBASE = kDebugMode ? 'http://localhost:8080' :
         'https://agendador-fzghg9hrh9bgb9dm.canadacentral-01.azurewebsites.net';

  static Future<T> buscar<T>(
      String url, T Function(Map<String, dynamic>) fromJson) async {
    try {
      final meuToken = await buscarToken();
      final response = await http.get(
        Uri.parse('$URLBASE$url'),
        headers: {
          'Authorization': 'Bearer $meuToken',
        },
      ).timeout(Duration(seconds: 20));

      print(
          'Requisição:$URLBASE$url\nHTTP:${response.statusCode}\nJSON retornado: ${response.body}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return fromJson(data);
      } else {
        throw UtilException.exceptionRequisicaoApi(response);
      }
    } on TimeoutException {
      throw Exception('A solicitação excedeu o tempo limite');
    } on FormatException catch (e) {
      throw Exception('Erro ao formatar os dados: ${e.message}');
    } catch (e) {
      throw Exception(
          'Falha ao buscar dados: ${e.toString().replaceFirst('Exception: ', '')}');
    }
  }

  static Future<List<T>> buscarLista<T>(
      String url, T Function(Map<String, dynamic>) fromJson) async {
    try {
      final meuToken = await buscarToken();
      final response = await http.get(
        Uri.parse('$URLBASE$url'),
        headers: {
          'Authorization': 'Bearer $meuToken',
        },
      ).timeout(Duration(seconds: 15));
      print(
          'Requisição:$URLBASE$url\nHTTP:${response.statusCode}\nJSON retornado: ${response.body}');
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => fromJson(json)).toList();
      } else {
        throw UtilException.exceptionRequisicaoApi(response);
      }
    } on TimeoutException {
      throw Exception('A solicitação excedeu o tempo limite');
    } on FormatException catch (e) {
      throw Exception('Erro ao formatar os dados: ${e.message}');
    } catch (e) {
      throw Exception(
          'Falha ao buscar dados: ${e.toString().replaceFirst('Exception: ', '')}');
    }
  }

  static Future<Response> post(
      String url, Map<String, dynamic> jsonDados) async {
    try {
      final meuToken = await buscarToken();
      final response = await http.post(
        Uri.parse('$URLBASE$url'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $meuToken',
        },
        body: json.encode(jsonDados),
      );

      print(
          'Requisição:$URLBASE$url\nHTTP:${response.statusCode}\nJSON retornado: ${response.body}');
      return response;
    } on TimeoutException {
      throw Exception('A solicitação excedeu o tempo limite');
    } on FormatException catch (e) {
      throw Exception('Erro ao formatar os dados: ${e.message}');
    } catch (e) {
      throw Exception(
          'Falha ao enviar dados: ${e.toString().replaceFirst('Exception: ', '')}');
    }
  }

  static Future<String> postToken() async {
    DateTime nowUtc = DateTime.now().toUtc();
    String utcString =
        nowUtc.toIso8601String().substring(0, 10).replaceAll("-", "");
    String base64_1 = base64Encode(utf8.encode(utcString));
    String base64_2 = base64Encode(utf8.encode(base64_1));

    final Map<String, dynamic> dados = {
      "usuario": "BarbeariaApp",
      "senha": base64_2
    };
    try {
      final response = await http.post(
        Uri.parse('$URLBASE/api/auth/token'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(dados),
      );
      print(
          'Requisição:$URLBASE/api/auth/token\nHTTP:${response.statusCode}\nJSON retornado: ${response.body}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['token'] != null) {
          Util.salvaDadosLocal('token', data['token']);
        }
        return data['token'];
      } else {
        throw UtilException.exceptionRequisicaoApi(response);
      }
    } on TimeoutException {
      throw Exception('A solicitação excedeu o tempo limite');
    } on FormatException catch (e) {
      throw Exception('Erro ao formatar os dados: ${e.message}');
    } catch (e) {
      throw Exception(
          'Falha ao enviar dados: ${e.toString().replaceFirst('Exception: ', '')}');
    }
  }

  static Future<String> buscarToken() async {
    var meuToken = await Util.buscarDadosLocal('token');
    if (meuToken.isEmpty) {
      meuToken = await ApiService.postToken();
    } else {
      DateTime nowUtcMinus3 = DateTime.now().toUtc();
      DateTime? expiration =
          getJwtExpiration(meuToken)?.subtract(const Duration(hours: 4));
      if (expiration == null || nowUtcMinus3.isAfter(expiration)) {
        meuToken = await ApiService.postToken();
      }
    }
    return meuToken;
  }

  static DateTime? getJwtExpiration(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      String normalized = base64.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final payloadMap = json.decode(decoded);

      if (payloadMap is! Map<String, dynamic>) return null;
      if (!payloadMap.containsKey('exp')) return null;

      final exp = payloadMap['exp'];
      return DateTime.fromMillisecondsSinceEpoch(exp * 1000, isUtc: true);
    } catch (e) {
      return null;
    }
  }
}
