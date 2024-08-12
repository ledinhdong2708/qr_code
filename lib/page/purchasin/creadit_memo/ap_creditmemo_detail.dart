import 'package:flutter/material.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/page/purchasin/creadit_memo/ap_creditmemo_detail_items.dart';

import '../../../component/dialog.dart';
import '../../../component/list_items.dart';
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
  final String slYeuCau;
  final String slThucTe;
  final String uoMCode;
  final String remake;
  final String baseEntry;
  final String baseLine;

  const ApCreditmemoDetail({
    super.key,
    this.docEntry = "",
    this.lineNum = "",
    this.itemCode = "",
    this.whse = "",
    this.slYeuCau = "",
    this.slThucTe = "",
    this.uoMCode = "",
    this.remake = "",
    this.description = "",
    this.batch = "",
    this.openQty = "",
    this.baseEntry = "",
    this.baseLine = "",
  });

  @override
  _ApCreditmemoDetailState createState() => _ApCreditmemoDetailState();
}

class _ApCreditmemoDetailState extends State<ApCreditmemoDetail> {
  List<dynamic> apcreditmemoItemsDetail = [];
  late TextEditingController itemCodeController;
  late TextEditingController descriptionController;
  late TextEditingController batchController;
  late TextEditingController slYeuCauController;
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
    slYeuCauController = TextEditingController(text: widget.slYeuCau);
    whseController = TextEditingController(text: widget.whse);
    slThucTeController = TextEditingController(text: '0');
    uoMCodeController = TextEditingController(text: widget.uoMCode);
    remakeController = TextEditingController(text: widget.remake);
    _fetchData();
  }

  Future<void> _fetchData() async {
    fetchApCreditMemoItemsDetailData(widget.baseEntry, widget.baseLine)
        .then((data) {
      if (data != null && data['data'] is List) {
        setState(() {
          apcreditmemoItemsDetail = data['data'];
          double totalSlThucTe = 0.0;
          if (apcreditmemoItemsDetail.isNotEmpty) {
            for (var item in apcreditmemoItemsDetail) {
              double slThucTe = 0.0;
              if (item['SlThucTe'] != null) {
                slThucTe += double.tryParse(item['SlThucTe'].toString()) ?? 0.0;
              }
              totalSlThucTe += slThucTe;
            }
            batchController.text = apcreditmemoItemsDetail[0]['Batch'];
            whseController.text = apcreditmemoItemsDetail[0]['Whse'];
            slThucTeController.text = totalSlThucTe.toString();
            uoMCodeController.text =
                apcreditmemoItemsDetail[0]['UoMCode'].toString();
            remakeController.text =
                apcreditmemoItemsDetail[0]['Remake'].toString();
          }
        });
      }
    });
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
    remakeController.dispose();
    super.dispose();
  }

  Future<void> _submitData() async {
    int successfulCount = 0;
    int totalItems = apcreditmemoItemsDetail.length;

    try {
      for (var item in apcreditmemoItemsDetail) {
        final data = {
          'docEntry': widget.docEntry,
          'lineNum': widget.lineNum,
          'itemCode': item['ItemCode'],
          'itemName': item['ItemName'],
          'batch': item['Batch'],
          'slYeuCau': widget.slYeuCau,
          'whse': item['Whse'],
          'slThucTe': item['SlThucTe'].toString(),
          'uoMCode': item['UoMCode'].toString(),
          'remake': item['Remake'].toString(),
        };

        await postApCreditMemoItemsData(data, context);
        successfulCount++;
      }

      // Check if all items were successfully submitted
      if (successfulCount == totalItems) {
        print('All data successfully sent to server');
        CustomDialog.showDialog(context, 'Cập nhật thành công!', 'success');
      }
    } catch (e) {
      print('Error submitting data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const HeaderApp(title: "AP Credit Memo - Details"),
        body: Container(
          color: bgColor,
          width: double.infinity,
          height: double.infinity,
          padding: AppStyles.paddingContainer,
          child: ListView(
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
                controller: slYeuCauController,
                labelText: 'Số lượng yêu cầu:',
                hintText: 'Số lượng yêu cầu',
              ),
              buildTextFieldRow(
                controller: slThucTeController,
                labelText: 'Số lượng thực tế:',
                hintText: 'Số lượng thực tế',
                iconButton: IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  onPressed: () {
                    //_navigateAndDisplaySelection(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QRViewExample(
                                  pageIdentifier: 'ApCreditMemoDetailItems',
                                  baseEntry: widget.baseEntry,
                                )));
                  },
                ),
              ),
              if (apcreditmemoItemsDetail.isNotEmpty)
                ListItems(
                  listItems: apcreditmemoItemsDetail,
                  enableDismiss: true,
                  onDeleteItem: (index) async {
                    String id = apcreditmemoItemsDetail[index]['ID'].toString();
                    await deleteApCreditMemoItemsDetailData(id, context);
                  },
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
                          slThucTe: apcreditmemoItemsDetail[index]['SlThucTe']
                              .toString(),
                          batch: apcreditmemoItemsDetail[index]['Batch']
                              .toString(),
                          uoMCode: apcreditmemoItemsDetail[index]['UoMCode']
                              .toString(),
                          remake: apcreditmemoItemsDetail[index]['Remake']
                              .toString(),
                        ),
                      ),
                    );
                  },
                  labelsAndChildren: const [
                    {'label': 'ItemCode', 'child': 'ItemCode'},
                    {'label': 'Name', 'child': 'ItemName'},
                    {'label': 'Whse', 'child': 'Whse'},
                    {'label': 'Quantity', 'child': 'SlThucTe'},
                    {'label': 'UoM Code', 'child': 'UoMCode'},
                    {'label': 'Batch', 'child': 'Batch'},
                  ],
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
