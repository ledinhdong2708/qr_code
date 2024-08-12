import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/date_input.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/loading.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/page/sales/delivery/delivery_detail.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../../component/list_items.dart';
import '../../../service/delivery_service.dart';

class Delivery extends StatefulWidget {
  final String qrData;
  const Delivery({super.key, required this.qrData});

  @override
  State<Delivery> createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  final TextEditingController _remakeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  Barcode? result;
  List<dynamic> delivery = [];
  Map<String, dynamic>? saleOrder;
  List<dynamic> lines = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSaleOrderData();
  }

  Future<void> _fetchSaleOrderData() async {
    final data = await fetchSaleOrderData(widget.qrData, context);
    if (data != null) {
      setState(() {
        _isLoading = false;
        saleOrder = data;
        lines = saleOrder?["lines"] ?? [];
        if (saleOrder?['docDate'] != null) {
          _dateController.text = DateFormat('dd/MM/yyyy')
              .format(DateTime.parse(saleOrder?['docDate']));
        }
      });
    } else {
      print("Sai");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const HeaderApp(title: "Delivery"),
        body: _isLoading
            ? const CustomLoading()
            : Container(
                width: double.infinity,
                height: double.infinity,
                color: bgColor,
                padding: AppStyles.paddingContainer,
                child: Column(
                  children: [
                    buildTextFieldRow(
                      labelText: 'Doc No:',
                      hintText: 'Doc No',
                      valueQR: saleOrder?["docNum"].toString(),
                    ),
                    DateInput(
                      // postDay: docDate,
                      controller: _dateController,
                    ),
                    buildTextFieldRow(
                      labelText: 'Vendor:',
                      hintText: 'Vendor Code',
                      valueQR: saleOrder?["cardCode"],
                    ),
                    buildTextFieldRow(
                      labelText: 'Name:',
                      hintText: 'Vendor Name',
                      valueQR: saleOrder?["cardName"],
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
                              builder: (context) => DeliveryDetail(
                                docEntry: lines[index]['docEntry'].toString(),
                                lineNum: lines[index]['lineNum'].toString(),
                                itemCode: lines[index]['itemCode'],
                                description: lines[index]['itemDescription'],
                                whse: lines[index]['warehouseCode'],
                                slYeuCau: lines[index]['quantity'].toString(),
                                slThucTe: lines[index]['SlThucTe'].toString(),
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
                          {'label': 'UoM Code', 'child': 'uoMCode'},
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
                            text: 'POST TO SAP',
                            onPressed: () {},
                          ),
                          CustomButton(
                            text: 'POST',
                            onPressed: () async {
                              await updateDeliveryDatabase(
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
