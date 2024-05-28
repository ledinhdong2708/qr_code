import 'package:flutter/material.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/date_input.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/qr_input.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';

class InventoryTransferLabels extends StatelessWidget {
  const InventoryTransferLabels({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    return Scaffold(
        appBar: const HeaderApp(title: "Inv Transfer - Label"),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: bgColor,
          padding: AppStyles.paddingContainer,
          child: Column(
            children: [
              buildTextFieldRow(labelText: 'Item Code', hintText: 'Item Code'),
              buildTextFieldRow(labelText: 'Item Name', hintText: 'Item Name'),
              buildTextFieldRow(
                labelText: 'SL in',
                isEnable: true,
                hintText: 'SL in',
                icon: Icons.edit,
              ),
              buildTextFieldRow(
                labelText: 'Labels',
                isEnable: true,
                hintText: 'Labels',
                icon: Icons.more_vert,
              ),
              buildTextFieldRow(
                labelText: 'Printer',
                isEnable: true,
                hintText: 'Printer',
                icon: Icons.more_vert,
              ),
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
