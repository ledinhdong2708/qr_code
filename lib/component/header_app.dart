import 'package:flutter/material.dart';
import 'package:qr_code/constants/colors.dart';

class HeaderApp extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const HeaderApp({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      scrolledUnderElevation: 0.0,
      title: Text(
        title.toString(),
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
      backgroundColor: bgColor,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
