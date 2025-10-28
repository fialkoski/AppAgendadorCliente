import 'package:flutter/material.dart';
import 'package:agendadorcliente/models/empresa.dart';

class EmpresaSingleton {
  static Empresa? empresa;

  static void setEmpresa(Empresa emp) {
    empresa = emp;
  }

  static Empresa? getEmpresa() {
    return empresa;
  }
}

class NavigationController {
  static final ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);
}
