import 'package:flutter/material.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/page/purchasin/goods_receipt/grpo.dart';
import 'package:qr_code/page/qr_view_example.dart';

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
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => Grpo(qrData: "1")),
                //   MaterialPageRoute(
                //       builder: (context) => const QRViewExample(
                //             pageIdentifier: 'GRPO',
                //           )),
                // );
                // To testing api
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Grpo(qrData: "36")),
                );
              },
              child: card("assets/receipt.png", "Goods Receipt PO"),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const QRViewExample(
                            pageIdentifier: 'GoodsReturn',
                          )),
                );
              },
              child: card("assets/return.png", "Goods Return"),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const QRViewExample(
                            pageIdentifier: 'APCreditMemo',
                          )),
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
