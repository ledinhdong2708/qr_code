import 'package:flutter/material.dart';
import 'package:qr_code/component/textfield_method.dart';

class UserDetail extends StatelessWidget {
  const UserDetail({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // title: const Text("User Detail"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
              onTap: () {},
              child: const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                    'https://example.com/image.jpg'), // Replace with your image
              ),
            ),
            buildTextFieldRow(labelText: 'User ID', hintText: 'user_id'),
            buildTextFieldRow(
                labelText: 'First Name',
                isEnable: true,
                hintText: 'First name'),
            buildTextFieldRow(
                labelText: 'Last Name', isEnable: true, hintText: 'Last name'),
            buildTextFieldRow(
                labelText: 'Phone', isEnable: true, hintText: 'Phone'),
            buildTextFieldRow(
                labelText: 'Position', isEnable: true, hintText: 'Position'),
            buildTextFieldRow(
                labelText: 'Address', isEnable: true, hintText: 'Address'),
            buildTextFieldRow(
                labelText: 'Email', isEnable: true, hintText: 'Email'),
            buildTextFieldRow(
                labelText: 'Department',
                isEnable: true,
                hintText: 'Department'),
          ],
        ),
      ),
    );
  }
}
