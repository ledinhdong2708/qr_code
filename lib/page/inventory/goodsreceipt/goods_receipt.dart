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
import 'package:qr_code/page/inventory/goodsreceipt/list_itemcode.dart';
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
  final TextEditingController _remarkCodeController = TextEditingController();
  //final TextEditingController _itemNameController = TextEditingController();
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

  // Future<void> _fetchData() async {
  //   fetchGoodsReceiptInvenItemsData().then((data) {
  //     if (data != null && data['data'] is List) {
  //       setState(() {
  //         goodsReceiptInvenItems = data['data'];
  //
  //         // if (srrItemsDetail.isNotEmpty) {
  //         //   itemCodeController.text = srrItemsDetail[0]['ItemCode'];
  //         //   descriptionController.text = srrItemsDetail[0]['ItemName'];
  //         //   batchController.text = srrItemsDetail[0]['Batch'];
  //         //   whseController.text = srrItemsDetail[0]['Whse'];
  //         //   slThucTeController.text = srrItemsDetail[0]['SlThucTe'].toString();
  //         //   uoMCodeController.text = srrItemsDetail[0]['UoMCode'].toString();
  //         //   remakeController.text = srrItemsDetail[0]['Remake'].toString();
  //         // }
  //       });
  //     }
  //   });
  // }
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
            child: ListView(
              children: [
                DateInput(
                  postDay: docDate,
                  controller: _dateController,
                ),
                buildTextFieldRow(
                  labelText: 'Remarks:',
                  hintText: 'Remarks',
                  isEnable: true,
                  controller: _remarkCodeController,
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
                            whse: goodsReceiptInvenItemsDetail[index]['Whse'],
                            quantity: goodsReceiptInvenItemsDetail[index]['Quantity'].toString(),
                            batch: goodsReceiptInvenItemsDetail[index]['Batch'].toString(),
                            uoMCode: goodsReceiptInvenItemsDetail[index]['UoMCode'].toString(),
                            remark: goodsReceiptInvenItemsDetail[index]['Remake'].toString(),
                          ),
                        ),
                      );
                    },
                    labelsAndChildren: const [
                      {'label': 'ItemCode', 'child': 'ItemCode'},
                      {'label': 'ItemName', 'child': 'ItemName'},
                      {'label': 'Quantity', 'child': 'Quantity'},
                      {'label': 'Batch', 'child': 'Batch'},


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
