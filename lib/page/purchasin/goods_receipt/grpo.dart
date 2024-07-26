import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/date_input.dart';
import 'package:qr_code/component/dialog.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/list_items.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/page/purchasin/goods_receipt/grpo_detail.dart';
import 'package:qr_code/service/grpo_service.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class Grpo extends StatefulWidget {
  final String qrData;
  final String docEntry;
  const Grpo({super.key, required this.qrData, this.docEntry = ""});

  @override
  State<Grpo> createState() => _GrpoState();
}

class _GrpoState extends State<Grpo> {
  final TextEditingController _remakeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  Barcode? result;
  List<dynamic> grpo = [];
  Map<String, dynamic>? opor;
  Map<String, dynamic>? po;
  List<dynamic> opdn = [];
  List<dynamic> DocumentLines = [];

  late TextEditingController vendorCodeController;
  late TextEditingController vendorNameController;
  late TextEditingController postDayController;
  late TextEditingController docNoController;
  late TextEditingController docEntryController;
  late TextEditingController baseEntryController;
  late TextEditingController remakeController;

  @override
  void initState() {
    super.initState();

    fetchOporData(widget.qrData).then((data) {
      if (data != null) {
        if (data['data'] != null && data['data']['DocDate'] != null) {
          DateTime parsedDate = DateTime.parse(data['data']['DocDate']);
          String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
          data['data']['DocDate'] = formattedDate;
        }
        setState(() {
          opor = data;
          _remakeController.text = opor?['data']['remake'] ?? '';
          _dateController.text = opor?['data']['DocDate'] ?? '';
        });
      }
    });

    _fetchGrpoData();
    _loginSap();
    // _fetchPor1Data();
  }

  Future<void> _fetchOpdnData() async {
    var data = await fetchOpdnData(widget.qrData);
    if (data != null && data['data'] is List) {
      setState(() {
        opdn = data['data'];
        print("Fetched opdn data: $opdn");
      });
    } else {
      print("No data or data is not in the expected format");
    }
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
            remakeController.text = grpo[0]['remake'];
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
    remakeController.dispose();
    baseEntryController.dispose();
    super.dispose();
  }

  Future<void> _submitPor1GrpoData() async {
    int totalItems1 = grpo.length;
    int totalItems2 = opdn.length;
    int totalItems3 = opdn.length;
    int successfulCount1 = 0;
    int successfulCount2 = 0;
    int successfulCount3 = 0;

    try {
      for (var item in grpo) {
        final data = {
          'DocDate': item['postday'],
          'CardCode': item['vendorcode'],
          'CardName': item['vendorname'],
          'BaseEntry': item['DocEntry'],
        };
        await postOpdnData(data, context);
        successfulCount1++;
      }
      await _fetchOpdnData();

      if (opdn.isNotEmpty) {
        for (var item in opdn) {
          final data = {
            'TrgetEntry': item['DocEntry'],
          };
          await updatePor1Data(data, context, widget.qrData);
          successfulCount2++;
        }
        // for (var item2 in opdn) {
        //   for (var item in po) {
        //     final data = {
        //       'DocEntry': item2['DocEntry'],
        //       'ItemCode': item['ItemCode'],
        //       'Dscription': item['Dscription'],
        //       'Quantity': item['OpenQty'],
        //       'WhsCode': item['WhsCode'],
        //       'LineNum': item['LineNum'],
        //       'BaseEntry': item['DocEntry'],
        //       'BaseLine': item['LineNum'],
        //       'BaseType': item['ObjType'],
        //       'BaseRef': item['DocEntry'],
        //     };
        //     await postPdn1Data(data, context);
        //     successfulCount3++;
        //   }
        // }
      } else {
        print('opdn data is not available');
      }
      if (successfulCount1 == totalItems1 &&
          successfulCount2 == totalItems2 &&
          successfulCount3 == totalItems3) {
        print('All data successfully sent to server');
        CustomDialog.showDialog(context, 'Cập nhật thành công!', 'success');
      }
    } catch (e) {
      print('Error submitting data: $e');
    }
  }

// Fetch Po Data
  Future<void> _fetchPoData() async {
    final data = await fetchPoData(widget.qrData, context);
    if (data != null) {
      setState(() {
        po = data;
        DocumentLines = po?["DocumentLines"];
        print("Thành công: $DocumentLines");
      });
    } else {
      print("Sai");
    }
  }

// Login to sap
  Future<void> _loginSap() async {
    try {
      final data = {
        'CompanyDB': "DB_DEMO",
        'UserName': "manager",
        'Password': "manager",
      };
      await loginSap(data, context);
      await _fetchPoData();
    } catch (e) {
      print('Error during login and data fetch: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Header PO in Sap
    var docNum = po?['DocNum']?.toString() ?? '';
    var docDate = po?['DocDate']?.toString() ?? '';
    var cardCode = po?['CardCode'] ?? '';
    var cardName = po?['CardName'] ?? '';
    return Scaffold(
        appBar: const HeaderApp(title: "GRPO"),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: bgColor,
          padding: AppStyles.paddingContainer,
          child: Column(
            children: [
              buildTextFieldRow(
                labelText: 'Doc No.',
                hintText: 'Doc No.',
                valueQR: docNum,
              ),
              DateInput(
                postDay: docDate,
                controller: _dateController,
              ),
              buildTextFieldRow(
                labelText: 'Vendor Code',
                hintText: 'Vendor Code',
                valueQR: cardCode,
              ),
              buildTextFieldRow(
                labelText: 'Vendor Name',
                hintText: 'Vendor Name',
                valueQR: cardName,
              ),
              buildTextFieldRow(
                  labelText: 'Remake',
                  isEnable: true,
                  hintText: 'Remake here',
                  icon: Icons.edit,
                  // valueQR: remark,
                  controller: _remakeController),
              if (DocumentLines.isNotEmpty)
                ListItems(
                    listItems: DocumentLines,
                    onTapItem: (index) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GrpoDetail(
                            docEntry:
                                DocumentLines[index]['DocEntry']?.toString() ??
                                    '',
                            lineNum:
                                DocumentLines[index]['LineNum']?.toString() ??
                                    '',
                            itemCode:
                                DocumentLines[index]['ItemCode']?.toString() ??
                                    '',
                            description: DocumentLines[index]['ItemDescription']
                                    ?.toString() ??
                                '',
                            whse: DocumentLines[index]['WhsCode']?.toString() ??
                                '',
                            slYeuCau:
                                DocumentLines[index]['Quantity']?.toString() ??
                                    '',
                            slThucTe:
                                DocumentLines[index]['SlThucTe']?.toString() ??
                                    '',
                            batch:
                                DocumentLines[index]['Batch']?.toString() ?? '',
                            uoMCode:
                                DocumentLines[index]['UomCode']?.toString() ??
                                    '',
                            remake:
                                DocumentLines[index]['remake']?.toString() ??
                                    '',
                          ),
                        ),
                      );
                    },
                    labelName1: 'DocNo',
                    labelName2: 'Code',
                    labelName3: 'Name',
                    labelName4: 'SlYeuCau',
                    listChild1: 'DocEntry',
                    listChild2: 'ItemCode',
                    listChild3: 'ItemDescription',
                    listChild4: 'Quantity'),
              Container(
                width: double.infinity,
                margin: AppStyles.marginButton,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomButton(
                      text: 'Add to Sap',
                      onPressed: _submitPor1GrpoData,
                    ),
                    CustomButton(
                      text: 'POST',
                      onPressed: () async {
                        await updateGrpoDatabase(
                            widget.qrData,
                            _remakeController.text,
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
