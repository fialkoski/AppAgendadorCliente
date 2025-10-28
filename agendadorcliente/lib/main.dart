import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'configurations/apptema.dart';
import 'configurations/rotasconfig.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  usePathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Tamanho base para iPhone X
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp.router(
            routerConfig: RotasConfig.getRouter(),
            debugShowCheckedModeBanner: false,
            theme: AppTema.theme);
      },
    );
  }
}
