import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'core/utils/di/di.dart';
import 'features/presentation/ui/instruments_screen.dart' show InstrumentsScreen;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocators();
  runApp(const OKXApp());
}

class OKXApp extends StatelessWidget {
  const OKXApp({super.key});

  @override
  Widget build(BuildContext context) {
    if(!kIsWeb){
      if(Platform.isIOS || Platform.isMacOS){
        return CupertinoApp(
          title: 'OKX App',
          home: InstrumentsScreen(),
        );
      }
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true
      ),
      title: 'OKX App',
      home: InstrumentsScreen(),
    );
  }
}
