import 'package:flutter/material.dart';
import 'package:qr_code/routes/routes.dart';

class UserDetailButton extends StatelessWidget {
  const UserDetailButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
        icon: const Icon(
          Icons.person,
          size: 40,
        ),
        onPressed: () {
          Navigator.pushNamed(context, Routes.userDetail);
        },
      ),
    );
  }
}
