import 'package:flutter/material.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/date_input.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/qr_input.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/page/sales/creditmemo/ar_creditmemo_add_new_detail_items.dart';
import 'package:qr_code/page/sales/creditmemo/ar_creditmemo_detail_items.dart';
import 'package:qr_code/page/sales/returns/sales_return_add_new_detail_items.dart';
import 'package:qr_code/page/sales/returns/sales_return_detail_items.dart';
import 'package:qr_code/routes/routes.dart';
import 'package:qr_code/service/ar_credit_memo_service.dart';

import '../../../component/dialog.dart';
import '../../../component/list_items.dart';
import '../../../service/sales_return_service.dart';
import '../../qr_view_example.dart';
// AR CREDIT MEMO DETAIL
class ArCreditmemoDetail extends StatefulWidget {
  final String docEntry;
  final String lineNum;
  final String itemCode;
  final String description;
  final String batch;
  final String slYeuCau;
  final String whse;
  final String slThucTe;
  final String uoMCode;
  final String remake;

  const ArCreditmemoDetail({
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
    this.slYeuCau = "",
  });
  @override
  _ArCreditmemoDetailState createState() => _ArCreditmemoDetailState();
}

class _ArCreditmemoDetailState extends State<ArCreditmemoDetail> {
  List<dynamic> arcreditmemoItemsDetail = [];
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
    openQtyController = TextEditingController(text: widget.slYeuCau);
    whseController = TextEditingController(text: widget.whse);
    slThucTeController = TextEditingController(text: widget.slThucTe);
    uoMCodeController = TextEditingController(text: widget.uoMCode);
    remakeController = TextEditingController(text: widget.remake);
    _fetchData();
  }

  Future<void> _fetchData() async {
    fetchArCreditMemoItemsDetailData(widget.docEntry, widget.lineNum).then((data) {
      if (data != null && data['data'] is List) {
        setState(() {
          arcreditmemoItemsDetail = data['data'];

          if (arcreditmemoItemsDetail.isNotEmpty) {
            itemCodeController.text = arcreditmemoItemsDetail[0]['ItemCode'];
            descriptionController.text = arcreditmemoItemsDetail[0]['ItemName'];
            batchController.text = arcreditmemoItemsDetail[0]['Batch'];
            whseController.text = arcreditmemoItemsDetail[0]['Whse'];
            slThucTeController.text = arcreditmemoItemsDetail[0]['SlThucTe'].toString();
            uoMCodeController.text = arcreditmemoItemsDetail[0]['UoMCode'].toString();
            remakeController.text = arcreditmemoItemsDetail[0]['Remake'].toString();
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
    openQtyController.dispose();
    whseController.dispose();
    slThucTeController.dispose();
    uoMCodeController.dispose();
    remakeController.dispose();
    super.dispose();
  }

  Future<void> _submitData() async {
    int successfulCount = 0;
    int totalItems = arcreditmemoItemsDetail.length;

    try {
      for (var item in arcreditmemoItemsDetail) {
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

        await postArCreditMemoItemsData(data, context);
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
        appBar: const HeaderApp(title: "A/R Credit Memo - Detail"),
        body: Container(
          color: bgColor,
          width: double.infinity,
          height: double.infinity,
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
                  controller: openQtyController,
                  labelText: 'SL Yêu Cầu',
                  hintText: 'SL Yêu Cầu',
                ),

                if (arcreditmemoItemsDetail.isNotEmpty)
                  ListItems(
                    listItems: arcreditmemoItemsDetail,
                    onTapItem: (index) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArCreditmemoDetailItems(
                            id: arcreditmemoItemsDetail[index]['ID'].toString(),
                            itemCode: arcreditmemoItemsDetail[index]['ItemCode'],
                            itemName: arcreditmemoItemsDetail[index]['ItemName'],
                            whse: arcreditmemoItemsDetail[index]['Whse'],
                            slThucTe: arcreditmemoItemsDetail[index]['SlThucTe'].toString(),
                            batch: arcreditmemoItemsDetail[index]['Batch'].toString(),
                            uoMCode: arcreditmemoItemsDetail[index]['UoMCode'].toString(),
                            remake: arcreditmemoItemsDetail[index]['Remake'].toString(),
                          ),
                        ),
                      );
                    },
                    labelsAndChildren: const [
                      {'label': 'ID', 'child': 'ID'},
                      {'label': 'Batch', 'child': 'Batch'},
                      {'label': 'SlThucTe', 'child': 'SlThucTe'},
                      {'label': 'Remake', 'child': 'Remake'},
                      // Add more as needed
                    ],
                    // labelName1: 'ID',
                    // labelName2: 'Batch',
                    // labelName3: 'SlThucTe',
                    // labelName4: 'Remake',
                    // listChild1: 'ID',
                    // listChild2: 'Batch',
                    // listChild3: 'SlThucTe',
                    // listChild4: 'Remake',
                  ),
                Container(
                  width: double.infinity,
                  margin: AppStyles.marginButton,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomButton(
                        text: 'New',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ArCreditmemoAddNewDetailItems(
                                docEntry: widget.docEntry,
                                lineNum: widget.lineNum,
                                itemCode: widget.itemCode,
                                itemName: widget.description,
                                whse: widget.whse,
                                uoMCode: widget.uoMCode,
                              ),
                            ),
                          ).then((_) => _fetchData());
                        },
                      ),
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
        ));
  }
}
