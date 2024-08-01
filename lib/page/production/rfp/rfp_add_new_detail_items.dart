import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/page/print_page.dart';
import '../../../service/rfp_service.dart';

class RfpAddNewDetailItems extends StatefulWidget {
  final String docEntry;
  final String lineNum;
  final String batch;
  final String slThucTe;
  final String remake;
  final String itemCode;
  final String itemName;
  final String whse;
  final String uoMCode;
  const RfpAddNewDetailItems(
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
  _RfpAddNewDetailItemsState createState() => _RfpAddNewDetailItemsState();
}

class _RfpAddNewDetailItemsState extends State<RfpAddNewDetailItems> {
  late TextEditingController batchController;
  late TextEditingController slThucTeController;
  late TextEditingController remarksController;
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
    remarksController = TextEditingController(text: widget.remake);
  }

  @override
  void dispose() {
    batchController.dispose();
    slThucTeController.dispose();
    remarksController.dispose();
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
      'remake': remarksController.text,
    };
    try {
      await postRfpItemsDetailData(
          data, context, widget.docEntry);
    } catch (e) {
      print('Error submitting data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const HeaderApp(title: "RFP - Detail"),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
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
                  controller: slThucTeController,
                  labelText: 'Số lượng thực tế:',
                  hintText: 'Số lượng thực tế',
                  isEnable: true),
              buildTextFieldRow(
                  controller: batchController,
                  labelText: 'Batch:',
                  hintText: 'Batch',
                  ),
              buildTextFieldRow(
                  controller: remarksController,
                  labelText: 'Remarks:',
                  hintText: 'Remarks',
                  isEnable: true),
              const SizedBox(height: 20),
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
      ),
    );
  }
}
