import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/page/print_page.dart';

class SalesReturnDetailItems extends StatefulWidget {
  final String id;
  final String batch;
  final String slThucTe;
  final String remake;
  final String itemCode;
  final String itemName;
  final String whse;
  final String uoMCode;
  const SalesReturnDetailItems(
      {super.key,
        this.id = '',
        this.batch = '',
        this.slThucTe = '',
        this.itemCode = '',
        this.itemName = '',
        this.whse = '',
        this.uoMCode = '',
        this.remake = ''});

  @override
  _SalesReturnDetailItemsState createState() => _SalesReturnDetailItemsState();
}

class _SalesReturnDetailItemsState extends State<SalesReturnDetailItems> {
  late TextEditingController idController;
  late TextEditingController batchController;
  late TextEditingController slThucTeController;
  late TextEditingController remakeController;
  late TextEditingController itemCodeController;
  late TextEditingController descriptionController;
  late TextEditingController whseController;
  late TextEditingController uoMCodeController;

  // final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    idController = TextEditingController(text: widget.id);
    itemCodeController = TextEditingController(text: widget.itemCode);
    descriptionController = TextEditingController(text: widget.itemName);
    batchController = TextEditingController(text: widget.batch);
    whseController = TextEditingController(text: widget.whse);
    slThucTeController = TextEditingController(text: widget.slThucTe);
    uoMCodeController = TextEditingController(text: widget.uoMCode);
    remakeController = TextEditingController(text: widget.remake);
  }

  @override
  void dispose() {
    batchController.dispose();
    slThucTeController.dispose();
    remakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderApp(title: "Sales Return - Detail - Items"),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: bgColor,
        padding: AppStyles.paddingContainer,
        child: Column(
          children: [
            buildTextFieldRow(
              controller: itemCodeController,
              labelText: 'Item Code',
              hintText: 'Item Code',
            ),
            buildTextFieldRow(
              controller: descriptionController,
              labelText: 'Item Name',
              hintText: 'Item Name',
            ),
            buildTextFieldRow(
              controller: whseController,
              labelText: 'Whse',
              hintText: 'Whse',
            ),
            buildTextFieldRow(
              controller: uoMCodeController,
              labelText: 'UoMCode',
              hintText: 'UoMCode',
            ),
            buildTextFieldRow(
                controller: slThucTeController,
                labelText: 'Sl Thực tế',
                hintText: 'Sl Thực tế',
                isEnable: true),
            buildTextFieldRow(
                controller: batchController,
                labelText: 'Batch',
                hintText: 'Batch',
                isEnable: true),
            buildTextFieldRow(
                controller: remakeController,
                labelText: 'Remake',
                hintText: 'Remake',
                isEnable: true),
            Flexible(
              child: Container(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomButton(
                    text: 'PRINT',
                    onPressed: () {
                      final data = {
                        'id': idController.text,
                        'itemCode': itemCodeController.text,
                        'itemName': descriptionController.text,
                        'whse': whseController.text,
                        'uoMCode': uoMCodeController.text,
                        'batch': batchController.text,
                        'slThucTe': slThucTeController.text,
                        'remake': remakeController.text,
                      };
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PrintPage(data: data),
                        ),
                      );
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => PrintPage(
                      //       data: data
                      //     ),
                      //   ),
                      // );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
