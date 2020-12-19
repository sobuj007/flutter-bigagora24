import 'dart:convert';

import 'package:bigagora24/Models/CartInfoModel.dart';
import 'package:bigagora24/Models/ChargeModel.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CartInfoCheck extends StatefulWidget {
  final String cname, mail,userid;
  CartInfoCheck({Key key, this.cname, this.mail,this.userid}) : super(key: key);
  @override
  _CartInfoCheckState createState() => _CartInfoCheckState();
}

class _CartInfoCheckState extends State<CartInfoCheck> {
  String mail;
  String cname;
  String userid;
  String mobileforbkash;
  double sums = 0;
  int taps = 0;
  StateSetter _setState;
  bool _isChecked = false;
  
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
Widget _but(){

    return Text("Delivary Charge will Add");

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

                          return Card(
                              elevation: 5,
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * .08,
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
                              ));
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

  

  
}
