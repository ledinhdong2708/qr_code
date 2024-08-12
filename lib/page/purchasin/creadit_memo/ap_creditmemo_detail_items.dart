import 'package:flutter/material.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/loading.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/service/goodreturn_service.dart';

import '../../../service/ap_credit_memo_service.dart';

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
    _fetchGrpoBatchesLineData();
  }

  Future<void> _fetchGrpoBatchesLineData() async {
    final data = await fetchGrpoBatchesLineData(widget.qrData, context);
    if (data != null) {
      setState(() {
        _isLoading = false;
        grpoBatchesLine = data;
        itemCodeController.text = grpoBatchesLine!["itemCode"].toString();
        descriptionController.text = grpoBatchesLine!["itemDescription"].toString();
        slThucTeController.text = grpoBatchesLine!["quantity"].toString();
        whseController.text = grpoBatchesLine!["warehouseCode"].toString();
        uoMCodeController.text = grpoBatchesLine!["uoMCode"].toString();
        batchController.text = grpoBatchesLine!["batchNumber"].toString();
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
                    controller: itemCodeController,
                    labelText: 'Item Code:',
                    hintText: 'Item Code',
                      //valueQR: grpoBatchesLine?["itemCode"]
                  ),
                  buildTextFieldRow(
                    controller: descriptionController,
                    labelText: 'Item Name:',
                    hintText: 'Item Name',
                    //valueQR: grpoBatchesLine?["itemDescription"]
                  ),
                  buildTextFieldRow(
                    controller: slThucTeController,
                    labelText: 'Quantity:',
                    hintText: 'Quantity',
                      //valueQR: grpoBatchesLine?["quantity"].toString()
                  ),
                  buildTextFieldRow(
                    controller: whseController,
                    labelText: 'Whse:',
                    hintText: 'Whse',
                    //valueQR: grpoBatchesLine?["warehouseCode"]
                  ),
                  buildTextFieldRow(
                    controller: uoMCodeController,
                    labelText: 'UoM Code:',
                    hintText: 'UoMCode',
                    //valueQR: grpoBatchesLine?["uoMCode"]
                  ),
                  buildTextFieldRow(
                    controller: batchController,
                    labelText: 'Số Batch:',
                    hintText: 'Batch',
                    //valueQR: grpoBatchesLine?["batchNumber"]
                  ),
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
