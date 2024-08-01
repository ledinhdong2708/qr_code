import 'package:flutter/material.dart';
import 'package:qr_code/page/inventory/goodsreceipt/goods_receipt.dart';
import 'package:qr_code/page/inventory/inventorycounting/inventory_counting.dart';
import 'package:qr_code/page/inventory/inventorytransfer/inventory_transfer.dart';
import 'package:qr_code/page/production/ifp/ifp.dart';
import 'package:qr_code/page/production/rfp/rfp.dart';
import 'package:qr_code/page/purchasin/creadit_memo/ap_creditmemo.dart';
import 'package:qr_code/page/purchasin/goods_receipt/grpo.dart';
import 'package:qr_code/page/purchasin/goods_receipt/grpo_detail.dart';
import 'package:qr_code/page/purchasin/goods_return/goods_return.dart';
import 'package:qr_code/page/sales/creditmemo/ar_creditmemo.dart';
import 'package:qr_code/page/sales/delivery/delivery.dart';
import 'package:qr_code/page/sales/returns/sales_return.dart';

class Routes {
  static const String login = '/';
  static const String home = '/home';
  // user detail
  static const String userDetail = '/home/user_detail';
  // purchasing
  static const String purchasing = '/home/purchasing';
  static const String grpo = '/home/purchasing/grpo';
  static const String grpoDetail = '/home/purchasing/grpo/grpo_detail';
  static const String grpoAddNewDetailItems =
      '/home/purchasing/grpo/grpo_detail/grpo_add_new_detail_items';
  static const String grpoDetailItems =
      '/home/purchasing/grpo/grpo_detail/grpo_detail_items';
  static const String goodsReturn = '/home/purchasing/return/goods_return';
  static const String goodsReturnDetail =
      '/home/purchasing/return/goods_return/goods_return_detail';
  static const String goodsReturnLabel =
      '/home/purchasing/return/goods_return/goods_return_detail/goods_return_label';
  static const String apCreditMemo =
      '/home/purchasing/credit_memo/ap_credit_memo';
  static const String apCreditMemoDetail =
      '/home/purchasing/credit_memo/ap_credit_memo/ap_credit_memo_detail';
  // sales
  static const String sales = '/home/sales';
  static const String delivery = '/home/sales/delivery';
  static const String deliveryDetail = '/home/sales/delivery/delivery_detail';
  static const String returns = '/home/sales/return';
  static const String returnDetail = '/home/sales/return/return_detail';
  static const String returnLabels =
      '/home/sales/return/return_detail/return_labels';
  static const String arCreditMemo = '/home/sales/ar_credit_memo';
  static const String arCreditMemoDetail =
      '/home/sales/ar_credit_memo/ar_credit_memo_detail';
  static const String arCreditMemoLabels =
      '/home/sales/ar_credit_memo/ar_credit_memo_labels';
  // inventory
  static const String inventory = '/home/inventory';
  static const String goodsReceiptInven = '/home/inventory/goods_receipt';
  static const String goodsReceiptLabelsInven =
      '/home/inventory/goods_receipt/goods_receipt_labels';
  static const String goodsIssueInven = '/home/inventory/goods_issue';
  static const String inventoryCounting = '/home/inventory/inventory_counting';
  static const String inventoryTransfer = '/home/inventory/inventory_transfer';
  static const String inventoryTransferLabels =
      '/home/inventory/inventory_transfer/inventory_transfer_label';
  // prodcution
  static const String production = '/home/production';
  static const String ifp = '/home/production/ifp';
  static const String rfp = '/home/production/rfp';
  static const String rfpLabels = '/home/production/rfp/rfp_labels';
  static const String goodsReceipt = '/home/production/goods_receipt';
  static const String goodsIssue = '/home/production/goods_issue';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      //grpo
      case grpo:
        final qrData = settings.arguments as String; // Lấy qrData từ arguments
        return MaterialPageRoute(
          builder: (context) => Grpo(
            qrData: qrData,
          ),
        );
      case goodsReturn:
        final qrData = settings.arguments as String; // Lấy qrData từ arguments
        return MaterialPageRoute(
          builder: (context) => GoodsReturn(qrData: qrData),
        );
      case apCreditMemo:
        final qrData = settings.arguments as String; // Lấy qrData từ arguments
        return MaterialPageRoute(
          builder: (context) => ApCreditMemo(qrData: qrData),
        );
      // sales
      case delivery:
        final qrData = settings.arguments as String; // Lấy qrData từ arguments
        return MaterialPageRoute(
          builder: (context) => Delivery(qrData: qrData),
        );
      case returns:
        final qrData = settings.arguments as String; // Lấy qrData từ arguments
        return MaterialPageRoute(
          builder: (context) => SalesReturn(qrData: qrData),
        );
      case arCreditMemo:
        final qrData = settings.arguments as String; // Lấy qrData từ arguments
        return MaterialPageRoute(
          builder: (context) => ARCreditMemo(qrData: qrData),
        );
      //production
      case ifp:
        final qrData = settings.arguments as String; // Lấy qrData từ arguments
        return MaterialPageRoute(
          builder: (context) => Ifp(qrData: qrData),
        );
      case rfp:
        final qrData = settings.arguments as String; // Lấy qrData từ arguments
        return MaterialPageRoute(
          builder: (context) => Rfp(qrData: qrData),
        );
      //inventory
      case inventoryCounting:
        final qrData = settings.arguments as String; // Lấy qrData từ arguments
        return MaterialPageRoute(
          builder: (context) => InventoryCounting(qrData: qrData),
        );
      case inventoryTransfer:
        final qrData = settings.arguments as String; // Lấy qrData từ arguments
        return MaterialPageRoute(
          builder: (context) => InventoryTransfer(qrData: qrData),
        );
      // Định nghĩa các route khác tại đây
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
