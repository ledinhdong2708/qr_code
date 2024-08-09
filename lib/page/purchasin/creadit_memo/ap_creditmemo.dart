import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/date_input.dart';
import 'package:qr_code/component/dialog.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/loading.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/page/purchasin/creadit_memo/ap_creditmemo_detail.dart';
import 'package:qr_code/service/goodreturn_service.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../../component/list_items.dart';
import '../../../service/ap_credit_memo_service.dart';

class ApCreditMemo extends StatefulWidget {
  final String qrData;
  const ApCreditMemo({super.key, required this.qrData});

  @override
  State<ApCreditMemo> createState() => _ApCreditMemoState();
}

class _ApCreditMemoState extends State<ApCreditMemo> {
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  Barcode? result;
  Map<String, dynamic>? apCreditMemo;
  Map<String, dynamic>? apInvoice;
  Map<String, dynamic>? grr;
  List<dynamic> lines = [];
  List<dynamic> linesApInvoice = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _fetchGrrData();
  }

  Future<void> _fetchGrrData() async {
    final data = await fetchGrrData(widget.qrData, context);
    if (data != null) {
      setState(() {
        _isLoading = false;
        grr = data;
        lines = grr?["lines"] ?? [];
        if (grr?['docDate'] != null) {
          _dateController.text =
              DateFormat('yyyy-MM-dd').format(DateTime.parse(grr?['docDate']));
        }
      });
      await _fetchApInvoiceData();
    } else {
      print("Sai");
    }
  }

  Future<void> _fetchApInvoiceData() async {
    final data = await fetchApInvoiceData(
        lines.map((item) => item["baseEntry"]).join(", "), context);
    if (data != null) {
      setState(() {
        apInvoice = data;
        linesApInvoice = apInvoice?["lines"] ?? "";
        print(linesApInvoice);
      });
    } else {
      print("Không có dữ liệu của ApInvoice trong SAP");
    }
  }

  Future<void> _postGoodReturnRequestToApCreditMemo() async {
    try {
      if (grr != null) {
        final apCreditMemoData = {
          'CardCode': grr?['cardCode'],
          'CardName': grr?['cardName'],
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
              'BaseEntry': grr?['docEntry'] ?? 0,
              'BaseLine': item['lineNum'] ?? 0,
              'WarehouseCode': item['warehouseCode'] ?? '',
              'BaseType': 234000032,
              'Batches': []
            };
            final apCreditMemoItemsDetailForLine =
                await fetchApCreditMemoItemsDetailData(
                    linesApInvoice.map((item) => item["baseEntry"]).join(", "),
                    linesApInvoice.map((item) => item["baseLine"]).join(", "));

            if (apCreditMemoItemsDetailForLine != null &&
                apCreditMemoItemsDetailForLine['data'] is List) {
              for (var batch in apCreditMemoItemsDetailForLine['data']) {
                final batchData = {
                  'ItemCode': batch["ItemCode"],
                  'BatchNumber': batch["Batch"],
                  'Quantity': batch["SlThucTe"]
                };
                (lineData['Batches'] as List).add(batchData);
              }
            }

            (apCreditMemoData['Lines'] as List).add(lineData);
          }
          if (apInvoice != null) {
            await postGoodReturnRequestToApCreditMemo(
                apCreditMemoData, context);
            print("Dữ liệu gửi đi: $apCreditMemoData");
          } else {
            CustomDialog.showDialog(
                context, 'Không có ApInvoice trong SAP', 'error');
          }
        } else {}
      } else {
        print('Dữ liệu đơn hàng (grr) là null');
      }
    } catch (e) {
      print('Lỗi khi gửi dữ liệu: $e');
    }
  }

  Future<void> _postApCreditMemo() async {
    try {
      if (apCreditMemo != null) {
        final grrData = {
          'DocEntry': grr?['docEntry'].toString(),
          'DocNo': grr?['docNum'].toString(),
          'VendorCode': grr?['cardCode'],
          'VendorName': grr?['cardName'],
          'PostDay': _dateController.text,
          // 'Remake': _commentController.text,
          'Lines': []
        };

        if (lines.isNotEmpty) {
          for (var item in lines) {
            final lineData = {
              'ItemCode': item['itemCode'],
              'ItemName': item['itemDescription'],
              'Quantity': item['quantity'].toString(),
              'BaseEntry': grr?['docEntry'].toString() ?? 0,
              'BaseLine': item['lineNum'].toString(),
              'WarehouseCode': item['warehouseCode'] ?? '',
              'BaseType': 234000032.toString(),
              'Batches': []
            };

            final grrItemsDetailForLine = await fetchGrrItemsDetailData(
                widget.qrData, item["lineNum"].toString());
            if (grrItemsDetailForLine != null &&
                grrItemsDetailForLine['data'] is List) {
              for (var batch in grrItemsDetailForLine['data']) {
                final batchData = {
                  // 'ItemCode': batch["ItemCode"],
                  'BatchNumber': batch["Batch"],
                  'Quantity': batch["SlThucTe"]
                };
                (lineData['Batches'] as List).add(batchData);
              }
            }

            (grrData['Lines'] as List).add(lineData);
          }

          await postGrr(grrData, context);
        } else {}
      } else {
        print('Dữ liệu đơn hàng (grr) là null');
      }
    } catch (e) {
      print('Lỗi khi gửi dữ liệu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var docNum = grr?['docNum']?.toString() ?? '';
    var cardCode = grr?['cardCode'] ?? '';
    var cardName = grr?['cardName'] ?? '';

    return Scaffold(
        appBar: const HeaderApp(title: "AP Credit Memo"),
        body: _isLoading
            ? const CustomLoading()
            : Container(
                width: double.infinity,
                height: double.infinity,
                color: bgColor,
                padding: AppStyles.paddingContainer,
                child: ListView(
                  children: [
                    buildTextFieldRow(
                      labelText: 'Doc No:',
                      hintText: 'Doc No',
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
                        labelText: 'Remarks',
                        isEnable: true,
                        hintText: 'Remarks here',
                        icon: Icons.edit,
                        controller: _commentController),
                    if (lines.isNotEmpty)
                      ListItems(
                        listItems: lines,
                        onTapItem: (index) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ApCreditmemoDetail(
                                docEntry: lines[index]['docEntry'].toString(),
                                lineNum: lines[index]['lineNum'].toString(),
                                baseEntry: linesApInvoice
                                    .map((item) => item["baseEntry"])
                                    .join(", "),
                                baseLine: linesApInvoice
                                    .map((item) => item["baseLine"])
                                    .join(", "),
                                itemCode: lines[index]['itemCode'].toString(),
                                description: lines[index]['itemDescription'],
                                whse: lines[index]['warehouseCode'],
                                slYeuCau: lines[index]['quantity'].toString(),
                                slThucTe: lines[index]['SlThucTe'].toString(),
                                batch: lines[index]['Batch'].toString(),
                                uoMCode: lines[index]['uoMCode'].toString(),
                                remake: lines[index]['remake'].toString(),
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
                            text: 'AddToSap',
                            onPressed: _postGoodReturnRequestToApCreditMemo,
                          ),
                          CustomButton(
                            text: 'POST',
                            onPressed: () async {
                              await updateApCreditMemoDatabase(
                                  widget.qrData,
                                  _commentController.text,
                                  _dateController.text,
                                  context);
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ));
  }
}
