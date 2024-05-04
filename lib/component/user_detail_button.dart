import 'package:flutter/material.dart';

class UserDetailButton extends StatelessWidget {
  const UserDetailButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
        icon: const Icon(Icons.person),
        onPressed: () {
          Navigator.pushNamed(context, "/home/user_detail");
        },
      ),
    );
  }
}
