import 'package:flutter/material.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/custom_app_bar.dart';
import 'package:qr_code/component/dropdownbutton.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';

class UserDetail extends StatelessWidget {
  const UserDetail({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderApp(title: 'User Detail'),
      body: Container(
        color: bgColor,
        width: double.infinity,
        height: double.infinity,
        padding: AppStyles.paddingContainer,
        child: SingleChildScrollView(
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
                  labelText: 'Họ',
                  isEnable: true,
                  hintText: 'Họ',
                  icon: Icons.edit),
              buildTextFieldRow(
                labelText: 'Tên',
                isEnable: true,
                hintText: 'Tên',
                icon: Icons.edit,
              ),
              buildTextFieldRow(
                labelText: 'Điện Thoại',
                isEnable: true,
                hintText: 'Điện Thoại',
                icon: Icons.edit,
              ),
              buildTextFieldRow(
                labelText: 'Chức Vụ',
                isEnable: true,
                hintText: 'Chức Vụ',
                icon: Icons.edit,
              ),
              buildTextFieldRow(
                labelText: 'Địa Chỉ',
                isEnable: true,
                hintText: 'Địa Chỉ',
                icon: Icons.edit,
              ),
              buildTextFieldRow(
                labelText: 'Gmail',
                isEnable: true,
                hintText: 'Gmail',
                icon: Icons.edit,
              ),
              Dropdownbutton(
                items: ['Kho', 'Sản Xuất', 'Nhập Hàng', 'Xuất Hàng'],
                hintText: 'Phòng Ban',
                labelText: 'Phòng Ban',
              ),
              Container(
                margin: AppStyles.marginButton,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomButton(
                      text: 'Update',
                      onPressed: () {},
                    ),
                    CustomButton(
                      text: 'logout',
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
