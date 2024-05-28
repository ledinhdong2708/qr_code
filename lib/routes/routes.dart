class Routes {
  static const String login = '/';
  static const String home = '/home';
  // user detail
  static const String userDetail = '/home/user_detail';
  // purchasing
  static const String purchasing = '/home/purchasing';
  static const String grpo = '/home/purchasing/grpo';
  static const String grpoDetail = '/home/purchasing/grpo/grpo_detail';
  static const String grpoLabels =
      '/home/purchasing/grpo/grpo_detail/grpo_labels';
  static const String goodsReturn = '/home/purchasing/return/goods_return';
  static const String goodsReturnDetail =
      '/home/purchasing/return/goods_return/goods_return_detail';
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
}
