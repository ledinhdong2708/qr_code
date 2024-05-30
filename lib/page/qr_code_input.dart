import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeForInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRCodeInputState();
}

class _QRCodeInputState extends State<QRCodeForInput> {
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
        // Điều này sẽ gửi kết quả của mã QR đến nơi cần xử lý, chẳng hạn như lớp cha.
        Navigator.pop(context, scanData.code);
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
