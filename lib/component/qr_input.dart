import 'package:flutter/material.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/page/qr_code_input.dart';
import 'package:qr_code/page/qr_view_example.dart';

class QRCodeInput extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;

  QRCodeInput({
    required this.controller,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 90,
          margin: const EdgeInsets.all(10),
          child: Text(labelText,
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Container(
            height: 45,
            margin: const EdgeInsets.all(10),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: labelText,
                border: InputBorder.none,
                hintStyle: const TextStyle(color: fieldInputText),
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
          onPressed: () async {
            final qrData = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QRCodeForInput()),
            );
            if (qrData != null) {
              controller.text = qrData;
            }
          },
        ),
      ],
    );
  }
}
