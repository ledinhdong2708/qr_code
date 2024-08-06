import 'package:flutter/material.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/page/inventory/goodsissue/goods_issue.dart';
import 'package:qr_code/service/goods_issue_inven_service.dart';
import '../../../service/qr_service.dart';

class GoodsIssueDetailItem extends StatefulWidget {
  final String qrData;
  late String docEntry;
  late String lineNum;
  final String id;
  final String itemCode;
  final String itemName;
  final String batch;
  final String whse;
  final String quantity;
  final String uoMCode;
  final String accountCode;
  final String sokien;
  final bool isEditable;

  GoodsIssueDetailItem({
    super.key,
    this.qrData = "",
    this.docEntry = "",
    this.lineNum = "",
    this.id = '',
    this.itemCode = "",
    this.itemName = "",
    this.quantity = "",
    this.whse = "",
    this.uoMCode = "",
    this.batch = "",
    this.accountCode = "",
    this.sokien = "",
    this.isEditable = true,
  });

  @override
  _GoodsIssueDetailItemState createState() => _GoodsIssueDetailItemState();
}

class _GoodsIssueDetailItemState extends State<GoodsIssueDetailItem> {
  Map<String, dynamic>? GRPO_QR;
  late String id;
  late String docEntry;
  late String lineNum;
  late TextEditingController idController;
  late TextEditingController itemCodeController;
  late TextEditingController itemNameController;
  late TextEditingController quantityController;
  late TextEditingController whseController;
  late TextEditingController uoMCodeController;
  late TextEditingController batchController;
  late TextEditingController accountCodeController;
  late TextEditingController sokienController;
  bool isLoading = true;
  bool isConfirmEnabled = false;

  @override
  void initState() {
    super.initState();
    itemCodeController = TextEditingController(text: widget.itemCode);
    itemNameController = TextEditingController(text: widget.itemName);
    quantityController = TextEditingController(text: widget.quantity);
    whseController = TextEditingController(text: widget.whse);
    uoMCodeController = TextEditingController(text: widget.uoMCode);
    batchController = TextEditingController(text: widget.batch);
    accountCodeController = TextEditingController(text: widget.accountCode);
    sokienController = TextEditingController(text: widget.sokien);

    if (widget.qrData.isNotEmpty) {
      // If QR data is provided, fetch data
      final extractedValues  = extractValuesFromQRData(widget.qrData);
      id = extractedValues['id'] ?? '';
      docEntry = extractedValues['docEntry'] ?? '';
      lineNum = extractedValues['lineNum'] ?? '';
      fetchQRGoodsIssueItemsDetailData(docEntry, lineNum, id).then((data) {
        if (data != null && data.containsKey('data') && data['data'] is List && data['data'].isNotEmpty) {
          final itemData = data['data'][0];
          setState(() {
            GRPO_QR = itemData;
            itemCodeController.text = itemData['ItemCode']?.toString() ?? '';
            itemNameController.text = itemData['ItemName']?.toString() ?? '';
            batchController.text = itemData['Batch']?.toString() ?? '';
            whseController.text = itemData['Whse']?.toString() ?? '';
            quantityController.text = itemData['SlThucTe']?.toString() ?? '';
            uoMCodeController.text = itemData['UoMCode']?.toString() ?? '';
            accountCodeController.text = itemData['AccountCode']?.toString() ?? '';
            sokienController.text = itemData['Sokien']?.toString() ?? '';
            isLoading = false;
            isConfirmEnabled = true;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      });
    }
    else {
      setState(() {
        isLoading = false;
        idController = TextEditingController(text: widget.id);
        itemCodeController = TextEditingController(text: widget.itemCode);
        itemNameController = TextEditingController(text: widget.itemName);
        batchController = TextEditingController(text: widget.batch);
        whseController = TextEditingController(text: widget.whse);
        quantityController = TextEditingController(text: widget.quantity);
        uoMCodeController = TextEditingController(text: widget.uoMCode);
        accountCodeController = TextEditingController(text: widget.accountCode);
        sokienController = TextEditingController(text: widget.sokien);
        isConfirmEnabled = false;
      });
    }
  }

  @override
  void dispose() {
    itemCodeController.dispose();
    itemNameController.dispose();
    batchController.dispose();
    quantityController.dispose();
    whseController.dispose();
    quantityController.dispose();
    uoMCodeController.dispose();
    accountCodeController.dispose();
    sokienController.dispose();
    super.dispose();
  }


  Future<void> _submitData() async {
    final data = {
      'docEntry': docEntry,
      'lineNum': lineNum,
      'itemCode': itemCodeController.text,
      'itemName': itemNameController.text,
      'quantity': quantityController.text,
      'whse': whseController.text,
      'uoMCode': uoMCodeController.text,
      'batch': batchController.text,
      'accountCode': accountCodeController.text,
      'sokien': sokienController.text,
    };

    try {
      await postGoodsIssueInvenItemsDetailData(
          data, context, docEntry, lineNum);
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => GoodsIssueInven(
      //       docEntry: docEntry,
      //       lineNum: lineNum,
      //     ),
      //   ),
      // );
    } catch (e) {
      print('Error submitting data: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const HeaderApp(title: "Goods Issue - Detail"),
        body: Container(
          color: bgColor,
          width: double.infinity,
          height: double.infinity,
          padding: AppStyles.paddingContainer,
          child: ListView(
            children: [
              buildTextFieldRow(
                controller: itemCodeController,
                labelText: 'Item Code:',
                hintText: 'Item Code',
                isEnable: widget.isEditable
              ),
              buildTextFieldRow(
                controller: itemNameController,
                labelText: 'Item Name:',
                hintText: 'Item Name',
                isEnable: widget.isEditable
              ),
              buildTextFieldRow(
                  controller: quantityController,
                  labelText: 'Quantity:',
                  hintText: 'Quantity',
                  isEnable: widget.isEditable
              ),
              buildTextFieldRow(
                controller: whseController,
                labelText: 'Whse:',
                hintText: 'Whse',
                isEnable: widget.isEditable
              ),
              buildTextFieldRow(
                controller: uoMCodeController,
                labelText: 'UoM Code:',
                hintText: 'UoMCode',
                isEnable: widget.isEditable
              ),
              buildTextFieldRow(
                controller: batchController,
                labelText: 'Số Batch:',
                hintText: 'Số Batch',
                isEnable: widget.isEditable
              ),
              buildTextFieldRow(
                controller: accountCodeController,
                labelText: 'Account Code:',
                hintText: 'Account Code',
                isEnable: widget.isEditable,
              ),
              buildTextFieldRow(
                controller: sokienController,
                labelText: 'Số kiện:',
                hintText: 'Số kiện',
                isEnable: widget.isEditable,
              ),
              Container(
                width: double.infinity,
                margin: AppStyles.marginButton,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    CustomButton(
                      text: 'OK',
                      isEnabled: isConfirmEnabled,
                      onPressed: _submitData,
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
