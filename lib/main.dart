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
        primarySwatch: Colors.blue,
        primaryColorDark: const Color(0xFF1c4587),
        primaryColor: const Color(0xFFA4C2F4),
        primaryColorLight: Colors.white,
        cardColor: const Color(0xFFC9DAF8),
        shadowColor: Colors.black,
        brightness: Brightness.light,
        useMaterial3: true,
        fontFamily: "NovaSquare",
      ),
      home: const HomePage(title: 'QR Notes'),
    );
  }
}
