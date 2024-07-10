import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/qr_input.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';

import '../../../routes/routes.dart';
import '../../../service/goodreturn_service.dart';
import '../../qr_view_example.dart';
import 'goods_return_detail_item.dart';

class GoodsReturnDetail extends StatefulWidget {
  final String docEntry;
  final String lineNum;
  final String itemCode;
  final String description;
  final String batch;
  final String openQty;
  final String whse;
  final String slThucTe;
  final String uoMCode;
  final String remake;

  const GoodsReturnDetail({
    super.key,
    this.docEntry = "",
    this.lineNum = "",
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
  _GoodReturnDetailState createState() => _GoodReturnDetailState();
}

class _GoodReturnDetailState extends State<GoodsReturnDetail> {
  List<Map<String, dynamic>> listGoodReturnItemsDetail = [];
  late TextEditingController itemCodeController;
  late TextEditingController descriptionController;
  late TextEditingController batchController;
  late TextEditingController openQtyController;
  late TextEditingController whseController;
  late TextEditingController slThucTeController;
  late TextEditingController uoMCodeController;
  late TextEditingController remakeController;

  @override
  void initState() {
    super.initState();
    itemCodeController = TextEditingController(text: widget.itemCode);
    descriptionController = TextEditingController(text: widget.description);
    openQtyController = TextEditingController(text: widget.openQty);
    slThucTeController = TextEditingController(text: widget.slThucTe);
    batchController = TextEditingController(text: widget.batch);
    listGoodReturnItemsDetail = [];

    String qrData = jsonEncode({
      'data': [
        {
          'ItemCode': widget.itemCode,
          'ItemName': widget.description,
          'Whse': widget.whse,
          'SlThucTe': widget.slThucTe,
          'UoMCode': widget.uoMCode,
          'LineNum': widget.lineNum,
          'Batch': widget.batch,
          'Remake': widget.remake,
          'DocEntry': widget.docEntry,
        }
      ]
    });

    print(qrData);
  }


  @override
  void dispose() {
    itemCodeController.dispose();
    descriptionController.dispose();
    batchController.dispose();
    openQtyController.dispose();
    whseController.dispose();
    slThucTeController.dispose();
    uoMCodeController.dispose();
    remakeController.dispose();
    super.dispose();
  }

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GoodReturnDetailItems(
          qrData: jsonEncode({
            'data': [
              {
                'ItemCode': widget.itemCode,
                'ItemName': widget.description,
                'Whse': widget.whse,
                'SlThucTe': widget.slThucTe,
                'UoMCode': widget.uoMCode,
                'LineNum': widget.lineNum,
                'Batch': widget.batch,
                'Remake': widget.remake,
                'DocEntry': widget.docEntry,
              }
            ]
          }),
        ),
      ),
    );
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        listGoodReturnItemsDetail.add(result);
      });
    }
  }

  Future<void> _submitData() async {
    final data = {
      'docEntry': widget.docEntry,
      'lineNum': widget.lineNum,
      'itemCode': itemCodeController.text,
      'itemName': descriptionController.text,
      'batch': batchController.text,
      'slYeuCau': openQtyController.text,
      'whse': whseController.text,
      'slThucTe': slThucTeController.text,
      'uoMCode': uoMCodeController.text,
      'remake': remakeController.text,
    };

    try {
      await postData(data, context);
    } catch (e) {
      print('Error submitting data: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const HeaderApp(title: "Goods Return - Detail"),
        body: Container(
          color: bgColor,
          width: double.infinity,
          height: double.infinity,
          padding: AppStyles.paddingContainer,
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildTextFieldRow(
                  controller: itemCodeController,
                  labelText: 'Item Code',
                  hintText: 'Item Code',
                ),
                buildTextFieldRow(
                  controller: descriptionController,
                  labelText: 'Item Name',
                  hintText: 'Item Name',
                ),
                // buildTextFieldRow(
                //   controller: whseController,
                //   labelText: 'Whse',
                //   isEnable: true,
                //   hintText: 'Whse',
                //   icon: Icons.more_vert,
                // ),
                buildTextFieldRow(
                  controller: openQtyController,
                  labelText: 'SL Yêu Cầu',
                  hintText: 'SL Yêu Cầu',
                ),
                buildTextFieldRow(
                  controller: slThucTeController,
                  labelText: 'SL Thực Tế',
                  hintText: 'SL Thực Tế',
                  isEnable: true,
                  iconButton: IconButton(
                    icon: const Icon(Icons.qr_code_scanner),
                    onPressed: () {
                      _navigateAndDisplaySelection(context);
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => const QRViewExample(
                      //         pageIdentifier: 'GoodReturnDetailItems',
                      //
                      //       )),
                      // );
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => GoodReturnDetailItems(
                      //       qrData: jsonEncode({
                      //         'docEntry': widget.docEntry,
                      //         'lineNum': widget.lineNum,
                      //         'itemCode': widget.itemCode,
                      //         'itemName': widget.description,
                      //         'whse': widget.whse,
                      //         'uoMCode': widget.uoMCode,
                      //         'slThucTe': widget.slThucTe,
                      //         'batch': widget.batch,
                      //       }),
                      //     ),
                      //   ),
                      // );
                    },
                  ),
                ),
                // buildTextFieldRow(
                //   controller: batchController,
                //   labelText: 'Batch',
                //   hintText: 'Batch',
                //   isEnable: true,
                // ),
                // buildTextFieldRow(
                //   controller: uoMCodeController,
                //   labelText: 'UoM Code',
                //   hintText: 'UoM Code',
                // ),
                // buildTextFieldRow(
                //   controller: remakeController,
                //   labelText: 'Remake',
                //   isEnable: true,
                //   hintText: 'Remake here',
                //   icon: Icons.edit,
                // ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.grpoDetailItems);
                  },
                  child: const Text('Tạo Nhãn'),
                ),
                if (listGoodReturnItemsDetail.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: listGoodReturnItemsDetail.length,
                    itemBuilder: (context, index) {
                      var item = listGoodReturnItemsDetail[index];
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: readInput,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['itemCode'].toString()),
                            Text(item['itemName'].toString()),
                            Text(item['slThucTe'].toString()),
                            Text(item['batch'].toString()),
                            Text(item['remake'].toString()),
                          ],
                        ),
                      );
                    },
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
                        onPressed: _submitData,
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
