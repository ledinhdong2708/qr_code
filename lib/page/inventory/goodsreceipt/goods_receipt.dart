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
import 'package:qr_code/page/inventory/goodsreceipt/goods_receipt_add_new.dart';
import 'package:qr_code/page/inventory/goodsreceipt/list_itemcode.dart';
import 'package:qr_code/routes/routes.dart';

class GoodsReceiptInven extends StatefulWidget {
  const GoodsReceiptInven({super.key});

  @override
  _GoodsReceiptInvenState createState() => _GoodsReceiptInvenState();

}

class _GoodsReceiptInvenState extends State<GoodsReceiptInven> {
  final TextEditingController _remarkCodeController = TextEditingController();
  //final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

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
                  labelText: 'Remark',
                  hintText: 'Remark',
                  controller: _remarkCodeController,
                ),
                // buildTextFieldRow(
                //     labelText: 'Item Name',
                //     hintText: 'Item Name',
                //     controller: _itemNameController,
                // ),
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
                        text: 'NEW',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GoodsReceiptInvenAddNew(),
                            ),
                          );
                        },
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
