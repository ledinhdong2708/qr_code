import 'package:flutter/material.dart';
import 'package:qr_code/page/inventory/goodsreceipt/goods_receipt.dart';
import 'package:qr_code/page/inventory/inventorycounting/inventory_counting.dart';
import 'package:qr_code/page/inventory/inventorytransfer/inventory_transfer.dart';
import 'package:qr_code/page/production/ifp/ifp.dart';
import 'package:qr_code/page/production/rfp/rfp.dart';
import 'package:qr_code/page/purchasin/creadit_memo/ap_creditmemo.dart';
import 'package:qr_code/page/purchasin/goods_receipt/grpo.dart';
import 'package:qr_code/page/purchasin/goods_return/goods_return.dart';
import 'package:qr_code/page/purchasin/goods_return/goods_return_detail_item.dart';
import 'package:qr_code/page/result_screen.dart';
import 'package:qr_code/page/sales/delivery/delivery.dart';
import 'package:qr_code/page/sales/returns/return.dart';
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
    } else if (pageIdentifier == 'GoodsReturn') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GoodsReturn(qrData: qrData)),
      );
    }
    else if (pageIdentifier == 'GoodReturnDetailItems') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GoodReturnDetailItems(qrData: qrData)),
      );
    }
    else if (pageIdentifier == 'APCreditMemo') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ApCreditMemo(qrData: qrData)),
      );
    } else if (pageIdentifier == 'Delivery') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Delivery(qrData: qrData)),
      );
    } else if (pageIdentifier == 'Return') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Return(qrData: qrData)),
      );
    } else if (pageIdentifier == 'ARCreditMemo') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Return(qrData: qrData)),
      );
    } else if (pageIdentifier == 'ifp') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Ifp(qrData: qrData)),
      );
    } else if (pageIdentifier == 'rfp') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Rfp(qrData: qrData)),
      );
    } else if (pageIdentifier == 'IventoryCounting') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => InventoryCounting(qrData: qrData)),
      );
    } else if (pageIdentifier == 'IventoryTrans') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => InventoryTrans(qrData: qrData)),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
