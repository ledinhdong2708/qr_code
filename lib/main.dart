import 'package:flutter/material.dart';
import 'package:qr_code/page/purchasing.dart';
import 'package:qr_code/page/home.dart';
import 'package:qr_code/page/login.dart';
import 'package:qr_code/page/test_qrcode.dart';
import 'package:qr_code/page/user_detail.dart';

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
        '/home/user_detail': (context) => const UserDetail(),
        '/home/purchasing/credit_memo/test_qrcode': (context) =>
            const TestQrCode(),
      },
    );
  }
}
