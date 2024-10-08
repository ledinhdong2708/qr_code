import 'package:flutter/material.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/page/qr_view_example.dart';
import 'package:qr_code/page/sales/creditmemo/ar_creditmemo.dart';
import 'package:qr_code/page/sales/delivery/delivery.dart';
import 'package:qr_code/page/sales/returns/sales_return.dart';
import 'package:qr_code/routes/routes.dart';

class Sales extends StatelessWidget {
  const Sales({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderApp(title: "Sales - A/R"),
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
                //             pageIdentifier: 'Delivery',
                //           )),
                // );

                // To testing api
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Delivery(qrData: "25")),
                );
              },
              child: card("assets/delivery.png", "Delivery"),
            ),
            InkWell(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => const QRViewExample(
                //             pageIdentifier: 'SalesReturn',
                //           )),
                // );
                // To testing api
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SalesReturn(qrData: "8")),
                );
              },
              child: card("assets/return.png", "Return"),
            ),
            InkWell(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => const QRViewExample(
                //             pageIdentifier: 'ARCreditMemo',
                //           )),
                // );
                // To testing api
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ARCreditMemo(qrData: "8")),
                );
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
