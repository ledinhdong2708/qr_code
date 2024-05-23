import 'package:flutter/material.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/page/qr_view_example.dart';

class QRCodeInput extends StatelessWidget {
  final TextEditingController controller;

  QRCodeInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 90,
          margin: const EdgeInsets.all(10),
          child: const Text('SL Trả Lại',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Container(
            height: 45,
            margin: const EdgeInsets.all(10),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'SL Trả Lại',
                border: InputBorder.none,
                hintStyle: TextStyle(color: fieldInputText),
                fillColor: fieldInput,
                filled: true,
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.qr_code,
            size: 30,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const QRViewExample()),
            );
          },
        ),
      ],
    );
  }
}
