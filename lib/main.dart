import 'package:flutter/material.dart';
import 'package:qr_code/page/inventory/inventory.dart';
import 'package:qr_code/page/production/production.dart';
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
import 'package:qr_code/page/sales/sales.dart';
import 'package:qr_code/page/user_detail.dart';

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
      routes: {
        '/': (context) => const Login(),
        '/home': (context) => const Home(),
        '/home/user_detail': (context) => const UserDetail(),
        // purchasing
        '/home/purchasing': (context) => const Purchasing(),
        //goods receipt
        '/home/purchasing/goodsreceiptpo/grpo': (context) => const Grpo(),
        '/home/purchasing/goodsreceiptpo/grpo/grpo_detail': (context) =>
            const GrpoDetail(),
        '/home/purchasing/goodsreceiptpo/grpo/grpo_detail/grpo_labels':
            (context) => const GrpoLabels(),
        //goods return
        '/home/purchasing/return/goods_return': (context) =>
            const GoodsReturn(),
        '/home/purchasing/return/goods_return/goods_return_detail': (context) =>
            const GoodsReturnDetail(),
        //ap credit memo
        '/home/purchasing/credit_memo/ap_credit_memo': (context) =>
            const ApCreditMemo(),
        '/home/purchasing/credit_memo/ap_credit_memo/ap_credit_memo_detail':
            (context) => const ApCreditmemoDetail(),
        // sales
        '/home/sales': (context) => const Sales(),
        // inventory
        '/home/inventory': (context) => const Inventory(),
        // production
        '/home/production': (context) => const Production(),
      },
    );
  }
}
