import 'package:flutter/material.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/page/purchasin/creadit_memo/ap_creditmemo.dart';
import 'package:qr_code/page/purchasin/goods_receipt/grpo.dart';
import 'package:qr_code/page/purchasin/goods_return/goods_return.dart';

class Purchasing extends StatelessWidget {
  const Purchasing({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderApp(title: "Purchasing A/P"),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        color: bgColor,
        child: GridView.count(
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Grpo(qrData: "42")),
                  // builder: (context) => const QRViewExample(
                  //       pageIdentifier: 'GRPO',
                  //     )),
                );
              },
              child: card("assets/receipt.png", "Goods Receipt PO"),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      // builder: (context) => const QRViewExample(
                      //       pageIdentifier: 'GoodsReturn',
                      //     )),
                      builder: (context) => const GoodsReturn(qrData: "17")),
                );
              },
              child: card("assets/return.png", "Goods Return"),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      //     builder: (context) => const QRViewExample(
                      //           pageIdentifier: 'APCreditMemo',
                      //         )),
                      builder: (context) => const ApCreditMemo(qrData: "21")),
                );
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
