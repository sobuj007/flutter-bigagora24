class Cart2Model {
  String cartName;

  Cart2Model({this.cartName});

  Cart2Model.fromJson(Map<String, dynamic> json) {
    cartName = json['cart_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cart_name'] = this.cartName;
    return data;
  }
}