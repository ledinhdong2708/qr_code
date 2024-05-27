import 'package:flutter/material.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/date_input.dart';
import 'package:qr_code/component/dropdownbutton.dart';
import 'package:qr_code/component/qr_input.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/routes/routes.dart';

class GoodsReceiptIven extends StatelessWidget {
  const GoodsReceiptIven({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Goods Receipt"),
          backgroundColor: bgColor,
        ),
        body: Container(
          color: bgColor,
          width: double.infinity,
          height: double.infinity,
          padding: AppStyles.paddingContainer,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const DateInput(),
                buildTextFieldRow(
                  labelText: 'Item Code',
                  hintText: 'Item Code',
                  isEnable: true,
                ),
                buildTextFieldRow(
                    labelText: 'Item Name', hintText: 'Item Name'),
                buildTextFieldRow(
                    labelText: 'Whse', hintText: 'Whse', isEnable: true),
                buildTextFieldRow(
                    labelText: 'Quantity',
                    hintText: 'Quantity',
                    isEnable: true),
                buildTextFieldRow(
                    labelText: 'Batch', hintText: 'Batch', isEnable: true),
                buildTextFieldRow(labelText: 'UoM Code', hintText: 'UoM Code'),
                buildTextFieldRow(
                    labelText: 'Price', hintText: 'Price', isEnable: true),
                buildTextFieldRow(labelText: 'Total', hintText: 'Total'),
                Dropdownbutton(
                  items: ['Lý do a', 'Lý do b', 'Lý do c'],
                  labelText: 'Lý do nhập kho',
                  hintText: 'Lý do nhập kho',
                ),
                buildTextFieldRow(
                  labelText: 'Remake',
                  isEnable: true,
                  hintText: 'Remake here',
                  icon: Icons.edit,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, Routes.goodsReceiptLabelsInven);
                  },
                  child: const Text('Tạo Nhãn'),
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
                        text: 'New',
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
