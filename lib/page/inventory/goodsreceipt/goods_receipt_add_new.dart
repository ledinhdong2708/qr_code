import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/date_input.dart';
import 'package:qr_code/component/dropdownbutton.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/qr_input.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/page/inventory/goodsreceipt/list_itemcode.dart';
import 'package:qr_code/routes/routes.dart';

class GoodsReceiptInvenAddNew extends StatefulWidget {
  const GoodsReceiptInvenAddNew({super.key});

  @override
  _GoodsReceiptInvenAddNewState createState() => _GoodsReceiptInvenAddNewState();

}

class _GoodsReceiptInvenAddNewState extends State<GoodsReceiptInvenAddNew> {
  final TextEditingController _itemCodeController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _remarkCodeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  void _handleItemSelected(String itemCode, String itemName) {
    setState(() {
      _itemCodeController.text = itemCode;
      _itemNameController.text = itemName;
    });
  }

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String docDate = formatter.format(now);
    final TextEditingController _controller = TextEditingController();
    return Scaffold(
        appBar: const HeaderApp(title: "Goods Receipt"),
        body: Container(
          color: bgColor,
          width: double.infinity,
          height: double.infinity,
          padding: AppStyles.paddingContainer,
          child: SingleChildScrollView(
            child: Column(
              children: [
                DateInput(
                  postDay: docDate,
                  controller: _dateController,
                ),
                buildTextFieldRow(
                  labelText: 'Item Code',
                  hintText: 'Item Code',
                  controller: _itemCodeController,
                  iconButton: IconButton(
                    icon: const Icon(Icons.more_horiz),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListItemcode(
                            onItemSelected: _handleItemSelected,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                buildTextFieldRow(
                  labelText: 'Item Name',
                  hintText: 'Item Name',
                  controller: _itemNameController,
                ),
                buildTextFieldRow(
                    labelText: 'Whse',
                    hintText: 'Whse',
                    isEnable: true
                ),
                buildTextFieldRow(
                    labelText: 'Quantity',
                    hintText: 'Quantity',
                    isEnable: true),
                buildTextFieldRow(
                    labelText: 'Batch',
                    hintText: 'Batch',
                    isEnable: true
                ),
                buildTextFieldRow(
                    labelText: 'UoM Code',
                    hintText: 'UoM Code'
                ),
                buildTextFieldRow(
                    labelText: 'Price',
                    hintText: 'Price',
                    isEnable: true
                ),
                buildTextFieldRow(
                    labelText: 'Total',
                    hintText: 'Total'
                ),
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
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
