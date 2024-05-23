import 'package:flutter/material.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/page/qr_view_example.dart';

class Purchasing extends StatelessWidget {
  const Purchasing({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Purchasing A/P"),
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
                    context, '/home/purchasing/goodsreceiptpo/grpo');
              },
              child: card("assets/receipt.png", "Goods Receipt PO"),
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
                    context, '/home/purchasing/return/goods_return');
              },
              child: card("assets/return.png", "Goods Return"),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(
                    context, '/home/purchasing/credit_memo/ap_credit_memo');
              },
              child: card("assets/credit-memo.png", "A/P Credit Memo"),
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
