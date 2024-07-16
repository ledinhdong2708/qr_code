
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/service/grpo_service.dart';

import '../../../service/goodreturn_service.dart';


class GoodReturnDetailItems extends StatefulWidget {
  final String qrData;
  final String docEntry;
  final String lineNum;
  final String batch;
  final String slThucTe;
  final String remake;
  final String itemCode;
  final String itemName;
  final String whse;
  final String uoMCode;
  const GoodReturnDetailItems(
      {super.key,
        required this.qrData,
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
  _GoodReturnDetailItemsState createState() => _GoodReturnDetailItemsState();
}

class _GoodReturnDetailItemsState extends State<GoodReturnDetailItems> {
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
    print("data ${widget.qrData}");
    // itemCodeController = TextEditingController(text: widget.itemCode);
    // descriptionController = TextEditingController(text: widget.itemName);
    // batchController = TextEditingController(text: widget.batch);
    // whseController = TextEditingController(text: widget.whse);
    // slThucTeController = TextEditingController(text: widget.slThucTe);
    // uoMCodeController = TextEditingController(text: widget.uoMCode);
    // remakeController = TextEditingController(text: widget.remake);
    final Map<String, dynamic> qrDataMap = jsonDecode(widget.qrData);
    itemCodeController = TextEditingController(text: qrDataMap['ItemCode']);
    descriptionController = TextEditingController(text: qrDataMap['ItemName']);
    batchController = TextEditingController(text: qrDataMap['Batch']);
    whseController = TextEditingController(text: qrDataMap['Whse']);
    slThucTeController = TextEditingController(text: qrDataMap['SlThucTe']);
    uoMCodeController = TextEditingController(text: qrDataMap['UoMCode']);
    remakeController = TextEditingController(text: qrDataMap['Remake']);
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
      await postGrrItemsDetailData(
          data, context, widget.docEntry, widget.lineNum);
    } catch (e) {
      print('Error submitting data: $e');
    }
  }

  // Future<void> _submitData() async {
  //   // final data = {
  //   //   'itemCode': itemCodeController.text,
  //   //   'itemName': descriptionController.text,
  //   //   'whse': whseController.text,
  //   //   'uoMCode': uoMCodeController.text,
  //   //   'docEntry': widget.docEntry,
  //   //   'lineNum': widget.lineNum,
  //   //   'batch': batchController.text,
  //   //   'slThucTe': slThucTeController.text,
  //   //   'remake': remakeController.text,
  //   // };
  //   //
  //   // try {
  //   //   await postGrpoItemsDetailData(
  //   //       data, context, widget.docEntry, widget.lineNum);
  //   // } catch (e) {
  //   //   print('Error submitting data: $e');
  //   // }
  //
  //
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderApp(title: "Good Return - Detail - Items"),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: bgColor,
        padding: AppStyles.paddingContainer,
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
            buildTextFieldRow(
              controller: whseController,
              labelText: 'Whse',
              hintText: 'Whse',
            ),
            buildTextFieldRow(
              controller: uoMCodeController,
              labelText: 'UoMCode',
              hintText: 'UoMCode',
            ),
            buildTextFieldRow(
                controller: slThucTeController,
                labelText: 'Sl Thực tế',
                hintText: 'Sl Thực tế',
                isEnable: true),
            buildTextFieldRow(
                controller: batchController,
                labelText: 'Batch',
                hintText: 'Batch',
                isEnable: true),
            buildTextFieldRow(
                controller: remakeController,
                labelText: 'Remake',
                hintText: 'Remake',
                isEnable: true),
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
                    // onPressed: _submitData,
                    onPressed: _submitData,
                  ),
                  CustomButton(
                    text: 'CANCEL',
                    onPressed: () {},
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
