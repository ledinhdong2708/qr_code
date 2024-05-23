import 'package:flutter/material.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double horizontal;
  final double vertical;
  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.horizontal = 12.0,
    this.vertical = 6.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: mainColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppStyles.borderRadiusButton),
          ),
          padding:
              EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical)),
      child: Text(
        text.toUpperCase(),
        style:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }
}
