import 'package:flutter/material.dart';

class ConfigPage extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const ConfigPage({
    Key? key,
    required this.isDarkMode,
    required this.toggleTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuration'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Dark Mode'),
            Switch(
              value: isDarkMode,
              onChanged: (value) {
                toggleTheme();
              },
            ),
          ],
        ),
      ),
    );
  }
}
