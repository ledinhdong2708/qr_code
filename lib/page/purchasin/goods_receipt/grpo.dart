import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/date_input.dart';
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
  final TextEditingController _remarksController = TextEditingController();
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

    _fetchGrpoData();
    _loginSap();
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
            _remarksController.text = grpo[0]['remake'];
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

  Future<void> _postPoToGrpo() async {
    try {
      if (po != null) {
        final grpoData = {
          'DocDate': po?['DocDate'],
          'CardCode': po?['CardCode'],
          'CardName': po?['CardName'],
          'Comments': po?['Comments'],
          'DocumentLines': []
        };

        if (DocumentLines.isNotEmpty) {
          for (var item in DocumentLines) {
            final lineData = {
              'ItemCode': item['ItemCode'],
              'ItemDescription': item['ItemDescription'],
              'Quantity': item['Quantity'],
              'BaseEntry': item['DocEntry'],
              'BaseLine': item['LineNum'],
              'BaseType': 22
            };
            grpoData['DocumentLines'].add(lineData);
          }

          print('Dữ liệu gửi đi: $grpoData');

          await postPoToGrpo(grpoData, context);
        } else {
          print('DocumentLines là null');
        }
      } else {
        print('Dữ liệu đơn hàng (po) là null');
      }
    } catch (e) {
      print('Lỗi khi gửi dữ liệu: $e');
    }
  }

// Fetch Po Data
  Future<void> _fetchPoData() async {
    final data = await fetchPoData(widget.qrData, context);
    if (data != null) {
      setState(() {
        po = data;
        DocumentLines = po?["DocumentLines"];
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
          child: ListView(
            children: [
              buildTextFieldRow(
                labelText: 'Doc No:',
                hintText: 'Doc No',
                valueQR: docNum,
              ),
              DateInput(
                postDay: docDate,
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
                  // valueQR: remark,
                  controller: remakeController),
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
                              DocumentLines[index]['LineNum']?.toString() ?? '',
                          itemCode:
                              DocumentLines[index]['ItemCode']?.toString() ??
                                  '',
                          description: DocumentLines[index]['ItemDescription']
                                  ?.toString() ??
                              '',
                          whse:
                              DocumentLines[index]['WhsCode']?.toString() ?? '',
                          slYeuCau:
                              DocumentLines[index]['Quantity']?.toString() ??
                                  '',
                          slThucTe:
                              DocumentLines[index]['SlThucTe']?.toString() ??
                                  '',
                          batch:
                              DocumentLines[index]['Batch']?.toString() ?? '',
                          uoMCode:
                              DocumentLines[index]['UomCode']?.toString() ?? '',
                          remake:
                              DocumentLines[index]['remake']?.toString() ?? '',
                        ),
                      ),
                    );
                  },
                  labelsAndChildren: const [
                    {'label': 'DocNo', 'child': 'DocEntry'},
                    {'label': 'Code', 'child': 'ItemCode'},
                    {'label': 'Name', 'child': 'Dscription'},
                    {'label': 'SlYeuCau', 'child': 'OpenQty'},
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
                      onPressed: () async {},
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
