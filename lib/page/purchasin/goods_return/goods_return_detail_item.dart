
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
  final String id;
  final String docEntry;
  final String lineNum;
  final String batch;
  final String slThucTe;
  final String remake;
  final String itemCode;
  final String itemName;
  final String whse;
  final String uoMCode;
  final bool isEditable;
  const GoodReturnDetailItems(
      {super.key,
        this.qrData = '',
        this.id = '',
        this.docEntry = '',
        this.lineNum = '',
        this.batch = '',
        this.slThucTe = '',
        this.itemCode = '',
        this.itemName = '',
        this.whse = '',
        this.uoMCode = '',
        this.remake = '',
        this.isEditable = true,
      });

  @override
  _GoodReturnDetailItemsState createState() => _GoodReturnDetailItemsState();
}

class _GoodReturnDetailItemsState extends State<GoodReturnDetailItems> {
  Map<String, dynamic>? GRPO_QR;
  late TextEditingController idController;
  late TextEditingController batchController;
  late TextEditingController slThucTeController;
  late TextEditingController remakeController;
  late TextEditingController itemCodeController;
  late TextEditingController descriptionController;
  late TextEditingController whseController;
  late TextEditingController uoMCodeController;
  bool isLoading = true;
  bool isConfirmEnabled = false;

  @override
  void initState() {
    super.initState();
    batchController = TextEditingController();
    slThucTeController = TextEditingController();
    remakeController = TextEditingController();
    itemCodeController = TextEditingController();
    descriptionController = TextEditingController();
    whseController = TextEditingController();
    uoMCodeController = TextEditingController();
    //print("data ${widget.qrData}");
    if (widget.qrData.isNotEmpty) {
      // If QR data is provided, fetch data
      String id = extractIdFromQRData(widget.qrData);
      fetchQRGrrItemsDetailData(widget.docEntry, widget.lineNum, id).then((data) {
        if (data != null && data.containsKey('data') && data['data'] is List && data['data'].isNotEmpty) {
          final itemData = data['data'][0];
          setState(() {
            GRPO_QR = itemData;
            itemCodeController.text = itemData['ItemCode']?.toString() ?? '';
            descriptionController.text = itemData['ItemName']?.toString() ?? '';
            batchController.text = itemData['Batch']?.toString() ?? '';
            whseController.text = itemData['Whse']?.toString() ?? '';
            slThucTeController.text = itemData['SlThucTe']?.toString() ?? '';
            uoMCodeController.text = itemData['UoMCode']?.toString() ?? '';
            remakeController.text = itemData['Remake']?.toString() ?? '';
            isLoading = false;
            isConfirmEnabled = true;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      });
    } else {
      setState(() {
        isLoading = false;
        isConfirmEnabled = false;
      });
    }
  }

  String extractIdFromQRData(String qrData) {
    final prefix = "Item Code: ";
    if (qrData.startsWith(prefix)) {
      return qrData.substring(prefix.length);
    }
    return "";
  }

  @override
  void dispose() {
    batchController.dispose();
    slThucTeController.dispose();
    remakeController.dispose();
    itemCodeController.dispose();
    descriptionController.dispose();
    whseController.dispose();
    uoMCodeController.dispose();
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
            ),
            buildTextFieldRow(
              controller: batchController,
              labelText: 'Batch',
              hintText: 'Batch',
            ),
            buildTextFieldRow(
              controller: remakeController,
              labelText: 'Remake',
              hintText: 'Remake',
              isEnable: widget.isEditable,
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
                    text: 'Confirm',
                    isEnabled: isConfirmEnabled,
                    // onPressed: _submitData,
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
