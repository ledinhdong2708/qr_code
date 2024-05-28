import 'package:flutter/material.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/date_input.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/qr_input.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/routes/routes.dart';

class ReturnDetail extends StatelessWidget {
  const ReturnDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    return Scaffold(
        appBar: const HeaderApp(title: "Return - Detail"),
        body: Container(
          color: bgColor,
          width: double.infinity,
          height: double.infinity,
          padding: AppStyles.paddingContainer,
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildTextFieldRow(
                    labelText: 'Item Code', hintText: 'Item Code'),
                buildTextFieldRow(
                    labelText: 'Item Name', hintText: 'Item Name'),
                buildTextFieldRow(labelText: 'Whse', hintText: 'Whse'),
                buildTextFieldRow(
                    labelText: 'SL Yêu Cầu', hintText: 'SL Yêu Cầu'),
                QRCodeInput(
                  labelText: 'SL Hàng trả',
                  controller: _controller,
                ),
                buildTextFieldRow(labelText: 'Batch', hintText: 'Batch'),
                buildTextFieldRow(labelText: 'UoM Code', hintText: 'UoM Code'),
                // để list item vào đây
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.returnLabels);
                  },
                  child: const Text('Tạo Nhãn'),
                ),
                Container(
                  width: double.infinity,
                  margin: AppStyles.marginButton,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: CustomButton(
                      text: 'ADD',
                      onPressed: () {},
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
