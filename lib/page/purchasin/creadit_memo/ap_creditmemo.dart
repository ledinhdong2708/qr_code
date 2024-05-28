import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/date_input.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/routes/routes.dart';

class ApCreditMemo extends StatelessWidget {
  final String qrData;
  const ApCreditMemo({super.key, required this.qrData});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> qrDataMap = parseQrData(qrData);
    return Scaffold(
        appBar: const HeaderApp(title: "A/P Credit Memo"),
        body: Container(
          color: bgColor,
          width: double.infinity,
          height: double.infinity,
          padding: AppStyles.paddingContainer,
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildTextFieldRow(labelText: 'Doc No.', hintText: 'Doc No.'),
                const DateInput(),
                buildTextFieldRow(
                    labelText: 'Vendor Code', hintText: 'Vendor Code'),
                buildTextFieldRow(
                    labelText: 'Vendor Name', hintText: 'Vendor Name'),
                buildTextFieldRow(
                  labelText: 'Remake',
                  isEnable: true,
                  hintText: 'Remake here',
                  icon: Icons.edit,
                ),
                // list item ở đây
                // **** nút vào xem good-return details trong list item bấm vào dấu ... dọc ****
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.apCreditMemoDetail);
                  },
                  child: const Text('Xem Chi Tiết '),
                ),
                Container(
                  width: double.infinity,
                  margin: AppStyles.marginButton,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: CustomButton(
                      text: 'POST',
                      onPressed: () {},
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Map<String, dynamic> parseQrData(String qrData) {
    try {
      return jsonDecode(qrData);
    } catch (e) {
      // Xử lý lỗi nếu qrData không phải là chuỗi JSON hợp lệ
      print('Lỗi khi phân tích cú pháp qrData: $e');
      return {};
    }
  }
}
