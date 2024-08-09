import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/date_input.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/qr_input.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/page/sales/returns/sales_return_add_new_detail_items.dart';
import 'package:qr_code/page/sales/returns/sales_return_detail_items.dart';
import 'package:qr_code/routes/routes.dart';

import '../../../component/dialog.dart';
import '../../../component/list_items.dart';
import '../../../service/sales_return_service.dart';
import '../../qr_view_example.dart';
// SALES RETURN DETAIL
class SalesReturnDetail extends StatefulWidget {
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

  const SalesReturnDetail({
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
  _SalesReturnDetailState createState() => _SalesReturnDetailState();
}

class _SalesReturnDetailState extends State<SalesReturnDetail> {
  List<dynamic> srrItemsDetail = [];
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
    fetchSrrItemsDetailData(widget.docEntry, widget.lineNum).then((data) {
      if (data != null && data['data'] is List) {
        setState(() {
          srrItemsDetail = data['data'];

          if (srrItemsDetail.isNotEmpty) {
            itemCodeController.text = srrItemsDetail[0]['ItemCode'];
            descriptionController.text = srrItemsDetail[0]['ItemName'];
            batchController.text = srrItemsDetail[0]['Batch'];
            whseController.text = srrItemsDetail[0]['Whse'];
            slThucTeController.text = srrItemsDetail[0]['SlThucTe'].toString();
            uoMCodeController.text = srrItemsDetail[0]['UoMCode'].toString();
            remakeController.text = srrItemsDetail[0]['Remake'].toString();
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
    int totalItems = srrItemsDetail.length;

    try {
      for (var item in srrItemsDetail) {
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

        await postSrrItemsData(data, context);
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

  String _generateBatchCode() {
    final now = DateTime.now();
    final dateFormat = DateFormat('ddMMyyyy');
    final dateStr = dateFormat.format(now);

    int maxIndex = 1;
    int index = srrItemsDetail.length;
    if (srrItemsDetail.isNotEmpty) {
      maxIndex = index + 1;
    }
    return '${dateStr}_${maxIndex}';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const HeaderApp(title: "Return - Details"),
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
                ),
                buildTextFieldRow(
                  controller: descriptionController,
                  labelText: 'Item Name:',
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
                ),

                if (srrItemsDetail.isNotEmpty)
                  ListItems(
                    listItems: srrItemsDetail,
                    enableDismiss: true,
                    onDeleteItem: (index) async {
                      String id = srrItemsDetail[index]['ID'].toString();
                      await deleteSrrItemsDetailData(id, context);
                    },
                    onTapItem: (index) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SalesReturnDetailItems(
                            id: srrItemsDetail[index]['ID'].toString(),
                            itemCode: srrItemsDetail[index]['ItemCode'],
                            itemName: srrItemsDetail[index]['ItemName'],
                            whse: srrItemsDetail[index]['Whse'],
                            slThucTe: srrItemsDetail[index]['SlThucTe'].toString(),
                            batch: srrItemsDetail[index]['Batch'].toString(),
                            uoMCode: srrItemsDetail[index]['UoMCode'].toString(),
                            remake: srrItemsDetail[index]['Remake'].toString(),
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
                      CustomButton(
                        text: 'New',
                        onPressed: () {
                          final batchCode = _generateBatchCode();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SalesReturnAddNewDetailItems(
                                  docEntry: widget.docEntry,
                                  lineNum: widget.lineNum,
                                  itemCode: widget.itemCode,
                                  itemName: widget.description,
                                  whse: widget.whse,
                                  uoMCode: widget.uoMCode,
                                  batch: batchCode,
                                ),
                            ),
                          ).then((_) => _fetchData());
                        },
                      ),
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
