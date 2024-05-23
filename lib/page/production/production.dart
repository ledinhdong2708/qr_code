import 'package:flutter/material.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/page/qr_view_example.dart';

class Production extends StatelessWidget {
  const Production({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Production"),
        backgroundColor: bgColor,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        color: bgColor,
        child: GridView.count(
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: [
            InkWell(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => const QRViewExample()),
                // );
                Navigator.pushNamed(
                    context, '/home/production/issue_for_production');
              },
              // thay đổi lại hình ảnh
              child: card("assets/delivery.png", "Issue for Production"),
            ),
            InkWell(
              onTap: () {
                // **** mở ra khi test xong UI của good return khi quét qr code ****
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => const QRViewExample()),
                // );
                // **** quét qr xong rồi vào đây ****
                Navigator.pushNamed(
                    context, '/home/production/receipt_from_production');
              },
              // thay đổi lại hình ảnh
              child: card("assets/return.png", "Receipt from Production"),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/home/production/goods_receipt');
              },
              // thay đổi lại hình ảnh
              child: card("assets/credit-memo.png", "Goods Receipt"),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/home/production/goods_issue');
              },
              // thay đổi lại hình ảnh
              child: card("assets/credit-memo.png", "Goods Issue"),
            ),
          ],
        ),
      ),
    );
  }
}

Column card(String imgName, String nameOfCard) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(
        imgName,
        width: 100,
      ),
      Text(nameOfCard)
    ],
  );
}
