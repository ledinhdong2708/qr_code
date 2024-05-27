import 'package:flutter/material.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/page/qr_view_example.dart';
import 'package:qr_code/routes/routes.dart';

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
                Navigator.pushNamed(context, Routes.goodsReceiptInven);
              },
              // thay đổi lại hình ảnh
              child: card("assets/goods-receipt.png", "Goods Receipt"),
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
                Navigator.pushNamed(context, Routes.goodsIssueInven);
              },
              // thay đổi lại hình ảnh
              child: card("assets/goods-issue.png", "Goods Issue"),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, Routes.inventoryCounting);
              },
              // thay đổi lại hình ảnh
              child:
                  card("assets/inventory-counting.png", "Inventory Counting"),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, Routes.inventoryTransfer);
              },
              // thay đổi lại hình ảnh
              child:
                  card("assets/inventory-transfer.png", "Inventory Transfer"),
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
