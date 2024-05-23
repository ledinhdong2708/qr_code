import 'package:flutter/material.dart';
import 'package:qr_code/constants/colors.dart';

Row buildTextFieldRow({
  String labelText = 'Default Text',
  bool isEnable = false,
  String hintText = 'Default Hint Text',
  final IconData? icon,
}) {
  Color? fillColor = isEnable ? fieldInput : readInput;
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: 90,
        margin: const EdgeInsets.all(10),
        child: Text(
          labelText,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      Expanded(
        child: Container(
          height: 45,
          margin: const EdgeInsets.all(10),
          child: TextField(
              enabled: isEnable,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: isEnable
                    ? const TextStyle(color: fieldInputText)
                    : const TextStyle(color: readInputText),
                fillColor: fillColor,
                filled: true,
                suffixIcon: isEnable ? Icon(icon) : null,
              )),
        ),
      ),
    ],
  );
}
