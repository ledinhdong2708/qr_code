import 'package:flutter/material.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/date_input.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/routes/routes.dart';

class GoodsReturn extends StatelessWidget {
  const GoodsReturn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const HeaderApp(title: "Goods Return"),
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
                // **** nút vào xem good-return details trong list item bấm vào dấu ... dọc ****
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.goodsReturnDetail);
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
}
