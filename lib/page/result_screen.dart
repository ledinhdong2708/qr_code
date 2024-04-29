import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ResultScreen extends StatelessWidget {
  final Barcode? result;

  const ResultScreen({super.key, this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Result'),
      ),
      body: Center(
        child: Text('Scan result: ${result?.code}'),
      ),
    );
  }
}
