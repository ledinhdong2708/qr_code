import 'package:flutter/material.dart';
import 'package:qr_code/constants/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: AppBar(
        backgroundColor: bgColor,
        flexibleSpace: Center(
          child: Image.asset(
            "assets/logofti.png",
            height: 200,
            width: 200,
          ),
        ),
        toolbarHeight: 100,
      ),
    );
  }
}
