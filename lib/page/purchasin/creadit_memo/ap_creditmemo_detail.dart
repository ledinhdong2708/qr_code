import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/qr_input.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/page/purchasin/creadit_memo/ap_creditmemo_detail_items.dart';

import '../../../component/list_items.dart';
import '../../../routes/routes.dart';
import '../../../service/ap_credit_memo_service.dart';
import '../../qr_view_example.dart';


class ApCreditmemoDetail extends StatefulWidget {
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

  const ApCreditmemoDetail({
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
  _ApCreditmemoDetailState createState() => _ApCreditmemoDetailState();
}

class _ApCreditmemoDetailState extends State<ApCreditmemoDetail> {
  List<dynamic> apcreditmemoItemsDetail = [];
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
    batchController = TextEditingController(text: widget.batch);
    openQtyController = TextEditingController(text: widget.openQty);
    whseController = TextEditingController(text: widget.whse);
    slThucTeController = TextEditingController(text: widget.slThucTe);
    uoMCodeController = TextEditingController(text: widget.uoMCode);
    remakeController = TextEditingController(text: widget.remake);
    _fetchData();
  }

  Future<void> _fetchData() async {
    fetchApCreditMemoItemsDetailData(widget.docEntry, widget.lineNum).then((data) {
      if (data != null && data['data'] is List) {
        setState(() {
          apcreditmemoItemsDetail = data['data'];
        });
      }
    });
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

  // Future<void> _navigateAndDisplaySelection(BuildContext context) async {
  //   final result = await Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => GoodReturnDetailItems(
  //         qrData: jsonEncode({
  //           'data': [
  //             {
  //               'ItemCode': widget.itemCode,
  //               'ItemName': widget.description,
  //               'Whse': widget.whse,
  //               'SlThucTe': widget.slThucTe,
  //               'UoMCode': widget.uoMCode,
  //               'LineNum': widget.lineNum,
  //               'Batch': widget.batch,
  //               'Remake': widget.remake,
  //               'DocEntry': widget.docEntry,
  //             }
  //           ]
  //         }),
  //       ),
  //     ),
  //   );
  //   if (result != null && result is Map<String, dynamic>) {
  //     setState(() {
  //       grrItemsDetail.add(result);
  //     });
  //   }
  // }

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
      await postApCreditMemoItemsData(data, context);
    } catch (e) {
      print('Error submitting data: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const HeaderApp(title: "A/P Credit Memo - Detail"),
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
                      //_navigateAndDisplaySelection(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QRViewExample(
                              pageIdentifier: 'ApCreditMemoDetailItems',
                              docEntry: widget.docEntry,
                              lineNum: widget.lineNum,
                            )),
                      ).then((_) => _fetchData());
                    },
                  ),
                ),
                if (apcreditmemoItemsDetail.isNotEmpty)
                  ListItems(
                    listItems: apcreditmemoItemsDetail,
                    onTapItem: (index) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ApCreditmemoDetailItems(
                            isEditable: false,
                            id: apcreditmemoItemsDetail[index]['ID'].toString(),
                            itemCode: apcreditmemoItemsDetail[index]['ItemCode'],
                            itemName: apcreditmemoItemsDetail[index]['ItemName'],
                            whse: apcreditmemoItemsDetail[index]['Whse'],
                            slThucTe: apcreditmemoItemsDetail[index]['SlThucTe'].toString(),
                            batch: apcreditmemoItemsDetail[index]['Batch'].toString(),
                            uoMCode: apcreditmemoItemsDetail[index]['UoMCode'].toString(),
                            remake: apcreditmemoItemsDetail[index]['Remake'].toString(),
                          ),
                        ),
                      );
                    },
                    labelName1: 'ID',
                    labelName2: 'Batch',
                    labelName3: 'SlThucTe',
                    labelName4: 'Remake',
                    listChild1: 'ID',
                    listChild3: 'Batch',
                    listChild2: 'SlThucTe',
                    listChild4: 'Remake',
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
