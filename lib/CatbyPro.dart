import 'dart:convert';

import 'package:bigagora24/Models/ProCatByModel.dart';
import 'package:bigagora24/Models/ProductModel.dart';
import 'package:bigagora24/Models/SubbyProModel.dart';
import 'package:bigagora24/Models/SubcatModel.dart';
import 'package:bigagora24/Models/Users.dart';
import 'package:bigagora24/NavBar.dart';
import 'package:bigagora24/NavBar2.dart';
import 'package:bigagora24/utils/SharedPrefManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;

class CatbyPro extends StatefulWidget {
  final String cName;
  CatbyPro({Key key, this.cName}) : super(key: key);
  @override
  _CatbyProState createState() => _CatbyProState();
}

class _CatbyProState extends State<CatbyPro> {
  String cname;
  String subname = "";
  StateSetter _setState;
  PageController _pageController1;
  Users user;
  var i = CupertinoIcons.heart;
  int a = 1;
  var _name = "";
  bool liked = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initProfile();
    SharedPrefManager.getcart().then(updatevalue);
  }

  final GlobalKey<ScaffoldState> _scf = new GlobalKey<ScaffoldState>();

  void updatevalue(String name) {
    setState(() {
      this._name = name;
    });
  }

  Future<void> initProfile() async {
    Users u = await SharedPrefManager.getUserProfile();
    _pageController1 = PageController(initialPage: 0);
    //    Products u1 = await SharedPrefManager.getProducts();
    setState(() {
      user = u;
    });
  }

  Future<List<ProCatByModel>> _getcatbypro() async {
    String url = "https://bigagora24.com/apps/getProductCatby.php?catname=";
    print(cname);
    var response = await http.post(url, body: {
      'catname': cname,
    });
    print(response.body);
    //var response=await http.get(url);
    var jsonrespons = json.decode(response.body);
    print(jsonrespons);
    List<ProCatByModel> _list = [];
    for (var i in jsonrespons['catproducts']) {
      try {
        ProCatByModel data = ProCatByModel(
          productId: i['product_id'].toString(),
          productName: i['product_name'].toString(),
          productPrice: i['product_price'].toString(),
          productCatId: i['product_cat_id'].toString(),
          productCatSub: i['product_cat_sub'].toString(),
          productCatBrand: i['product_cat_brand'].toString(),
          productDetails: i['product_details'].toString(),
          productImage: i['product_image'].toString(),
          productQun: i['product_qun'].toString(),
          discount: i['discount'].toString(),
          entryby: i['entryby'].toString(),
        );
        _list.add(data);
      } catch (e) {
        print(e);
      }
    }
    return _list;
  }

  Future<List<SubcatModel>> _getSub() async {
    String url = "https://bigagora24.com/apps/getSub_cat.php";
    var response = await http.post(url, body: {
      'cat_name': cname.toString(),
    });
    var jsonresponse = json.decode(response.body);
    List<SubcatModel> _info = [];
    try {
      for (var i in jsonresponse['sub_cats']) {
        SubcatModel data = SubcatModel(
          catId: i['cat_id'],
          catName: i['cat_name'].toString(),
          catSub: i['cat_sub'].toString(),
        );
        _info.add(data);
      }
    } catch (e) {
      print(e);
    }
    return _info;
  }

  Future<List<SubbyProModel>> _getPro() async {
    String url = "https://bigagora24.com/apps/getProductsubby.php";
    var response = await http.post(url, body: {
      'sub_cat': subname.toString(),
    });
    var jsonresponse = json.decode(response.body);
    List<SubbyProModel> _info = [];
    try {
      for (var i in jsonresponse['products']) {
        SubbyProModel data = SubbyProModel(
          productId: i['product_id'].toString(),
          productName: i['product_name'].toString(),
          productPrice: i['product_price'].toString(),
          productCatId: i['product_cat_id'].toString(),
          productCatSub: i['product_cat_sub'].toString(),
          productCatBrand: i['product_cat_brand'].toString(),
          productDetails: i['product_details'].toString(),
          productImage: i['product_image'].toString(),
          productQun: i['product_qun'].toString(),
          discount: i['discount '].toString(),
          entryby: i['entryby '].toString(),
        );
        _info.add(data);
      }
    } catch (e) {
      print(e);
    }
    return _info;
  }
Widget navtest() {
    print(user.role.toString());
    if (user.role.toString() == '3') {
      return NavBar();
    } else {
      return NavBar2();
    }
  }

  final GlobalKey<ScaffoldState> _scf1 = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
     cname = widget.cName.toString();
    //cname = "Food and Beverage";
    return Scaffold(
        drawer: navtest(),
        key: _scf1,
        body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height * .97,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * .97,
                width: MediaQuery.of(context).size.width,
                // color: Colors.amberAccent,
                child: Column(
                  children: <Widget>[
                    appBars(context),
                    Text(
                      cname,
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * .08,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.amberAccent,
                      child: _subCart(),
                    ),
                    Center(
                      child: Text(subname),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * .75,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.blueAccent[50],
                      child: _slider(),
                    )
                    //_subCart(),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget appBars(BuildContext context) {
    if (user.image.toString() == "null") {
      return Container(
        height: MediaQuery.of(context).size.height * .06,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              child: Icon(Icons.subject, size: 45, color: Color(0XFF16a085)),
              onTap: () {
                _scf1.currentState.openDrawer();
              },
            ),
            Text(
              user.fullname,
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold),
            ),
            CircleAvatar(
              child: Text(
                "B",
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold),
              ),
              maxRadius: 20,
              backgroundColor: Colors.green,
            ),
          ],
        ),
      );
    } else {
      return Container(
        height: MediaQuery.of(context).size.height * .06,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              child: Icon(Icons.subject, size: 45, color: Color(0XFF16a085)),
              onTap: () {
                _scf1.currentState.openDrawer();
              },
            ),
            Text(
              //  user.fullname,
              "",
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold),
            ),
            CircleAvatar(
              backgroundImage: NetworkImage(
                  "http://bigagora24.com/dashboard/uploads/profile/${user.image}"),
              maxRadius: 20,
              backgroundColor: Colors.green,
            ),
          ],
        ),
      );
    }
  }

  FutureBuilder<List<SubcatModel>> _subCart() {
    return FutureBuilder(
        future: _getSub(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CupertinoActivityIndicator(
                radius: 30,
              ),
            );
          } else {
            return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext contex, int index) {
                  return Container(
                    child: GestureDetector(
                      child: Card(
                        elevation: 10,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: MediaQuery.of(context).size.height * .06,
                              width: MediaQuery.of(context).size.width * .40,
                              // decoration: BoxDecoration(
                              //     image: DecorationImage(
                              //         image: NetworkImage(
                              //             "http://bigagora24.com/dashboard/uploads/brand/${snapshot1.data[index].imgLink}"),
                              //         fit: BoxFit.contain)),
                              child: Text(
                                "${snapshot.data[index].catSub}",
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            //Text("${snapshot.data[index].bName}"),
                            //Text("${snapshot1.data[index].brandCat}"),
                          ],
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          subname = snapshot.data[index].catSub.toString();
                          if (_pageController1.hasClients) {
                            _pageController1.animateToPage(1,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeIn);
                          }
                        });
                      },
                    ),
                  );
                });
          }
        });
  }

  FutureBuilder<List<SubbyProModel>> _subPro() {
    return FutureBuilder(
        future: _getPro(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CupertinoActivityIndicator(
                radius: 20,
              ),
            );
          } else {
            return StaggeredGridView.countBuilder(
              crossAxisCount: 4,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) => GestureDetector(
                child: new Container(
                    //  height: MediaQuery.of(context).size.height*.95,
                    margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Card(
                      elevation: 5,
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height * .18,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        "http://bigagora24.com/dashboard/uploads/${snapshot.data[index].productImage}"),
                                    fit: BoxFit.contain)),
                          ),
                          Column(
                            children: <Widget>[
                              SizedBox(
                                height: 2,
                              ),
                              Expanded(
                                flex: 0,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * .08,
                                  color: Colors.black12,
                                  child: Text(
                                    "${snapshot.data[index].productName}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                "Brand: ${snapshot.data[index].productCatBrand}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                  "Price: ${snapshot.data[index].productPrice}",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber)),
                            ],
                          )
                        ],
                      ),
                    )),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) => new AlertDialog(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          content: StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
                              _setState = setState;
                              return Container(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .30,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    "http://bigagora24.com/dashboard/uploads/${snapshot.data[index].productImage}"),
                                                fit: BoxFit.contain)),
                                        // child: Container(
                                        //   width: MediaQuery.of(context).size.width,
                                        //   height: MediaQuery.of(context).size.height*.005,
                                        //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: Color(0XFFecf0f1)),
                                        //   child: IconButton(icon: Icon(Icons.close), onPressed: (){
                                        //     Navigator.pop(context);
                                        //   }),
                                        // ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      _bottomButton(index, snapshot),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )));
                  setState(() {
                    a = 1;
                  });
                },
              ),
              staggeredTileBuilder: (int index) =>
                  new StaggeredTile.count(2, index.isEven ? 3 : 3),
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
            );
          }
        });
  }

  FutureBuilder<List<ProCatByModel>> productitems3(BuildContext context) {
    return FutureBuilder(
      future: _getcatbypro(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          return Center(
            child: CupertinoActivityIndicator(
              radius: 20,
            ),
          );
        } else {
          return StaggeredGridView.countBuilder(
            crossAxisCount: 4,
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) => GestureDetector(
              child: new Container(
                  //  height: MediaQuery.of(context).size.height*.95,
                  margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Card(
                    elevation: 5,
                                      child: Column(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height * .18,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "http://bigagora24.com/dashboard/uploads/${snapshot.data[index].productImage}"),
                                  fit: BoxFit.contain)),
                        ),
                        Column(
                          children: <Widget>[
                            SizedBox(
                              height: 2,
                            ),
                            Expanded(
                              flex: 0,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height * .08,
                                color: Colors.black12,
                                child: Text(
                                  "${snapshot.data[index].productName}",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Brand: ${snapshot.data[index].productCatBrand}",
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text("Price: ${snapshot.data[index].productPrice}",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber)),
                          ],
                        )
                      ],
                    ),
                  )),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (_) => new AlertDialog(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        content: StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            _setState = setState;
                            return Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .30,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  "http://bigagora24.com/dashboard/uploads/${snapshot.data[index].productImage}"),
                                              fit: BoxFit.contain)),
                                      // child: Container(
                                      //   width: MediaQuery.of(context).size.width,
                                      //   height: MediaQuery.of(context).size.height*.005,
                                      //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: Color(0XFFecf0f1)),
                                      //   child: IconButton(icon: Icon(Icons.close), onPressed: (){
                                      //     Navigator.pop(context);
                                      //   }),
                                      // ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    _bottomButton(index, snapshot),
                                  ],
                                ),
                              ),
                            );
                          },
                        )));
                setState(() {
                  a = 1;
                });
              },
            ),
            staggeredTileBuilder: (int index) =>
                new StaggeredTile.count(2, index.isEven ? 3 : 3),
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
          );
        }
      },
    );
  }

  Future<void> _addtoCart(String email, String pid, String pname, String amount,
      String entry, String dis) async {
    String url = "https://bigagora24.com/apps/CartInsert.php";
//String cart=SharedPrefManager.getcart().toString();
    print(_name);
    if (_name != null) {
      var response = await http.post(url, body: {
        'cart_name': _name.toString(),
        'email': email.toString(),
        'product_id': pid.toString(),
        'product_name': pname.toString(),
        'amount': amount.toString(),
        'quantity': a.toString(),
        'entryby': entry.toString(),
        'discount': dis.toString(),
      });
      var jsonrespons = json.decode(response.body);

      if (!jsonrespons['error']) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            actions: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * .10,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text("Add successfully"),
                ),
              ),
            ],
          ),
        );
      }
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                actions: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * .10,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Text("First make a cart"),
                    ),
                  ),
                ],
              ));
    }
  }

  Widget _bottomButton(int index, AsyncSnapshot snapshot) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 5,
        ),
        Expanded(
          flex: 0,
          child: Container(
            height: MediaQuery.of(context).size.height * .07,
            width: MediaQuery.of(context).size.width,
            //color: Colors.black12,
            child: Text(
              "Name: ${snapshot.data[index].productName} ",
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * .05,
          width: MediaQuery.of(context).size.width,
          child: Text(
            "Category: ${snapshot.data[index].productCatId}",
            style: TextStyle(
                fontSize: 14,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.start,
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * .04,
          width: MediaQuery.of(context).size.width,
          color: Colors.black12,
          child: Text(
            "Brand: ${snapshot.data[index].productCatBrand}",
            style: TextStyle(
                fontSize: 14,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                color: Colors.black),
            textAlign: TextAlign.start,
          ),
        ),
        Container(
            height: MediaQuery.of(context).size.height * .09,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Price: ${snapshot.data[index].productPrice}",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold)),
                //  Text("Qun: ${snapshot.data[index].productQun}", style: TextStyle(
                //                                     fontSize: 20,
                //                                     fontFamily: 'Roboto',
                //                                     fontWeight: FontWeight.bold)),
                Container(
                  margin: EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(
                      border: Border.all(width: .7),
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(CupertinoIcons.minus_circled),
                        onPressed: () {
                          _setState(() {
                            if (a <= 1) {
                              a = 1;
                            } else {
                              a = a - 1;
                            }
                          });
                        },
                      ),
                      Text(
                        "${a}",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                      IconButton(
                        icon: Icon(CupertinoIcons.add_circled),
                        onPressed: () {
                          _setState(() {
                            a = a + 1;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            )),
        SizedBox(
          height: 10,
        ),
        Container(
          height: MediaQuery.of(context).size.height * .20,
          width: MediaQuery.of(context).size.width,
          color: Colors.black12,
          child: Text(
            " ${snapshot.data[index].productDetails} ",
            style: TextStyle(
                fontSize: 16,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.justify,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.lightGreenAccent,
                ),
                child: Text(
                  "Add to Cart",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              onTap: () {
                String mail = user.email.toString();
                String pid = snapshot.data[index].productId;
                String pname = snapshot.data[index].productName;
                String amount = snapshot.data[index].productPrice;
                String entry = snapshot.data[index].entryby;
                String dis = snapshot.data[index].discount;

                _addtoCart(mail, pid, pname, amount, entry, dis);
                Navigator.pop(context, this);
              },
            ),
            // SizedBox(
            //   width: 20,
            // ),
            // Container(
            //   margin: EdgeInsets.only(top: 10),
            //   decoration: BoxDecoration(
            //     border: Border.all(width: 1),
            //     borderRadius: BorderRadius.circular(15),
            //   ),
            //   child: IconButton(
            //     icon: Icon(i),
            //     color: Colors.red,
            //     onPressed: liked
            //         ? () {
            //             _setState(() {
            //               liked = false;
            //               i = CupertinoIcons.heart;
            //             });
            //           }
            //         : () {
            //             _setState(() {
            //               liked = true;
            //               i = CupertinoIcons.heart_solid;
            //             });
            //           },
            //   ),
            // ),
          ],
        ),
      ],
    );
  }

  Widget _slider() {
    return Container(
      height: MediaQuery.of(context).size.height * .85,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 10),
      color: Colors.white38,
      child: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController1,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            // color: Colors.amberAccent,
            child: productitems3(context),
            // child: Text("data"),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            // color: Colors.blueAccent,
            child: _subPro(),
          ),
        ],
      ),
    );
  }
}
