import 'package:flutter/material.dart';
import 'home/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Notes',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        // useMaterial3: true
      ),
      home: const HomePage(title: 'QR Notes'),
    );
  }
}
