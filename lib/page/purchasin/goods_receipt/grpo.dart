import 'package:flutter/material.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/date_input.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/list_items.dart';
import 'package:qr_code/component/loading.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/page/purchasin/goods_receipt/grpo_detail.dart';
import 'package:qr_code/service/grpo_service.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:intl/intl.dart'; // Import intl for date formatting

class Grpo extends StatefulWidget {
  final String qrData;
  final String docEntry;
  const Grpo({super.key, required this.qrData, this.docEntry = ""});

  @override
  State<Grpo> createState() => _GrpoState();
}

class _GrpoState extends State<Grpo> {
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  Barcode? result;
  List<dynamic> grpo = [];
  Map<String, dynamic>? po;
  List<dynamic> lines = [];
  List<dynamic> batches = [];
  bool _isLoading = true;
  late TextEditingController vendorCodeController;
  late TextEditingController vendorNameController;
  late TextEditingController postDayController;
  late TextEditingController docNoController;
  late TextEditingController docEntryController;
  late TextEditingController baseEntryController;

  @override
  void initState() {
    super.initState();
    vendorCodeController = TextEditingController();
    vendorNameController = TextEditingController();
    postDayController = TextEditingController();
    docNoController = TextEditingController();
    docEntryController = TextEditingController();
    baseEntryController = TextEditingController();
    _fetchGrpoData();
    _fetchPoData();
  }

  Future<void> _fetchGrpoData() async {
    fetchGrpoData(widget.qrData).then((data) {
      if (data != null && data['data'] is List) {
        setState(() {
          grpo = data['data'];
          if (grpo.isNotEmpty) {
            vendorCodeController.text = grpo[0]['vendorcode'];
            vendorNameController.text = grpo[0]['vendorname'];
            postDayController.text = grpo[0]['postday'];
            docEntryController.text = grpo[0]['BaseEntry'];
          }
        });
      }
    });
  }

  @override
  void dispose() {
    vendorCodeController.dispose();
    vendorNameController.dispose();
    postDayController.dispose();
    docNoController.dispose();
    docEntryController.dispose();
    _commentController.dispose();
    _dateController.dispose();
    baseEntryController.dispose();
    super.dispose();
  }

  Future<void> _postPoToGrpo() async {
    try {
      if (po != null) {
        final grpoData = {
          'CardCode': po?['cardCode'],
          'CardName': po?['cardName'],
          'DocDate': _dateController.text,
          'Comments': _commentController.text,
          'Lines': []
        };

        if (lines.isNotEmpty) {
          for (var item in lines) {
            final lineData = {
              'ItemCode': item['itemCode'],
              'ItemDescription': item['itemDescription'],
              'Quantity': item['quantity'],
              'BaseEntry': po?['docEntry'] ?? 0,
              'BaseLine': item['lineNum'] ?? 0,
              'WarehouseCode': item['warehouseCode'] ?? '',
              'BaseType': 22,
              'Batches': []
            };

            final grpoItemsDetailForLine = await fetchGrpoItemsDetailData(
                widget.qrData, item["lineNum"].toString());

            if (grpoItemsDetailForLine != null &&
                grpoItemsDetailForLine['data'] is List) {
              for (var batch in grpoItemsDetailForLine['data']) {
                final batchData = {
                  'ItemCode': batch["ItemCode"],
                  'BatchNumber': batch["Batch"],
                  'Quantity': batch["SlThucTe"]
                };
                (lineData['Batches'] as List).add(batchData);
              }
            }

            (grpoData['Lines'] as List).add(lineData);
          }

          await postPoToGrpo(grpoData, context);
        } else {}
      } else {
        print('Dữ liệu đơn hàng (po) là null');
      }
    } catch (e) {
      print('Lỗi khi gửi dữ liệu: $e');
    }
  }

  Future<void> _fetchPoData() async {
    final data = await fetchPoData(widget.qrData, context);
    if (data != null) {
      setState(() {
        _isLoading = false;
        po = data;
        lines = po?["lines"] ?? [];
        if (po?['docDate'] != null) {
          _dateController.text =
              DateFormat('dd/MM/yyyy').format(DateTime.parse(po?['docDate']));
        }
      });
    } else {
      print("Sai");
    }
  }

  Future<void> _postGrpo() async {
    try {
      if (po != null) {
        final grpoData = {
          'DocEntry': po?['docEntry'].toString(),
          'DocNo': po?['docNum'].toString(),
          'VendorCode': po?['cardCode'],
          'VendorName': po?['cardName'],
          'PostDay': _dateController.text,
          'Remake': _commentController.text,
          'Lines': []
        };

        if (lines.isNotEmpty) {
          for (var item in lines) {
            final lineData = {
              'ItemCode': item['itemCode'],
              'ItemName': item['itemDescription'],
              // 'LineNum': item['lineNum'].toString(),
              'Quantity': item['quantity'].toString(),
              'BaseEntry': po?['docEntry'].toString() ?? 0,
              'BaseLine': item['lineNum'].toString() ?? 0,
              'WarehouseCode': item['warehouseCode'] ?? '',
              'BaseType': 22.toString(),
              'Batches': []
            };

            final grpoItemsDetailForLine = await fetchGrpoItemsDetailData(
                widget.qrData, item["lineNum"].toString());
            if (grpoItemsDetailForLine != null &&
                grpoItemsDetailForLine['data'] is List) {
              for (var batch in grpoItemsDetailForLine['data']) {
                final batchData = {
                  // 'ItemCode': batch["ItemCode"],
                  'BatchNumber': batch["Batch"],
                  'Quantity': batch["SlThucTe"]
                };
                (lineData['Batches'] as List).add(batchData);
              }
            }

            (grpoData['Lines'] as List).add(lineData);
          }

          await postGrpo(grpoData, context);
        } else {}
      } else {
        print('Dữ liệu đơn hàng (po) là null');
      }
    } catch (e) {
      print('Lỗi khi gửi dữ liệu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var docNum = po?['docNum']?.toString() ?? '';
    var cardCode = po?['cardCode'] ?? '';
    var cardName = po?['cardName'] ?? '';
    return Scaffold(
      appBar: const HeaderApp(title: "GRPO"),
      body: _isLoading
          ? const CustomLoading()
          : Container(
              width: double.infinity,
              color: bgColor,
              padding: AppStyles.paddingContainer,
              child: ListView(
                children: [
                  buildTextFieldRow(
                    labelText: 'Doc No:',
                    hintText: 'Doc No.',
                    valueQR: docNum,
                  ),
                  DateInput(
                    controller: _dateController,
                  ),
                  buildTextFieldRow(
                    labelText: 'Vendor:',
                    hintText: 'Vendor Code',
                    valueQR: cardCode,
                  ),
                  buildTextFieldRow(
                    labelText: 'Name:',
                    hintText: 'Vendor Name',
                    valueQR: cardName,
                  ),
                  buildTextFieldRow(
                    labelText: 'Remarks:',
                    isEnable: true,
                    hintText: 'Remarks here',
                    icon: Icons.edit,
                    controller: _commentController,
                  ),
                  if (lines.isNotEmpty)
                    ListItems(
                      listItems: lines,
                      onTapItem: (index) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GrpoDetail(
                              docEntry:
                                  lines[index]['docEntry']?.toString() ?? '',
                              lineNum:
                                  lines[index]['lineNum']?.toString() ?? '',
                              itemCode:
                                  lines[index]['itemCode']?.toString() ?? '',
                              description:
                                  lines[index]['itemDescription']?.toString() ??
                                      '',
                              whse: lines[index]['warehouseCode']?.toString() ??
                                  '',
                              slYeuCau:
                                  lines[index]['quantity']?.toString() ?? '',
                              slThucTe:
                                  lines[index]['SlThucTe']?.toString() ?? '',
                              batch: lines[index]['Batch']?.toString() ?? '',
                              uoMCode:
                                  lines[index]['uomCode']?.toString() ?? '',
                              remake: lines[index]['remake']?.toString() ?? '',
                            ),
                          ),
                        );
                      },
                      labelsAndChildren: const [
                        {'label': 'ItemCode', 'child': 'itemCode'},
                        {'label': 'Name', 'child': 'itemDescription'},
                        {'label': 'Whse', 'child': 'warehouseCode'},
                        {'label': 'Quantity', 'child': 'quantity'},
                        {'label': 'UoM Code', 'child': 'uomCode'},
                        // Add more as needed
                      ],
                    ),
                  Container(
                    width: double.infinity,
                    margin: AppStyles.marginButton,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomButton(
                          text: 'Add to Sap',
                          onPressed: _postPoToGrpo,
                        ),
                        CustomButton(
                          text: 'POST',
                          onPressed: _postGrpo,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
