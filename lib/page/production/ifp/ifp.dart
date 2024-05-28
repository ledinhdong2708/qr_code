import 'package:flutter/material.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/date_input.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';

class Ifp extends StatelessWidget {
  const Ifp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const HeaderApp(title: "Issue for Production"),
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
                    labelText: 'Item Code', hintText: 'Item Code'),
                buildTextFieldRow(
                    labelText: 'Item Name', hintText: 'Item Name'),
                buildTextFieldRow(labelText: 'Quantity', hintText: 'Quantity'),
                buildTextFieldRow(labelText: 'Batch', hintText: 'Batch'),
                buildTextFieldRow(labelText: 'UoM Code', hintText: 'UoM Code'),
                buildTextFieldRow(
                  labelText: 'Remake',
                  isEnable: true,
                  hintText: 'Remake here',
                  icon: Icons.edit,
                ),
                //list item ở đây
                Container(
                  width: double.infinity,
                  margin: AppStyles.marginButton,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomButton(
                        text: 'Delete',
                        onPressed: () {},
                      ),
                      CustomButton(
                        text: 'POST',
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
