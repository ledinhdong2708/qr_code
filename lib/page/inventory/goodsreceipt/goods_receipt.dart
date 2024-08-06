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
import 'package:qr_code/page/inventory/goodsreceipt/goods_receipt_print.dart';
import 'package:qr_code/component/list_itemcode.dart';
import 'package:qr_code/routes/routes.dart';

import '../../../component/list_items.dart';
import '../../../service/goods_receipt_inven_service.dart';

class GoodsReceiptInven extends StatefulWidget {
  const GoodsReceiptInven({super.key});

  @override
  _GoodsReceiptInvenState createState() => _GoodsReceiptInvenState();

}

class _GoodsReceiptInvenState extends State<GoodsReceiptInven> {
  List<dynamic> goodsReceiptInvenItemsDetail = [];
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _fetchData();
  }
  Future<void> _fetchData() async {
    fetchGoodsReceiptInvenItemsDetailData().then((data) {
      if (data != null && data['data'] is List) {
        setState(() {
          goodsReceiptInvenItemsDetail = data['data'];
        });
      }
    });
  }

  String _generateBatchCode() {
    final now = DateTime.now();
    final dateFormat = DateFormat('ddMMyyyy');
    final dateStr = dateFormat.format(now);

    int maxIndex = 1;
    int index = goodsReceiptInvenItemsDetail.length;
    if (goodsReceiptInvenItemsDetail.isNotEmpty) {
      maxIndex = index + 1;
    }
    return '${dateStr}_${maxIndex}';
  }

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formatter = DateFormat('dd/MM/yyyy');
    String docDate = formatter.format(now);
    return Scaffold(
        appBar: const HeaderApp(title: "Good Receipt"),
        body: Container(
          color: bgColor,
          width: double.infinity,
          height: double.infinity,
          padding: AppStyles.paddingContainer,
            child: ListView(
              children: [
                DateInput(
                  postDay: docDate,
                  controller: _dateController,
                ),
                buildTextFieldRow(
                  labelText: 'Lý do nhập kho:',
                  hintText: 'Lý do nhập kho',
                  isEnable: true,
                  controller: _reasonController,
                ),
                buildTextFieldRow(
                  labelText: 'Remarks:',
                  hintText: 'Remarks',
                  isEnable: true,
                  controller: _remarksController,
                ),
                if (goodsReceiptInvenItemsDetail.isNotEmpty)
                  ListItems(
                    listItems: goodsReceiptInvenItemsDetail,
                    onTapItem: (index) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GoodsReceiptInvenPrint(
                            id: goodsReceiptInvenItemsDetail[index]['ID'].toString(),
                            itemCode: goodsReceiptInvenItemsDetail[index]['ItemCode'],
                            itemName: goodsReceiptInvenItemsDetail[index]['ItemName'],
                            quantity: goodsReceiptInvenItemsDetail[index]['Quantity'].toString(),
                            whse: goodsReceiptInvenItemsDetail[index]['Whse'],
                            uoMCode: goodsReceiptInvenItemsDetail[index]['UoMCode'].toString(),
                            batch: goodsReceiptInvenItemsDetail[index]['Batch'].toString(),
                            accountCode: goodsReceiptInvenItemsDetail[index]['AccountCode'].toString(),
                            sokien: goodsReceiptInvenItemsDetail[index]['Sokien'].toString(),
                          ),
                        ),
                      );
                    },
                    labelsAndChildren: const [
                      {'label': 'ItemCode', 'child': 'ItemCode'},
                      {'label': 'ItemName', 'child': 'ItemName'},
                      {'label': 'Quantity', 'child': 'Quantity'},
                      {'label': 'Whse', 'child': 'Whse'},


                      // Add more as needed
                    ],
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
                        text: 'NEW',
                        onPressed: () {
                          final batchCode = _generateBatchCode();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GoodsReceiptInvenAddNew(batch: batchCode),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
        ));
  }
}
