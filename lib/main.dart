import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'calculator_bloc.dart';
import 'calculator_page.dart';
import 'config_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calculator',
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      initialRoute: '/',
      routes: {
        '/': (context) => BlocProvider(
              create: (context) => CalculatorBloc(),
              child: CalculatorPage(isDarkMode: _isDarkMode),
            ),
        '/config': (context) => ConfigPage(
              isDarkMode: _isDarkMode,
              toggleTheme: toggleTheme,
            ),
      },
    );
  }
}
