class CartInfoModel {
  String cartName;
  String productId;
  String productName;
  String amount;
  String quantity;
  String entryby;

  CartInfoModel(
      {this.cartName,
      this.productId,
      this.productName,
      this.amount,
      this.quantity,
      this.entryby});

  CartInfoModel.fromJson(Map<String, dynamic> json) {
    cartName = json['cart_name'];
    productId = json['product_id'];
    productName = json['product_name'];
    amount = json['amount'];
    quantity = json['quantity'];
    entryby = json['entryby'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cart_name'] = this.cartName;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['amount'] = this.amount;
    data['quantity'] = this.quantity;
    data['entryby'] = this.entryby;
    return data;
  }
}