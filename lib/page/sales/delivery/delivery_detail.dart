import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/qr_input.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/page/sales/delivery/delivery_detail_items.dart';

import '../../../component/dialog.dart';
import '../../../component/list_items.dart';
import '../../../routes/routes.dart';
import '../../../service/delivery_service.dart';
import '../../qr_view_example.dart';

class DeliveryDetail extends StatefulWidget {
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

  const DeliveryDetail({
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
  _DeliveryDetailState createState() => _DeliveryDetailState();
}

class _DeliveryDetailState extends State<DeliveryDetail> {
  List<dynamic> deliveryItemsDetail = [];
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
    slThucTeController = TextEditingController(text:'0');
    uoMCodeController = TextEditingController(text: widget.uoMCode);
    remakeController = TextEditingController(text: widget.remake);
    _fetchData();
  }

  Future<void> _fetchData() async {
    fetchDeliveryItemsDetailData(widget.docEntry, widget.lineNum).then((data) {
      if (data != null && data['data'] is List) {
        setState(() {
          deliveryItemsDetail = data['data'];

          double totalSlThucTe = 0.0;
          if (deliveryItemsDetail.isNotEmpty) {
            for (var item in deliveryItemsDetail) {
              double slThucTe = 0.0;
              if (item['SlThucTe'] != null) {
                slThucTe += double.tryParse(item['SlThucTe'].toString()) ?? 0.0;
              }
              totalSlThucTe += slThucTe;
            }
            //itemCodeController.text = deliveryItemsDetail[0]['ItemCode'];
            //descriptionController.text = deliveryItemsDetail[0]['ItemName'];
            batchController.text = deliveryItemsDetail[0]['Batch'];
            whseController.text = deliveryItemsDetail[0]['Whse'];
            slThucTeController.text = totalSlThucTe.toString();
            uoMCodeController.text = deliveryItemsDetail[0]['UoMCode'].toString();
            remakeController.text = deliveryItemsDetail[0]['Remake'].toString();
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
    int totalItems = deliveryItemsDetail.length;

    try {
      for (var item in deliveryItemsDetail) {
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

        await postDeliveryItemsData(data, context);
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
        appBar: const HeaderApp(title: "Delivery - Details"),
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
                  iconButton: IconButton(
                    icon: const Icon(Icons.qr_code_scanner),
                    onPressed: () {
                      //_navigateAndDisplaySelection(context);
                      Navigator.push(
                        context,
                        // MaterialPageRoute(
                        //     builder: (context) => QRViewExample(
                        //       pageIdentifier: 'DeliveryDetailItems',
                        //       docEntry: widget.docEntry,
                        //       lineNum: widget.lineNum,
                        //     )
                        // ),
                        MaterialPageRoute(
                            builder: (context) => const DeliveryDetailItems(
                              qrData: "ID: 10, DocEntry: 1, LineNum: 0",
                            )
                        ),
                      ).then((_) => _fetchData());
                    },
                  ),
                ),
                if (deliveryItemsDetail.isNotEmpty)
                  ListItems(
                    listItems: deliveryItemsDetail,
                    enableDismiss: true,
                    onDeleteItem: (index) async {
                      String id = deliveryItemsDetail[index]['ID'].toString();
                      await deleteDeliveryItemsDetailData(id, context);
                    },
                    onTapItem: (index) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DeliveryDetailItems(
                            isEditable: false,
                            id: deliveryItemsDetail[index]['ID'].toString(),
                            itemCode: deliveryItemsDetail[index]['ItemCode'],
                            itemName: deliveryItemsDetail[index]['ItemName'],
                            whse: deliveryItemsDetail[index]['Whse'],
                            slThucTe: deliveryItemsDetail[index]['SlThucTe'].toString(),
                            batch: deliveryItemsDetail[index]['Batch'].toString(),
                            uoMCode: deliveryItemsDetail[index]['UoMCode'].toString(),
                            remake: deliveryItemsDetail[index]['Remake'].toString(),
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
