import 'package:flutter/material.dart';
import 'package:qr_code/component/date_input.dart';
import 'package:qr_code/component/textfield_method.dart';

class TestQrCode extends StatelessWidget {
  const TestQrCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("GRPO"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              buildTextFieldRow(labelText: 'Doc No.', hintText: 'Doc No.'),
              buildTextFieldRow(labelText: 'Post.Day', hintText: 'Post.Day'),
              const DateInput(),
              buildTextFieldRow(
                  labelText: 'Vendor Code', hintText: 'Vendor Code'),
              buildTextFieldRow(
                  labelText: 'Vendor Name', hintText: 'Vendor Name'),
              buildTextFieldRow(
                  labelText: 'Remake', isEnable: true, hintText: 'Remake here'),
            ],
          ),
        ));
  }
}
