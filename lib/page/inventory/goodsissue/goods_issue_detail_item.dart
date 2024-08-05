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
  final String description;
  final String batch;
  final String openQty;
  final String whse;
  final String slYeuCau;
  final String slThucTe;
  final String uoMCode;
  final String remarks;
  final bool isEditable;

  GoodsIssueDetailItem({
    super.key,
    this.qrData = "",
    this.docEntry = "",
    this.lineNum = "",
    this.id = '',
    this.itemCode = "",
    this.whse = "",
    this.slYeuCau = "",
    this.slThucTe = "",
    this.uoMCode = "",
    this.remarks = "",
    this.description = "",
    this.batch = "",
    this.openQty = "",
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
  late TextEditingController descriptionController;
  late TextEditingController batchController;
  late TextEditingController slYeuCauController;
  late TextEditingController whseController;
  late TextEditingController slThucTeController;
  late TextEditingController uoMCodeController;
  late TextEditingController remarksController;
  bool isLoading = true;
  bool isConfirmEnabled = false;

  @override
  void initState() {
    super.initState();
    itemCodeController = TextEditingController(text: widget.itemCode);
    descriptionController = TextEditingController(text: widget.description);
    batchController = TextEditingController(text: widget.batch);
    slYeuCauController = TextEditingController(text: widget.slYeuCau);
    whseController = TextEditingController(text: widget.whse);
    slThucTeController = TextEditingController(text: widget.slThucTe);
    uoMCodeController = TextEditingController(text: widget.uoMCode);
    remarksController = TextEditingController(text: widget.remarks);
    //_fetchData();

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
            descriptionController.text = itemData['ItemName']?.toString() ?? '';
            batchController.text = itemData['Batch']?.toString() ?? '';
            whseController.text = itemData['Whse']?.toString() ?? '';
            slThucTeController.text = itemData['SlThucTe']?.toString() ?? '';
            uoMCodeController.text = itemData['UoMCode']?.toString() ?? '';
            remarksController.text = itemData['Remake']?.toString() ?? '';
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
        descriptionController = TextEditingController(text: widget.description);
        batchController = TextEditingController(text: widget.batch);
        whseController = TextEditingController(text: widget.whse);
        slThucTeController = TextEditingController(text: widget.slThucTe);
        uoMCodeController = TextEditingController(text: widget.uoMCode);
        remarksController = TextEditingController(text: widget.remarks);
        isConfirmEnabled = false;
      });
    }
  }

  Future<void> _fetchData() async {
    // fetchGrrItemsDetailData(widget.docEntry, widget.lineNum).then((data) {
    //   if (data != null && data['data'] is List) {
    //     setState(() {
    //       grrItemsDetail = data['data'];
    //
    //       if (grrItemsDetail.isNotEmpty) {
    //         itemCodeController.text = grrItemsDetail[0]['ItemCode'];
    //         descriptionController.text = grrItemsDetail[0]['ItemName'];
    //         batchController.text = grrItemsDetail[0]['Batch'];
    //         whseController.text = grrItemsDetail[0]['Whse'];
    //         slThucTeController.text = grrItemsDetail[0]['SlThucTe'].toString();
    //         uoMCodeController.text = grrItemsDetail[0]['UoMCode'].toString();
    //         remakeController.text = grrItemsDetail[0]['Remake'].toString();
    //       }
    //     });
    //   }
    // });
  }


  @override
  void dispose() {
    itemCodeController.dispose();
    descriptionController.dispose();
    batchController.dispose();
    slYeuCauController.dispose();
    whseController.dispose();
    slThucTeController.dispose();
    uoMCodeController.dispose();
    remarksController.dispose();
    super.dispose();
  }


  Future<void> _submitData() async {
    final data = {
      'itemCode': itemCodeController.text,
      'itemName': descriptionController.text,
      'whse': whseController.text,
      'uoMCode': uoMCodeController.text,
      'docEntry': docEntry,
      'lineNum': lineNum,
      'batch': batchController.text,
      'slThucTe': slThucTeController.text,
      'remake': remarksController.text,
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
                controller: descriptionController,
                labelText: 'Item Name:',
                hintText: 'Item Name',
                isEnable: widget.isEditable
              ),
              buildTextFieldRow(
                  controller: slThucTeController,
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
                // controller: remarksController,
                labelText: 'Account Code:',
                hintText: 'Account Code',
                isEnable: widget.isEditable,
              ),
              buildTextFieldRow(
                controller: remarksController,
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
