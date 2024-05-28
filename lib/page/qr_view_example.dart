import 'package:flutter/material.dart';
import 'package:qr_code/page/purchasin/goods_receipt/grpo.dart';
import 'package:qr_code/page/result_screen.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRViewExample extends StatefulWidget {
  // tạo mã định danh cho trang
  final String pageIdentifier;
  const QRViewExample({super.key, required this.pageIdentifier});

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Text('Scan result: ${result?.code}'),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.take(1).listen((scanData) {
      if (scanData != null) {
        controller.pauseCamera();

        setState(() {
          result = scanData;
        });

        navigateToPage(widget.pageIdentifier, scanData.code!);
      }
    });
  }

  void navigateToPage(String pageIdentifier, String qrData) {
    if (pageIdentifier == 'GRPO') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Grpo(qrData: qrData)),
      );
    }
    // Thêm các điều kiện cho các trang khác nếu cần
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
