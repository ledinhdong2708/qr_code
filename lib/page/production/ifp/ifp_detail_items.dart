import 'package:flutter/material.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/page/production/ifp/ifp_add_new_detail_items.dart';
import 'package:qr_code/service/ifp_service.dart';
import '../../../component/dialog.dart';
import '../../../component/list_items.dart';
import '../../qr_view_example.dart';


class IfpDetailItems extends StatefulWidget {
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

  const IfpDetailItems({
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
  });

  @override
  _IfpDetailItemsState createState() => _IfpDetailItemsState();
}

class _IfpDetailItemsState extends State<IfpDetailItems> {
  List<dynamic> ifpItemsDetail = [];
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
    slThucTeController = TextEditingController(text: widget.slThucTe);
    uoMCodeController = TextEditingController(text: widget.uoMCode);
    remakeController = TextEditingController(text: widget.remake);
    _fetchData();
  }

  Future<void> _fetchData() async {
    fetchIfpItemsDetailTempData(widget.docEntry, widget.lineNum).then((data) {
      if (data != null && data['data'] is List) {
        setState(() {
          ifpItemsDetail = data['data'];
          double totalSlThucTe = 0.0;

          if (ifpItemsDetail.isNotEmpty) {
            for (var item in ifpItemsDetail) {
              double slThucTe = 0.0;
              if (item['SlThucTe'] != null) {
                slThucTe += double.tryParse(item['SlThucTe'].toString()) ?? 0.0;
              }
              totalSlThucTe += slThucTe;
            }
            // itemCodeController.text = ifpItemsDetail[0]['ItemCode'];
            // descriptionController.text = ifpItemsDetail[0]['ItemName'];
            batchController.text = ifpItemsDetail[0]['Batch'];
            whseController.text = ifpItemsDetail[0]['Whse'];
            slThucTeController.text = totalSlThucTe.toString();
            uoMCodeController.text = ifpItemsDetail[0]['UoMCode'].toString();
            remakeController.text = ifpItemsDetail[0]['Remake'].toString();
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
    int totalItems = ifpItemsDetail.length;

    try {
      for (var item in ifpItemsDetail) {
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

        await postIfpItemsDetailData(data, context);
        successfulCount++;
      }

      // Check if all items were successfully submitted
      if (successfulCount == totalItems) {
        print('All data successfully sent to server');
        CustomDialog.showDialog(context, 'Cập nhật thành công!', 'success',
          onOkPressed: () {
            int count = 0;
            Navigator.of(context).popUntil((_) => count++ >= 1);
          },
        );
      }
    } catch (e) {
      print('Error submitting data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const HeaderApp(title: "Issue for Production - POs"),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => QRViewExample(
                            pageIdentifier: 'IfpAddNewDetailItems',
                            docEntry: widget.docEntry,
                            lineNum: widget.lineNum,
                          )),
                    ).then((_) => _fetchData());
                  },
                ),
              ),
              if (ifpItemsDetail.isNotEmpty)
                ListItems(
                  listItems: ifpItemsDetail,
                  enableDismiss: true,
                  onDeleteItem: (index) async {
                    String id = ifpItemsDetail[index]['ID'].toString();
                    await deleteIfpItemsDetailTempData(id, context);
                  },
                  onTapItem: (index) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IfpAddNewDetailItems(
                          isEditable: false,
                          id: ifpItemsDetail[index]['ID'].toString(),
                          // itemCode: ifpItemsDetail[index]['ItemCode'],
                          // itemName: ifpItemsDetail[index]['ItemName'],
                          itemCode: widget.itemCode,
                          itemName: widget.description,
                          whse: ifpItemsDetail[index]['Whse'],
                          slThucTe:
                          ifpItemsDetail[index]['SlThucTe'].toString(),
                          batch: ifpItemsDetail[index]['Batch'].toString(),
                          uoMCode:
                          ifpItemsDetail[index]['UoMCode'].toString(),
                          remake: ifpItemsDetail[index]['Remake'].toString(),
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
