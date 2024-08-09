import 'package:flutter/material.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/loading.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/service/goodreturn_service.dart';

import '../../../service/ap_credit_memo_service.dart';
import '../../../service/qr_service.dart';

class ApCreditmemoDetailItems extends StatefulWidget {
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
  const ApCreditmemoDetailItems({
    super.key,
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
  _ApCreditmemoDetailItemsState createState() =>
      _ApCreditmemoDetailItemsState();
}

class _ApCreditmemoDetailItemsState extends State<ApCreditmemoDetailItems> {
  Map<String, dynamic>? GRPO_QR;
  late TextEditingController idController;
  late TextEditingController batchController;
  late TextEditingController slThucTeController;
  late TextEditingController remakeController;
  late TextEditingController itemCodeController;
  late TextEditingController descriptionController;
  late TextEditingController whseController;
  late TextEditingController uoMCodeController;
  bool _isLoading = true;
  Map<String, dynamic>? grpoBatchesLine;
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
    // if (widget.qrData.isNotEmpty) {
    //   // If QR data is provided, fetch data
    //   final extractedValues = extractValuesFromQRData(widget.qrData);
    //   String id = extractedValues['id'] ?? '';
    //   String docEntry = extractedValues['docEntry'] ?? '';
    //   String lineNum = extractedValues['lineNum'] ?? '';
    //   if (docEntry == widget.docEntry && lineNum == widget.lineNum) {
    //     fetchQRApCreditMemoItemsDetailData(docEntry, lineNum, id).then((data) {
    //       if (data != null &&
    //           data.containsKey('data') &&
    //           data['data'] is List &&
    //           data['data'].isNotEmpty) {
    //         final itemData = data['data'][0];
    //         setState(() {
    //           GRPO_QR = itemData;
    //           itemCodeController.text = itemData['ItemCode']?.toString() ?? '';
    //           descriptionController.text =
    //               itemData['ItemName']?.toString() ?? '';
    //           batchController.text = itemData['Batch']?.toString() ?? '';
    //           whseController.text = itemData['Whse']?.toString() ?? '';
    //           slThucTeController.text = itemData['SlThucTe']?.toString() ?? '';
    //           uoMCodeController.text = itemData['UoMCode']?.toString() ?? '';
    //           remakeController.text = itemData['Remake']?.toString() ?? '';
    //           isLoading = false;
    //           isConfirmEnabled = true;
    //         });
    //       } else {
    //         setState(() {
    //           isLoading = false;
    //         });
    //       }
    //     });
    //   }
    // } else {
    //   setState(() {
    //     isLoading = false;
    //     idController = TextEditingController(text: widget.id);
    //     itemCodeController = TextEditingController(text: widget.itemCode);
    //     descriptionController = TextEditingController(text: widget.itemName);
    //     batchController = TextEditingController(text: widget.batch);
    //     whseController = TextEditingController(text: widget.whse);
    //     slThucTeController = TextEditingController(text: widget.slThucTe);
    //     uoMCodeController = TextEditingController(text: widget.uoMCode);
    //     remakeController = TextEditingController(text: widget.remake);
    //     isConfirmEnabled = false;
    //   });
    // }
    _fetchGrpoBatchesLineData();
  }

  Future<void> _fetchGrpoBatchesLineData() async {
    final data = await fetchGrpoBatchesLineData(widget.qrData, context);
    if (data != null) {
      setState(() {
        _isLoading = false;
        grpoBatchesLine = data;
      });
    } else {
      print("Lấy dữ liệu không thành công");
    }
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
      'itemCode': grpoBatchesLine?["itemCode"].toString(),
      'itemName': grpoBatchesLine?["itemDescription"].toString(),
      'whse': grpoBatchesLine?["warehouseCode"].toString(),
      'uoMCode': grpoBatchesLine?["uoMCode"].toString(),
      'docEntry': grpoBatchesLine?["docEntry"].toString(),
      'lineNum': grpoBatchesLine?["lineNum"].toString(),
      'batch': grpoBatchesLine?["batchNumber"].toString(),
      'slThucTe': grpoBatchesLine?["quantity"].toString(),
    };
    try {
      await postApCreditMemoItemsDetailData(
          data,
          context,
          grpoBatchesLine?["docEntry"]?.toString() ?? '',
          grpoBatchesLine?["lineNum"]?.toString() ?? '');
    } catch (e) {
      print('Error submitting data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderApp(title: "AP Credit Memo - Detail"),
      body: _isLoading
          ? const CustomLoading()
          : Container(
              width: double.infinity,
              height: double.infinity,
              color: bgColor,
              padding: AppStyles.paddingContainer,
              child: Column(
                children: [
                  buildTextFieldRow(
                      labelText: 'Item Code:',
                      hintText: 'Item Code',
                      valueQR: grpoBatchesLine?["itemCode"]),
                  buildTextFieldRow(
                      labelText: 'Item Name:',
                      hintText: 'Item Name',
                      valueQR: grpoBatchesLine?["itemDescription"]),
                  buildTextFieldRow(
                      labelText: 'Quantity:',
                      hintText: 'Quantity',
                      valueQR: grpoBatchesLine?["quantity"].toString()),
                  buildTextFieldRow(
                      labelText: 'Whse:',
                      hintText: 'Whse',
                      valueQR: grpoBatchesLine?["warehouseCode"]),
                  buildTextFieldRow(
                      labelText: 'UoM Code:',
                      hintText: 'UoMCode',
                      valueQR: grpoBatchesLine?["uoMCode"]),
                  buildTextFieldRow(
                      labelText: 'Số Batch:',
                      hintText: 'Batch',
                      valueQR: grpoBatchesLine?["batchNumber"]),
                  buildTextFieldRow(
                    controller: remakeController,
                    labelText: 'Số kiện:',
                    hintText: 'Số kiện',
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
                          // isEnabled: isConfirmEnabled,
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
