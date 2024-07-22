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
  List<dynamic> por1 = [];

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
    _fetchPor1Data();
  }

  Future<void> _fetchPor1Data() async {
    fetchPor1Data(widget.qrData).then((data) {
      if (data != null && data['data'] is List) {
        setState(() {
          por1 = data['data'];
          print("hello:  $por1");
        });
      }
    });
  }

  Future<void> _fetchGrpoData() async {
    fetchGrpoData(widget.qrData).then((data) {
      if (data != null && data['data'] is List) {
        setState(() {
          grpo = data['data'];
          print('aaaaaaaaaaaaaaaaaaaaaaaaaa $grpo');
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

  Future<void> _submitData() async {
    try {
      for (var item in por1) {
        final data = {
          'ItemCode': item['ItemCode'],
          'Dscription': item['Dscription'],
          'Quantity': item['OpenQty'],
          'WhsCode': item['WhsCode'],
          'LineNum': item['LineNum'],
          'BaseEntry': item['DocEntry'],
          'BaseLine': item['LineNum'],
          'DocEntry': item['DocEntry'],
          'BaseType': item['ObjType']
        };
        await postPdn1Data(data, context);
      }
    } catch (e) {
      print('Error submitting data: $e');
    }
  }

  Future<void> _submitData2() async {
    try {
      for (var item in grpo) {
        final data = {
          'DocEntry': item['DocEntry'],
          'DocNum': item['docno'],
          'DocDate': item['postday'],
          'CardCode': item['vendorcode'],
          'CardName': item['vendorname'],
          'BaseEntry': item['DocEntry'],
        };
        await postOpdnData(data, context);
      }
    } catch (e) {
      print('Error submitting data: $e');
    }
  }

  void addToSap() {
    _submitData();
    _submitData2();
  }

  @override
  Widget build(BuildContext context) {
    var data = opor?['data'];
    var docNum = data != null ? data['DocNum'].toString() : '';
    var docDate = data != null ? data['DocDate'].toString() : '';
    var cardCode = data != null ? data['CardCode'] : '';
    var cardName = data != null ? data['CardName'] : '';
    var remark = data != null ? data['remake'] : '';

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
                  valueQR: remark,
                  controller: _remakeController),
              if (por1.isNotEmpty)
                ListItems(
                    listItems: por1,
                    onTapItem: (index) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GrpoDetail(
                            docEntry: por1[index]['DocEntry'],
                            lineNum: por1[index]['LineNum'],
                            itemCode: por1[index]['ItemCode'],
                            description: por1[index]['Dscription'],
                            whse: por1[index]['WhsCode'],
                            slYeuCau: por1[index]['OpenQty'].toString(),
                            slThucTe: por1[index]['SlThucTe'].toString(),
                            batch: por1[index]['Batch'].toString(),
                            uoMCode: por1[index]['UomCode'].toString(),
                            remake: por1[index]['remake'].toString(),
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
                    listChild3: 'Dscription',
                    listChild4: 'OpenQty'),
              Container(
                width: double.infinity,
                margin: AppStyles.marginButton,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomButton(
                      text: 'Add to Sap',
                      onPressed: addToSap,
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
