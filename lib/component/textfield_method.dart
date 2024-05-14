import 'package:flutter/material.dart';

Row buildTextFieldRow({
  String labelText = 'Default Text',
  bool isEnable = false,
  String hintText = 'Default Hint Text',
}) {
  Color? fillColor =
      isEnable ? const Color(0xFFF0F8FF) : const Color(0xFFE6E6E6);
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: 90,
        margin: const EdgeInsets.all(10),
        child: Text(labelText),
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
                    ? const TextStyle(color: Color(0xFF333333))
                    : const TextStyle(color: Color(0xFF999999)),
                fillColor: fillColor,
                filled: true,
                suffixIcon: isEnable ? const Icon(Icons.edit) : null,
              )),
        ),
      ),
    ],
  );
}
