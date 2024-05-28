import 'package:flutter/material.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/date_input.dart';
import 'package:qr_code/component/dropdownbutton.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/qr_input.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';

class GoodsIssue extends StatelessWidget {
  const GoodsIssue({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    return Scaffold(
        appBar: const HeaderApp(title: "Goods Issue"),
        body: Container(
          color: bgColor,
          width: double.infinity,
          height: double.infinity,
          padding: AppStyles.paddingContainer,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const DateInput(),
                QRCodeInput(
                  labelText: 'Item Code',
                  controller: _controller,
                ),
                buildTextFieldRow(
                    labelText: 'Item Name', hintText: 'Item Name'),
                buildTextFieldRow(labelText: 'Whse', hintText: 'Whse'),
                buildTextFieldRow(labelText: 'Quantity', hintText: 'Quantity'),
                buildTextFieldRow(labelText: 'Batch', hintText: 'Batch'),
                buildTextFieldRow(labelText: 'UoM Code', hintText: 'UoM Code'),
                buildTextFieldRow(
                  labelText: 'Remake',
                  isEnable: true,
                  hintText: 'Remake here',
                  icon: Icons.edit,
                ),
                Dropdownbutton(
                  items: ['nhà máy a', 'nhà máy b', 'nhà máy c'],
                  labelText: 'Nhà Máy',
                  hintText: 'Nhà Máy',
                ),
                Dropdownbutton(
                  items: ['Loại hinh a', 'Loại hinh b', 'Loại hinh c'],
                  labelText: 'Loại hình',
                  hintText: 'Loại hình',
                ),
                Dropdownbutton(
                  items: ['Công đoạn a', 'Công đoạn b', 'Công đoạn c'],
                  labelText: 'Công đoạn',
                  hintText: 'Công đoạn',
                ),
                Dropdownbutton(
                  items: ['Loại chi phí a', 'Loại chi phí b', 'Loại chi phí c'],
                  labelText: 'Loại chi phí',
                  hintText: 'Loại chi phí',
                ),
                Dropdownbutton(
                  items: ['Chi tiết NVL a', 'Chi tiết NVL b', 'Chi tiết NVL c'],
                  labelText: 'Chi tiết NVL',
                  hintText: 'Chi tiết NVL',
                ),
                Dropdownbutton(
                  items: ['Tài khoản a', 'Tài khoản b', 'Tài khoản c'],
                  labelText: 'Tài khoản',
                  hintText: 'Tài khoản',
                ),
                Container(
                  width: double.infinity,
                  margin: AppStyles.marginButton,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomButton(
                        text: 'POST',
                        onPressed: () {},
                      ),
                      CustomButton(
                        text: 'Delete',
                        onPressed: () {},
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
