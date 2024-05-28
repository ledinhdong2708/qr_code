import 'package:flutter/material.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/page/qr_view_example.dart';
import 'package:qr_code/routes/routes.dart';

class Sales extends StatelessWidget {
  const Sales({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderApp(title: "Sales A/P"),
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
                Navigator.pushNamed(context, Routes.delivery);
              },
              child: card("assets/delivery.png", "Delivery"),
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
                Navigator.pushNamed(context, Routes.returns);
              },
              child: card("assets/return.png", "Return"),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, Routes.arCreditMemo);
              },
              child: card("assets/credit-memo.png", "A/R Credit Memo"),
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
