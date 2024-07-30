import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/page/print_page.dart';
import 'package:qr_code/service/ar_credit_memo_service.dart';
import 'package:qr_code/service/sales_return_service.dart';

class ArCreditmemoAddNewDetailItems extends StatefulWidget {
  final String docEntry;
  final String lineNum;
  final String batch;
  final String slThucTe;
  final String remake;
  final String itemCode;
  final String itemName;
  final String whse;
  final String uoMCode;
  const ArCreditmemoAddNewDetailItems(
      {super.key,
        this.docEntry = '',
        this.lineNum = '',
        this.batch = '',
        this.slThucTe = '',
        this.itemCode = '',
        this.itemName = '',
        this.whse = '',
        this.uoMCode = '',
        this.remake = ''});

  @override
  _ArCreditmemoAddNewDetailItemsState createState() => _ArCreditmemoAddNewDetailItemsState();
}

class _ArCreditmemoAddNewDetailItemsState extends State<ArCreditmemoAddNewDetailItems> {
  late TextEditingController batchController;
  late TextEditingController slThucTeController;
  late TextEditingController remakeController;
  late TextEditingController itemCodeController;
  late TextEditingController descriptionController;
  late TextEditingController whseController;
  late TextEditingController uoMCodeController;

  // final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    itemCodeController = TextEditingController(text: widget.itemCode);
    descriptionController = TextEditingController(text: widget.itemName);
    batchController = TextEditingController(text: widget.batch);
    whseController = TextEditingController(text: widget.whse);
    slThucTeController = TextEditingController(text: widget.slThucTe);
    uoMCodeController = TextEditingController(text: widget.uoMCode);
    remakeController = TextEditingController(text: widget.remake);
  }

  @override
  void dispose() {
    batchController.dispose();
    slThucTeController.dispose();
    remakeController.dispose();
    super.dispose();
  }

  Future<void> _submitData() async {
    final data = {
      'itemCode': itemCodeController.text,
      'itemName': descriptionController.text,
      'whse': whseController.text,
      'uoMCode': uoMCodeController.text,
      'docEntry': widget.docEntry,
      'lineNum': widget.lineNum,
      'batch': batchController.text,
      'slThucTe': slThucTeController.text,
      'remake': remakeController.text,
    };
    try {
      await postArCreditMemoItemsDetailData(
          data, context, widget.docEntry, widget.lineNum);
    } catch (e) {
      print('Error submitting data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderApp(title: "AR Credit Memo - Detail"),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: bgColor,
        padding: AppStyles.paddingContainer,
        child: ListView(
          children: [
            buildTextFieldRow(
              controller: itemCodeController,
              labelText: 'Item Code:',
              hintText: 'Item Code',
            ),
            buildTextFieldRow(
              controller: descriptionController,
              labelText: 'Item Name:',
              hintText: 'Item Name',
            ),
            buildTextFieldRow(
                controller: slThucTeController,
                labelText: 'Quantity:',
                hintText: 'Quantity',
                isEnable: true
            ),
            buildTextFieldRow(
              controller: whseController,
              labelText: 'Whse:',
              hintText: 'Whse',
            ),
            buildTextFieldRow(
              controller: uoMCodeController,
              labelText: 'UoM Code:',
              hintText: 'UoMCode',
            ),
            buildTextFieldRow(
                controller: batchController,
                labelText: 'Số Batch:',
                hintText: 'Batch'
            ),
            buildTextFieldRow(
                controller: remakeController,
                labelText: 'Số kiện:',
                hintText: 'Số kiện',
                isEnable: true
            ),
            Flexible(
              child: Container(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomButton(
                    text: 'OK',
                    onPressed: _submitData,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
