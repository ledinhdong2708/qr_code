import 'package:flutter/material.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/service/grpo_service.dart';

class GrpoDetailItems extends StatefulWidget {
  final String docEntry;
  final String lineNum;
  final String batch;
  final String slThucTe;
  final String remake;
  const GrpoDetailItems(
      {super.key,
      this.docEntry = '',
      this.lineNum = '',
      this.batch = '',
      this.slThucTe = '',
      this.remake = ''});

  @override
  _GrpoDetailItemsState createState() => _GrpoDetailItemsState();
}

class _GrpoDetailItemsState extends State<GrpoDetailItems> {
  late TextEditingController batchController;
  late TextEditingController slThucTeController;
  late TextEditingController remakeController;
  // final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    batchController = TextEditingController(text: widget.batch);
    slThucTeController = TextEditingController(text: widget.slThucTe);
    remakeController = TextEditingController(text: widget.remake);
  }

  @override
  void dispose() {
    batchController.dispose();
    slThucTeController.dispose();
    remakeController.dispose();
    super.dispose();
  }

  Future<void> _submitData() async {
    final data = {
      'docEntry': widget.docEntry,
      'lineNum': widget.lineNum,
      'batch': batchController.text,
      'slThucTe': slThucTeController.text,
      'remake': remakeController.text,
    };

    try {
      await postGrpoItemsDetailData(
          data, context, widget.docEntry, widget.lineNum);
    } catch (e) {
      print('Error submitting data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderApp(title: "GRPO - Detail - Items"),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: bgColor,
        padding: AppStyles.paddingContainer,
        child: Column(
          children: [
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
                    onPressed: _submitData,
                  ),
                  CustomButton(
                    text: 'CANCEL',
                    onPressed: () {},
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
