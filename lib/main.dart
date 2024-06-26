import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qr_code/component/loading.dart';
import 'package:qr_code/page/inventory/goodsissue/goods_issue.dart';
import 'package:qr_code/page/inventory/goodsreceipt/goods_receipt.dart';
import 'package:qr_code/page/inventory/goodsreceipt/goods_receipt_labels.dart';
import 'package:qr_code/page/inventory/inventory.dart';
import 'package:qr_code/page/inventory/inventorycounting/inventory_counting.dart';
import 'package:qr_code/page/inventory/inventorycounting/inventory_counting_labels.dart';
import 'package:qr_code/page/inventory/inventorytransfer/inventory_transfer.dart';
import 'package:qr_code/page/production/goodsissue/goods_issue.dart';
import 'package:qr_code/page/production/goodsreceipt/goods_receipt.dart';
import 'package:qr_code/page/production/ifp/ifp.dart';
import 'package:qr_code/page/production/production.dart';
import 'package:qr_code/page/production/rfp/rfp.dart';
import 'package:qr_code/page/production/rfp/rfp_labels.dart';
import 'package:qr_code/page/purchasin/creadit_memo/ap_creditmemo_detail.dart';
import 'package:qr_code/page/purchasin/goods_receipt/grpo.dart';
import 'package:qr_code/page/purchasin/goods_receipt/grpo_detail.dart';
import 'package:qr_code/page/purchasin/goods_receipt/grpo_label.dart';
import 'package:qr_code/page/purchasin/goods_return/goods_return.dart';
import 'package:qr_code/page/purchasin/goods_return/goods_return_detail.dart';
import 'package:qr_code/page/purchasin/purchasing.dart';
import 'package:qr_code/page/home.dart';
import 'package:qr_code/page/login.dart';
import 'package:qr_code/page/purchasin/creadit_memo/ap_creditmemo.dart';
import 'package:qr_code/page/sales/creditmemo/ar_creditmemo.dart';
import 'package:qr_code/page/sales/creditmemo/ar_creditmemo_detail.dart';
import 'package:qr_code/page/sales/creditmemo/ar_creditmemo_label.dart';
import 'package:qr_code/page/sales/delivery/delivery.dart';
import 'package:qr_code/page/sales/delivery/delivery_detail.dart';
import 'package:qr_code/page/sales/returns/return.dart';
import 'package:qr_code/page/sales/returns/returndetail.dart';
import 'package:qr_code/page/sales/returns/returnlabel.dart';
import 'package:qr_code/page/sales/sales.dart';
import 'package:qr_code/page/user_detail.dart';
import 'package:qr_code/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(), // Wrap your app
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<String?> _tokenFuture;
  @override
  void initState() {
    super.initState();
    _tokenFuture = _getToken();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _tokenFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CustomLoading();
        } else {
          final token = snapshot.data;
          return MaterialApp(
            // ignore: deprecated_member_use
            useInheritedMediaQuery: true,
            locale: DevicePreview.locale(context),
            builder: DevicePreview.appBuilder,
            debugShowCheckedModeBanner: false,
            initialRoute: token != null ? Routes.home : Routes.login,
            onGenerateRoute: Routes.generateRoute,
            routes: {
              Routes.login: (context) => const Login(),
              Routes.home: (context) => const Home(),
              Routes.userDetail: (context) => const UserDetail(),
              // purchasing
              Routes.purchasing: (context) => const Purchasing(),
              Routes.grpoDetail: (context) => const GrpoDetail(),
              Routes.grpoLabels: (context) => const GrpoLabels(),
              Routes.goodsReturnDetail: (context) => const GoodsReturnDetail(),
              Routes.apCreditMemoDetail: (context) =>
                  const ApCreditmemoDetail(),
              //sales
              Routes.sales: (context) => const Sales(),
              Routes.deliveryDetail: (context) => const DeliveryDetail(),
              Routes.returnDetail: (context) => const ReturnDetail(),
              Routes.returnLabels: (context) => const ReturnLabels(),
              Routes.arCreditMemoDetail: (context) =>
                  const ARCreditmemoDetail(),
              Routes.arCreditMemoLabels: (context) => const ArCreditmemoLabel(),
              //inventory
              Routes.inventory: (context) => const Inventory(),
              Routes.goodsReceiptInven: (context) => const GoodsReceiptIven(),
              Routes.goodsReceiptLabelsInven: (context) =>
                  const GoodsReceiptLabelsIven(),
              Routes.goodsIssueInven: (context) => const GoodsIssueInven(),
              Routes.inventoryTransferLabels: (context) =>
                  const InventoryTransferLabels(),
              //production
              Routes.production: (context) => const Production(),
              Routes.rfpLabels: (context) => const RfpLabel(),
              Routes.goodsIssue: (context) => const GoodsIssue(),
              Routes.goodsReceipt: (context) => const GoodsReceipt(),
            },
          );
        }
      },
    );
  }
}
