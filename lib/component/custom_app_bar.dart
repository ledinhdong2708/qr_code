import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Center(
        child: Image.asset("assets/logofti.png", height: 100, width: 100),
      ),
      toolbarHeight: 100,
    );
  }
}
