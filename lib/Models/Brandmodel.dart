class Brandmodel {
  String id;
  String bName;
  String brandCat;
  String brandDis;
  String imgLink;

  Brandmodel({this.id, this.bName, this.brandCat, this.brandDis, this.imgLink});

  Brandmodel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bName = json['b_name'];
    brandCat = json['brand_cat'];
    brandDis = json['brand_dis'];
    imgLink = json['img_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['b_name'] = this.bName;
    data['brand_cat'] = this.brandCat;
    data['brand_dis'] = this.brandDis;
    data['img_link'] = this.imgLink;
    return data;
  }
}