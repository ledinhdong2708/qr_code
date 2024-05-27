import 'package:flutter/material.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/date_input.dart';
import 'package:qr_code/component/dropdownbutton.dart';
import 'package:qr_code/component/qr_input.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/routes/routes.dart';

class InventoryTrans extends StatelessWidget {
  const InventoryTrans({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Inventory Transfer"),
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
                QRCodeInput(controller: _controller, labelText: 'Item Code'),
                const DateInput(),
                buildTextFieldRow(
                    labelText: 'Batch', hintText: 'Batch', isEnable: true),
                buildTextFieldRow(
                    labelText: 'Quantity',
                    hintText: 'Quantity',
                    isEnable: true),
                Dropdownbutton(
                  items: ['UoM a', 'UoM b', 'UoM c'],
                  labelText: 'UoM Code',
                  hintText: 'UoM Code',
                ),
                buildTextFieldRow(labelText: 'UoM Name', hintText: 'UoM Name'),
                buildTextFieldRow(
                    labelText: 'From Warehouse',
                    hintText: 'From Warehouse',
                    isEnable: true),
                buildTextFieldRow(
                  labelText: 'Remake',
                  isEnable: true,
                  hintText: 'Remake here',
                  icon: Icons.edit,
                ),
                // list item ở đây
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, Routes.inventoryTransferLabels);
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
