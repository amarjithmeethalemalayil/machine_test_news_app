import 'package:flutter/material.dart';

void main() {
  runApp(const MachineTestNewsApp());
}

class MachineTestNewsApp extends StatelessWidget {
  const MachineTestNewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(),
    );
  }
}
