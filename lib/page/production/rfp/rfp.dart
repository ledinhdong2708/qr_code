import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/date_input.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/page/production/rfp/rfp_detail.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../component/list_items.dart';
import '../../../service/rfp_service.dart';
import '../../qr_view_example.dart';

class Rfp extends StatefulWidget {
  final String qrData;

  const Rfp({super.key, required this.qrData});

  @override
  State<Rfp> createState() => _RfpState();
}
class _RfpState extends State<Rfp> {
  final TextEditingController _remakeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  List<dynamic> rfp = [];
  Map<String, dynamic>? oprr; // chua doi ten
  List<dynamic> prr1 = [];    // chua doi ten
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    fetchRfpHeaderData().then((data) {
      if (data != null && data['data'] is List) {
        setState(() {
          rfp = data['data'];
        });
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    var data = oprr?['data'];
    DateTime now = DateTime.now();
    var docDate = data != null ? data['PostDate'].toString() : DateFormat('dd/MM/yyyy').format(now);
    var remark = data != null ? data['remake'] : '';

    return Scaffold(
      appBar: const HeaderApp(title: "Receipt from Production"),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: bgColor,
        padding: AppStyles.paddingContainer,
        child: Column(
          children: [
            buildTextFieldRow(
              labelText: 'Production Order',
              hintText: 'Production Order',
              iconButton: IconButton(
                icon: const Icon(Icons.qr_code_scanner),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const QRViewExample(
                          pageIdentifier: 'RfpDetail',
                        )),
                  );
                },
              ),
              //valueQR: docNum,
            ),
            DateInput(
              postDay: docDate,
              controller: _dateController,
            ),

            buildTextFieldRow(
                labelText: 'Remake',
                isEnable: true,
                hintText: 'Remake here',
                icon: Icons.edit,
                valueQR: remark,
                controller: _remakeController),
            if (rfp.isNotEmpty)
              ListItems(
                  listItems: rfp,
                  onTapItem: (index) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RfpDetail(
                          qrData: rfp[index]['DocEntry'],
                        ),
                      ),
                    );
                  },
                  labelsAndChildren: const [
                    {'label': 'Product Order No', 'child': 'DocNum'},
                    {'label': 'ItemCode', 'child': 'ItemCode'},
                    {'label': 'ProdName', 'child': 'ProdName'},
                    {'label': 'Warehouse', 'child': 'Warehouse'},
                    // Add more as needed
                  ],
                  // labelName1: 'Product Order No',
                  // labelName2: 'ItemCode',
                  // labelName3: 'ProdName',
                  // labelName4: 'Warehouse',
                  // listChild1: 'DocNum',
                  // listChild2: 'ItemCode',
                  // listChild3: 'ProdName',
                  // listChild4: 'Warehouse'
              ),
            Container(
              width: double.infinity,
              margin: AppStyles.marginButton,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // CustomButton(
                  //   text: 'DELETE',
                  //   onPressed: () {
                  //
                  //   },
                  // ),
                  CustomButton(
                    text: 'POST',
                    onPressed: () async {
                      // await updateGrrDatabase(
                      //     widget.qrData,
                      //     _remakeController.text,
                      //     _dateController.text,
                      //     context);
                    },
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
