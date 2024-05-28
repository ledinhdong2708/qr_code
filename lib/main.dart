import 'package:flutter/material.dart';
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

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: Routes.generateRoute,
      routes: {
        Routes.login: (context) => const Login(),
        Routes.home: (context) => const Home(),
        Routes.userDetail: (context) => const UserDetail(),
        // purchasing
        Routes.purchasing: (context) => const Purchasing(),
        Routes.grpoDetail: (context) => const GrpoDetail(),
        Routes.grpoLabels: (context) => const GrpoLabels(),
        Routes.goodsReturn: (context) => const GoodsReturn(),
        Routes.goodsReturnDetail: (context) => const GoodsReturnDetail(),
        Routes.apCreditMemo: (context) => const ApCreditMemo(),
        Routes.apCreditMemoDetail: (context) => const ApCreditmemoDetail(),
        //sales
        Routes.sales: (context) => const Sales(),
        Routes.delivery: (context) => const Delivery(),
        Routes.deliveryDetail: (context) => const DeliveryDetail(),
        Routes.returns: (context) => const Return(),
        Routes.returnDetail: (context) => const ReturnDetail(),
        Routes.returnLabels: (context) => const ReturnLabels(),
        Routes.arCreditMemo: (context) => const ARCreditMemo(),
        Routes.arCreditMemoDetail: (context) => const ARCreditmemoDetail(),
        Routes.arCreditMemoLabels: (context) => const ArCreditmemoLabel(),
        //inventory
        Routes.inventory: (context) => const Inventory(),
        Routes.goodsReceiptInven: (context) => const GoodsReceiptIven(),
        Routes.goodsReceiptLabelsInven: (context) =>
            const GoodsReceiptLabelsIven(),
        Routes.goodsIssueInven: (context) => const GoodsIssueInven(),
        Routes.inventoryCounting: (context) => const InventoryCounting(),
        Routes.inventoryTransfer: (context) => const InventoryTrans(),
        Routes.inventoryTransferLabels: (context) =>
            const InventoryTransferLabels(),
        //production
        Routes.production: (context) => const Production(),
        Routes.ifp: (context) => const Ifp(),
        Routes.rfp: (context) => const Rfp(),
        Routes.rfpLabels: (context) => const RfpLabel(),
        Routes.goodsIssue: (context) => const GoodsIssue(),
        Routes.goodsReceipt: (context) => const GoodsReceipt(),
      },
    );
  }
}
