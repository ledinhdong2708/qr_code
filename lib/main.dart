import 'package:flutter/material.dart';
import 'package:qr_code/page/purchasing.dart';
import 'package:qr_code/page/home.dart';
import 'package:qr_code/page/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const Login(),
        '/home': (context) => const Home(),
        '/home/purchasing': (context) => const Purchasing(),
      },
    );
  }
}
