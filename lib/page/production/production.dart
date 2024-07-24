import 'package:flutter/material.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/page/production/ifp/ifp.dart';
import 'package:qr_code/page/qr_view_example.dart';
import 'package:qr_code/routes/routes.dart';

class Production extends StatelessWidget {
  const Production({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderApp(title: "Production"),
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
                //       builder: (context) => const QRViewExample(
                //             pageIdentifier: 'ifp',
                //           )),
                // );
                //Test api
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Ifp(qrData: "1")),
                );
              },
              // thay đổi lại hình ảnh
              child: card("assets/ifp.png", "Issue for Production"),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const QRViewExample(
                            pageIdentifier: 'rfp',
                          )),
                );
              },
              // thay đổi lại hình ảnh
              child: card("assets/rfp.png", "Receipt from Production"),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, Routes.goodsReceipt);
              },
              // thay đổi lại hình ảnh
              child: card("assets/goods-receipt.png", "Goods Receipt"),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, Routes.goodsIssue);
              },
              // thay đổi lại hình ảnh
              child: card("assets/goods-issue.png", "Goods Issue"),
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
