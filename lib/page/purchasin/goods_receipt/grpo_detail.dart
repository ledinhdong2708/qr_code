import 'package:flutter/material.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/date_input.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/qr_input.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/routes/routes.dart';

class GrpoDetail extends StatelessWidget {
  final String itemCode;
  final String description;
  final String batch;
  final String openQty;
  final String whse;
  final String slThucTe;
  final String uoMCode;
  final String remake;

  const GrpoDetail({
    super.key,
    this.itemCode = "",
    this.whse = "",
    this.slThucTe = "",
    this.uoMCode = "",
    this.remake = "",
    this.description = "",
    this.batch = "",
    this.openQty = "",
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    return Scaffold(
        appBar: const HeaderApp(title: "GRPO - Detail"),
        body: Container(
          color: bgColor,
          width: double.infinity,
          height: double.infinity,
          padding: AppStyles.paddingContainer,
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildTextFieldRow(
                  labelText: 'Item Code',
                  hintText: 'Item Code',
                  valueQR: itemCode,
                ),
                buildTextFieldRow(
                    labelText: 'Item Name',
                    hintText: 'Item Name',
                    valueQR: description),
                buildTextFieldRow(
                  labelText: 'Whse',
                  isEnable: true,
                  hintText: 'Whse',
                  valueQR: whse,
                  icon: Icons.more_vert,
                ),
                buildTextFieldRow(
                    labelText: 'SL Yêu Cầu',
                    hintText: 'SL Yêu Cầu',
                    valueQR: openQty),
                buildTextFieldRow(
                    labelText: 'SL Thực Tế',
                    hintText: 'SL Thực Tế',
                    valueQR: slThucTe,
                    isEnable: true,
                    icon: null),
                buildTextFieldRow(
                    labelText: 'Batch', hintText: 'Batch', valueQR: batch),
                buildTextFieldRow(
                    labelText: 'UoM Code',
                    hintText: 'UoM Code',
                    valueQR: uoMCode),
                buildTextFieldRow(
                  labelText: 'Remake',
                  isEnable: true,
                  hintText: 'Remake here',
                  valueQR: remake,
                  icon: Icons.edit,
                ),
                // list item ở đây
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.grpoLabels);
                  },
                  child: const Text('Tạo Nhãn'),
                ),
                Container(
                  width: double.infinity,
                  margin: AppStyles.marginButton,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomButton(
                        text: 'New',
                        onPressed: () {},
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      CustomButton(
                        text: 'ADD',
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
