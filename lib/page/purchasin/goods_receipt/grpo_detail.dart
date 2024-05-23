import 'package:flutter/material.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/date_input.dart';
import 'package:qr_code/component/qr_input.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';

class GrpoDetail extends StatelessWidget {
  const GrpoDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("GRPO - Detail"),
          backgroundColor: bgColor,
        ),
        body: Container(
          color: bgColor,
          width: double.infinity,
          height: double.infinity,
          padding: AppStyles.paddingContainer,
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildTextFieldRow(
                    labelText: 'Item Code', hintText: 'Item Code'),
                buildTextFieldRow(
                    labelText: 'Item Name', hintText: 'Item Name'),
                buildTextFieldRow(
                  labelText: 'Whse',
                  isEnable: true,
                  hintText: 'Whse',
                  icon: Icons.more_vert,
                ),
                buildTextFieldRow(
                    labelText: 'SL Yêu Cầu', hintText: 'SL Yêu Cầu'),
                buildTextFieldRow(
                    labelText: 'SL Thực Tế',
                    hintText: 'SL Thực Tế',
                    isEnable: true,
                    icon: null),
                buildTextFieldRow(labelText: 'Batch', hintText: 'Batch'),
                buildTextFieldRow(labelText: 'UoM Code', hintText: 'UoM Code'),
                buildTextFieldRow(
                  labelText: 'Remake',
                  isEnable: true,
                  hintText: 'Remake here',
                  icon: Icons.edit,
                ),
                // list item ở đây
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context,
                        '/home/purchasing/goodsreceiptpo/grpo/grpo_detail/grpo_labels');
                  },
                  child: const Text('Tạo Nhãn'),
                ),
                Container(
                  width: double.infinity,
                  margin: AppStyles.marginButton,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomButton(
                        text: 'New',
                        onPressed: () {},
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      CustomButton(
                        text: 'ADD',
                        onPressed: () {},
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
