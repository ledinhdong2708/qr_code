import 'package:flutter/material.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/date_input.dart';
import 'package:qr_code/component/dropdownbutton.dart';
import 'package:qr_code/component/qr_input.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/routes/routes.dart';

class InventoryCounting extends StatelessWidget {
  const InventoryCounting({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Inventory Counting"),
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
                buildTextFieldRow(
                  labelText: 'Doc.Num',
                  hintText: 'Doc.Num',
                ),
                const DateInput(
                  labelText: 'Count Date',
                ),
                Dropdownbutton(
                  items: ['Counter a', 'Counter b', 'Counter c'],
                  labelText: 'Inv.Counter',
                  hintText: 'Inv.Counter',
                ),
                QRCodeInput(controller: _controller, labelText: 'Item Code'),
                buildTextFieldRow(
                    labelText: 'Item Name', hintText: 'Item Name'),
                buildTextFieldRow(labelText: 'UoM', hintText: 'UoM'),
                buildTextFieldRow(
                    labelText: 'Warehouse', hintText: 'Warehouse'),
                buildTextFieldRow(labelText: 'SL tồn', hintText: 'SL tồn'),
                buildTextFieldRow(
                    labelText: 'SL thực tế', hintText: 'SL thực tế'),
                buildTextFieldRow(
                    labelText: 'SL chênh lệch', hintText: 'SL chênh lệch'),
                buildTextFieldRow(
                    labelText: 'Batch', hintText: 'Batch', isEnable: true),
                buildTextFieldRow(
                  labelText: 'Remake',
                  isEnable: true,
                  hintText: 'Remake here',
                  icon: Icons.edit,
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
