import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/date_input.dart';
import 'package:qr_code/component/dropdownbutton.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/qr_input.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/page/inventory/inventorytransfer/inventory_transfer_item.dart';
import 'package:qr_code/routes/routes.dart';

import '../../../component/list_items.dart';
import '../../../service/inventory_transfer_service.dart';
import '../../qr_view_example.dart';

class InventoryTransfer extends StatefulWidget {
  final String qrData;
  const InventoryTransfer({super.key, this.qrData=''});
  @override
  _InventoryTransferState createState() => _InventoryTransferState();

}
class _InventoryTransferState extends State<InventoryTransfer> {
  final TextEditingController _dateController = TextEditingController();
  List<dynamic> inventoryTransferItems = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    fetchInventoryTransferItemsData().then((data) {
      if (data != null && data['data'] is List) {
        setState(() {
          inventoryTransferItems = data['data'];
          // if (goodsIssueInvenItemsDetail.isNotEmpty) {
          //   itemCodeController.text = goodsIssueInvenItemsDetail[0]['ItemCode'];
          //   descriptionController.text = goodsIssueInvenItemsDetail[0]['ItemName'];
          //   batchController.text = goodsIssueInvenItemsDetail[0]['Batch'];
          //   whseController.text = goodsIssueInvenItemsDetail[0]['Whse'];
          //   slThucTeController.text = goodsIssueInvenItemsDetail[0]['SlThucTe'].toString();
          //   uoMCodeController.text = goodsIssueInvenItemsDetail[0]['UoMCode'].toString();
          //   remakeController.text = goodsIssueInvenItemsDetail[0]['Remake'].toString();
          // }
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formatter = DateFormat('dd/MM/yyyy');
    String docDate = formatter.format(now);
    final Map<String, dynamic> qrDataMap = parseQrData(widget.qrData);
    final TextEditingController _controller = TextEditingController();
    return Scaffold(
        appBar: const HeaderApp(title: "Inventory Transfer"),
        body: Container(
          color: bgColor,
          width: double.infinity,
          height: double.infinity,
          padding: AppStyles.paddingContainer,
            child: ListView(
              children: [
                DateInput(
                  postDay: docDate,
                  controller: _dateController,
                ),
                buildTextFieldRow(
                    labelText: 'From Warehouse:',
                    hintText: 'From Warehouse',
                    isEnable: true),
                buildTextFieldRow(
                    labelText: 'To Warehouse:',
                    hintText: 'To Warehouse',
                    isEnable: true),
                buildTextFieldRow(
                  labelText: 'Item',
                  hintText: 'Item',
                  iconButton: IconButton(
                    icon: const Icon(Icons.qr_code_scanner),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const QRViewExample(
                              pageIdentifier: 'InventoryTransferDetail',
                            )),
                      ).then((_) => _fetchData());
                    },
                  ),
                ),
                // buildTextFieldRow(
                //     labelText: 'Batch', hintText: 'Batch', isEnable: true),
                // buildTextFieldRow(
                //     labelText: 'Quantity',
                //     hintText: 'Quantity',
                //     isEnable: true),
                // Dropdownbutton(
                //   items: ['UoM a', 'UoM b', 'UoM c'],
                //   labelText: 'UoM Code',
                //   hintText: 'UoM Code',
                // ),
                // buildTextFieldRow(labelText: 'UoM Name', hintText: 'UoM Name'),
                //
                // buildTextFieldRow(
                //   labelText: 'Remake',
                //   isEnable: true,
                //   hintText: 'Remake here',
                //   icon: Icons.edit,
                // ),
                // list item ở đây
                if (inventoryTransferItems.isNotEmpty)
                  ListItems(
                    listItems: inventoryTransferItems,
                    enableDismiss: true,
                    onDeleteItem: (index) async {
                      String id = inventoryTransferItems[index]['ID'].toString();
                      await deleteInventoryTransferItemsData(id, context);
                    },
                    onTapItem: (index) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InventoryTransferItem(
                            isEditable: false,
                            id: inventoryTransferItems[index]['ID'].toString(),
                            itemCode: inventoryTransferItems[index]['ItemCode'],
                            itemName: inventoryTransferItems[index]['ItemName'],
                            quantity: inventoryTransferItems[index]['Quantity'],
                            fromWhse: inventoryTransferItems[index]['FromWhse'],
                            toWhse: inventoryTransferItems[index]['ToWhse'],
                            uoMCode: inventoryTransferItems[index]['UoMCode'].toString(),
                            batch: inventoryTransferItems[index]['Batch'].toString(),
                            sokien: inventoryTransferItems[index]['Sokien'].toString(),
                          ),
                        ),
                      );
                    },

                    labelsAndChildren: const [
                      {'label': 'ItemCode', 'child': 'ItemCode'},
                      {'label': 'ItemName', 'child': 'ItemName'},
                      {'label': 'FromWhse', 'child': 'FromWhse'},
                      {'label': 'ToWhse', 'child': 'ToWhse'},
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
                        text: 'POST',
                        onPressed: () {},
                      ),
                      CustomButton(
                        text: 'POST TO SAP',
                        onPressed: () {},
                      ),
                    ],
                  ),
                )
              ],
            ),
        ));
  }

  Map<String, dynamic> parseQrData(String qrData) {
    try {
      return jsonDecode(qrData);
    } catch (e) {
      // Xử lý lỗi nếu qrData không phải là chuỗi JSON hợp lệ
      print('Lỗi khi phân tích cú pháp qrData: $e');
      return {};
    }
  }
}
