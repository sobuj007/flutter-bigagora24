import 'dart:convert';

import 'package:bigagora24/Models/CartInfoModel.dart';
import 'package:bigagora24/Models/ChargeModel.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CartInfo extends StatefulWidget {
  final String cname, mail, userid;
  CartInfo({Key key, this.cname, this.mail, this.userid}) : super(key: key);
  @override
  _CartInfoState createState() => _CartInfoState();
}

class _CartInfoState extends State<CartInfo> {
  String mail;
  String cname;
  String userid;
  String mobileforbkash;
  double sums = 0;
  int taps = 0;
  StateSetter _setState;
  bool _isChecked = false;
  TextEditingController _shoppingaddress = new TextEditingController();
  TextEditingController _mobile = new TextEditingController();
  TextEditingController _bkashnumber = new TextEditingController();
  TextEditingController _bkashtran = new TextEditingController();
  Future<List<CartInfoModel>> _getInfo() async {
    String url = "https://bigagora24.com/apps/getCartinfo.php";
    var respons = await http.post(url, body: {
      'cartname': cname,
      'email': mail,
    });
    var jsonresponse = json.decode(respons.body);
    print(jsonresponse);
    List<CartInfoModel> _infos = [];
    try {
      for (var i in jsonresponse['usercarts']) {
        CartInfoModel data = CartInfoModel(
          cartName: i['cart_name'].toString(),
          productId: i['product_id'].toString(),
          productName: i['product_name'].toString(),
          amount: i['amount'].toString(),
          quantity: i['quantity'].toString(),
          entryby: i['entryby'].toString(),
        );
        _infos.add(data);
      }
    } catch (e) {
      print(e);
    }
    return _infos;
  }

  Future<List<ChargeModel>> _getCharge() async {
    String url = "https://bigagora24.com/apps/getDelcharge.php";
    var respons = await http.get(url);
    var jsonresponse = json.decode(respons.body);
    print(jsonresponse);
    List<ChargeModel> _charges = [];
    try {
      for (var i in jsonresponse['charges']) {
        ChargeModel data = ChargeModel(
            city: i['city'].toString(),
            outofcity: i['outofcity'].toString(),
            delmobile: i['delmobile'].toString());
        _charges.add(data);
      }
    } catch (e) {
      print(e);
    }
    return _charges;
  }

  @override
  Widget build(BuildContext context) {
    mail = widget.mail.toString();
    cname = widget.cname.toString();
    userid = widget.userid.toString();

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          // color: Colors.amber[50],
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    "Cart :\t" + cname,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),

                  // Text(mail,  style: TextStyle(
                  //       fontFamily: 'Roboto',
                  //       fontSize: 18,
                  //       fontWeight: FontWeight.bold),),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height * .08,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Product Name",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.clip,
                    ),
                    Text(
                      "Quantity",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.clip,
                    ),
                    Text(
                      "Price",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.clip,
                    ),
                  ],
                ),
              ),
              Container(
                  height: MediaQuery.of(context).size.height * .70,
                  width: MediaQuery.of(context).size.width,
                  //  color: Colors.blueAccent[100],
                  child: _info(context)),
              _total(),
              _but(),
            ],
          ),
        ),
      )),
    );
  }

  Widget _but() {
    if (taps == 1) {
      return CupertinoButton(
          child: Text("CheckOut"),
          color: Colors.blueAccent,
          onPressed: () {
            //_shipingaddress();
            _dia();
          });
    } else {
      return Text("");
    }
  }

  FutureBuilder<List<CartInfoModel>> _info(BuildContext context) {
    return FutureBuilder(
        future: _getInfo(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return CupertinoActivityIndicator(
              radius: 30,
            );
          } else {
            if (snapshot.data.length <= 0) {
              return Center(
                child: Text(
                  "Cart is Empty",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            } else {
              return Container(
                height: MediaQuery.of(context).size.height * .85,
                width: MediaQuery.of(context).size.width,
                // color: Colors.amberAccent[50],
                child: Column(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * .65,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          double f =
                              double.parse(snapshot.data[index].quantity);
                          double f2 = double.parse(snapshot.data[index].amount);
                          double s = f * f2;
                          sums = sums + s;

                          return GestureDetector(
                                                      child: Card(
                              elevation: 5,
                              child: Container(
                                height: MediaQuery.of(context).size.height * .08,
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "${snapshot.data[index].productName}",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.clip,
                                    ),
                                    Text(
                                      "${snapshot.data[index].quantity}",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.clip,
                                    ),
                                    Text(
                                      "${snapshot.data[index].amount}",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.clip,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: (){
                               
                                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Do you want Delete this Product",style: TextStyle(fontSize: 14),),
                    actions: <Widget>[
                      CupertinoButton(
                          child: Text("Yes"),
                          onPressed: () {
                            Navigator.pop(context,this);
                            String proid=snapshot.data[index].productId;
                            removecartdata(cname, mail, proid);
                          }),
                      CupertinoButton(
                          child: Text("No"),
                          onPressed: () {
                            Navigator.pop(context);
                          })
                    ],
                  ),
                );
            //    Navigator.pop(context);
               
// 
// 
//                               
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          }
        });
  }

  var col = Colors.black;
  String total = "Tap to show total";
  String totalprice = "0.0";
  Widget _total() {
    return Container(
      height: MediaQuery.of(context).size.height * .08,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            child: Text(
              total,
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: col),
              overflow: TextOverflow.clip,
            ),
            onTap: () {
              if (taps == 0) {
                setState(() {
                  // total=sums.toString();
                  total = "Total Price";
                  totalprice = "${sums.toString()}";
                  taps = 1;
                  _dia2();
                  col = Colors.orangeAccent;
                });
              }
            },
          ),
          Text(
            "${totalprice.toString()}" + "/Tk",
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                fontWeight: FontWeight.bold),
            overflow: TextOverflow.clip,
          ),
        ],
      ),
    );
  }

  // Widget _tramcon() {
  // return Container(
  //   height: MediaQuery.of(context).size.height*.10,
  //   width: MediaQuery.of(context).size.width,
  //   child: ,
  // );
  // }
  void _dia2() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              actions: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "N:B:Delivery Charge Will be Include",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.redAccent),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                    height: MediaQuery.of(context).size.height * .18,
                    width: MediaQuery.of(context).size.width,
                    child: _charges(context)),
              ],
            ));
  }

  void _dia() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  _setState = setState;

                  return Container(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height * .05,
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              "One More Step",
                              style: TextStyle(
                                  fontFamily: 'ROboto',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: MediaQuery.of(context).size.height * .15,
                            width: MediaQuery.of(context).size.width,
                            child: TextField(
                              autofocus: false,
                              maxLines: 5,
                              controller: _shoppingaddress,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  border: OutlineInputBorder(),
                                  hintText: 'Shipping Address',
                                  labelStyle: TextStyle(fontSize: 18),
                                  fillColor: Colors.blueAccent),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: MediaQuery.of(context).size.height * .08,
                            width: MediaQuery.of(context).size.width,
                            child: TextField(
                              autofocus: false,
                              maxLength: 11,
                              controller: _mobile,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  border: OutlineInputBorder(),
                                  hintText: 'Reciever Mobile Number',
                                  labelStyle: TextStyle(fontSize: 18),
                                  fillColor: Colors.blueAccent),
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: <Widget>[
                              Checkbox(
                                  value: _isChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      _isChecked = value;
                                      _bkashnumber.text = null;
                                      _bkashtran.text = null;
                                    });
                                  }),
                              Text("Cash On Delivary")
                            ],
                          ),
                          Text(
                            "NO:" + mobileforbkash,
                            style: TextStyle(
                                fontFamily: 'ROboto',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.red),
                          ),
                          SizedBox(height: 10),
                          _botpart(),
                          CupertinoButton(
                              pressedOpacity: 0.5,
                              child: Text("CheckOut Order"),
                              color: Colors.blueAccent,
                              onPressed: () {
                                //_shipingaddress();
                                // String mails=mail.toString();
                                // _dia();
                                Navigator.pop(context,this);
                                _insertOrder();
                                
                              })
                        ],
                      ),
                    ),
                  );
                },
              ),
            ));
  }

  Widget _botpart() {
    if (_isChecked == false) {
      return Container(
        height: MediaQuery.of(context).size.height * .18,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * .08,
              width: MediaQuery.of(context).size.width,
              child: TextField(
                autofocus: false,
                maxLength: 11,
                controller: _bkashnumber,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    border: OutlineInputBorder(),
                    hintText: 'Bkash/Nogad Number',
                    labelStyle: TextStyle(fontSize: 18),
                    fillColor: Colors.blueAccent),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: MediaQuery.of(context).size.height * .08,
              width: MediaQuery.of(context).size.width,
              child: TextField(
                autofocus: false,
                controller: _bkashtran,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    border: OutlineInputBorder(),
                    hintText: 'Transition ID',
                    labelStyle: TextStyle(fontSize: 18),
                    fillColor: Colors.blueAccent),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        height: MediaQuery.of(context).size.height * .0,
        width: MediaQuery.of(context).size.width,
        child: Center(
            // child: Text("Delivery In Rajshahi City Corporation 40 tk only"),
            // child: _charges(context),
            ),
      );
    }
  }

  FutureBuilder<List<ChargeModel>> _charges(BuildContext context) {
    return FutureBuilder(
        future: _getCharge(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return CupertinoActivityIndicator(
              radius: 30,
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  mobileforbkash = snapshot.data[index].delmobile.toString();
                  return Card(
                    child: Container(
                      height: MediaQuery.of(context).size.height * .18,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: <Widget>[
                          Text("${snapshot.data[index].city}",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w600)),
                          SizedBox(height: 15),
                          Text(
                            "${snapshot.data[index].outofcity}",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }
        });
  }
void dialogbox({BuildContext context, Widget child}) {
    showCupertinoDialog(
        context: context, builder: (BuildContext context) => child);
  }

  Future<void> _insertOrder() async {
    String url = "https://bigagora24.com/apps/setCheckout.php";
    if (_isChecked == true) {
      //
      dialogbox(
      context: context,
      child: CupertinoAlertDialog(
        content: CupertinoActivityIndicator(),
      ),
    );
      print("true");
      if (_shoppingaddress != null && _mobile != null) {
        var response = await http.post(url, body: {
          'email': mail,
          'user_id': userid,
          'cart_name': cname,
          'user_mobile': _mobile.text,
          'order_status': 'null',
          'shipping_address': _shoppingaddress.text,
          'bkash_number': 'null',
          'bkash_transection_id': 'null',
        });
        print(response);
        var jsonresponse = json.decode(response.body);
          if(jsonresponse['error']==true){
            Navigator.pop(context);
           Navigator.of(context).pushNamedAndRemoveUntil('/HomePage', (Route<dynamic> route) => false);
          }

      }
    } else {
      dialogbox(
      context: context,
      child: CupertinoAlertDialog(
        content: CupertinoActivityIndicator(),
      ),
    );
      var response = await http.post(url, body: {
        'email': mail,
        'user_id': userid,
        'cart_name': cname,
        'user_mobile': _mobile.text,
        'order_status': 'null',
        'shipping_address': _shoppingaddress.text,
        'bkash_number': _bkashnumber.text,
        'bkash_transection_id': _bkashtran.text,
      });
     // var jsonresponse = json.decode(response.body);
        var jsonresponse = json.decode(response.body);
          if(jsonresponse['error']==true){
            Navigator.pop(context,this);
          
          }

    }
    
  }

  void removecartdata(String cartname, String email, String productid) async {
    var url = "https://bigagora24.com/apps/deleteCartproduct.php";
    var respons = await http.post(url, body: {
      'cart_name': cartname.toString(),
      'email': email.toString(),
      'product_id': productid.toString(),
    });
    var jsonrespons = json.decode(respons.body);
    print(jsonrespons);
  if (!jsonrespons['error']) {
   Navigator.pop(context,this);
    Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => CartInfo(
                                cname: cname, mail: mail, userid: userid),
                          ));
  }
  }
}
