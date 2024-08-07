import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/date_input.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/loading.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../../component/list_items.dart';
import '../../../service/goodreturn_service.dart';
import 'goods_return_detail.dart';

class GoodsReturn extends StatefulWidget {
  final String qrData;
  const GoodsReturn({super.key, required this.qrData});

  @override
  State<GoodsReturn> createState() => _GoodsReturnState();
}

class _GoodsReturnState extends State<GoodsReturn> {
  final TextEditingController _remakeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  Barcode? result;
  List<dynamic> goodreturn = [];
  Map<String, dynamic>? oprr;
  List<dynamic> prr1 = [];
  List<dynamic> lines = [];
  Map<String, dynamic>? grr;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    // fetchOprrData(widget.qrData).then((data) {
    //   if (data != null) {
    //     if (data['data'] != null && data['data']['DocDate'] != null) {
    //       DateTime parsedDate = DateTime.parse(data['data']['DocDate']);
    //       String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
    //       data['data']['DocDate'] = formattedDate;
    //     }
    //     setState(() {
    //       oprr = data;
    //       _remakeController.text = oprr?['data']['remake'] ?? '';
    //       _dateController.text = oprr?['data']['DocDate'] ?? '';
    //     });
    //   }
    // });
    // fetchPrr1Data(widget.qrData).then((data) {
    //   if (data != null && data['data'] is List) {
    //     setState(() {
    //       prr1 = data['data'];
    //     });
    //   }
    // });
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
              DateFormat('dd/MM/yyyy').format(DateTime.parse(grr?['docDate']));
        }
      });
    } else {
      print("Sai");
    }
  }

  @override
  Widget build(BuildContext context) {
    var docNum = grr?['docNum']?.toString() ?? '';
    var cardCode = grr?['cardCode'] ?? '';
    var cardName = grr?['cardName'] ?? '';

    return Scaffold(
      appBar: const HeaderApp(title: "Good Return"),
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
                      labelText: 'Remarks:',
                      isEnable: true,
                      hintText: 'Remarks here',
                      icon: Icons.edit,
                      controller: _remakeController),
                  if (lines.isNotEmpty)
                    ListItems(
                      listItems: lines,
                      onTapItem: (index) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GoodsReturnDetail(
                              docEntry: lines[index]['docEntry'].toString(),
                              lineNum: lines[index]['lineNum'].toString(),
                              itemCode: lines[index]['itemCode'].toString(),
                              description: lines[index]['itemDescription'],
                              whse: lines[index]['warehouseCode'],
                              slYeuCau: lines[index]['quantity'].toString(),
                              slThucTe: lines[index]['SlThucTe'].toString(),
                              batch: lines[index]['Batch'].toString(),
                              uoMCode: lines[index]['uomCode'].toString(),
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
                          text: 'POST TO SAP',
                          onPressed: () {},
                        ),
                        CustomButton(
                          text: 'POST',
                          onPressed: () async {
                            await updateGrrDatabase(
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
            ),
    );
  }
}
