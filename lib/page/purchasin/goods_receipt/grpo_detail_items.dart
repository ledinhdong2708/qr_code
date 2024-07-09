import 'package:flutter/material.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';

class GrpoDetailItems extends StatelessWidget {
  const GrpoDetailItems({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    return Scaffold(
        appBar: const HeaderApp(title: "GRPO - Detail - Items"),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: bgColor,
          padding: AppStyles.paddingContainer,
          child: Column(
            children: [
              buildTextFieldRow(
                  labelText: 'Sl Thực tế',
                  hintText: 'Sl Thực tế',
                  isEnable: true),
              buildTextFieldRow(
                  labelText: 'Batch', hintText: 'Batch', isEnable: true),
              buildTextFieldRow(
                  labelText: 'Remake', hintText: 'Remake', isEnable: true),
              // buildTextFieldRow(
              //   labelText: 'SL in',
              //   isEnable: true,
              //   hintText: 'SL in',
              //   icon: Icons.edit,
              // ),
              // buildTextFieldRow(
              //   labelText: 'Labels',
              //   isEnable: true,
              //   hintText: 'Labels',
              //   icon: Icons.more_vert,
              // ),
              // buildTextFieldRow(
              //   labelText: 'Printer',
              //   isEnable: true,
              //   hintText: 'Printer',
              //   icon: Icons.more_vert,
              // ),
              Flexible(
                child: Container(),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomButton(
                      text: 'PRINT',
                      onPressed: () {},
                    ),
                    CustomButton(
                      text: 'CANCEL',
                      onPressed: () {},
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}