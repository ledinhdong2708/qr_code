import 'package:flutter/material.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/page/qr_view_example.dart';

class Inventory extends StatelessWidget {
  const Inventory({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Inventory"),
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
                Navigator.pushNamed(context, '/home/inventory/goods_receipt');
              },
              // thay đổi lại hình ảnh
              child: card("assets/receipt.png", "Goods Receipt"),
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
                Navigator.pushNamed(context, '/home/inventory/goods_issue');
              },
              // thay đổi lại hình ảnh
              child: card("assets/return.png", "Goods Issue"),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(
                    context, '/home/inventory/inventory_counting');
              },
              // thay đổi lại hình ảnh
              child: card("assets/credit-memo.png", "Inventory Counting"),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(
                    context, '/home/inventory/inventory_transfer');
              },
              // thay đổi lại hình ảnh
              child: card("assets/credit-memo.png", "Inventory Transfer"),
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
