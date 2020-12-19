import 'dart:async';
import 'dart:convert';

import 'package:bigagora24/Models/ProductModel.dart';
import 'package:bigagora24/NavBar.dart';
import 'package:bigagora24/NavBar2.dart';
import 'package:bigagora24/Searchpro.dart';
import 'package:bigagora24/utils/SharedPrefManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;

import 'Models/Users.dart';

class Allproduct extends StatefulWidget {
  @override
  _AllproductState createState() => _AllproductState();
}

class _AllproductState extends State<Allproduct> {
  StateSetter _setState;
  Users user;
  var i = CupertinoIcons.heart;
  int a = 1;
  var _name = "";
  bool liked = false;
  TextEditingController _items = new TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initProfile();
    _proList();
    SharedPrefManager.getcart().then(updatevalue);
  }

  final GlobalKey<ScaffoldState> _scf = new GlobalKey<ScaffoldState>();
  List unfilddata;
  List data;
  bool searchs = false;
  Future<String> _proList() async {
    var response = await http.get("https://bigagora24.com/apps/getproduct.php");
    print(response);
    var jsonResponse = json.decode(response.body);
    print(jsonResponse['products']);
    unfilddata = jsonResponse['products'];
    setState(() {
      data = jsonResponse['products'];
    });
   // print(data);
    return 'paichi';
  }

  Future<List<ProductModel>> _getProduct() async {
    var response = await http.get("https://bigagora24.com/apps/getproduct.php");
    var jsonResponse = json.decode(response.body);

    List<ProductModel> products = [];

    for (var i in jsonResponse['products']) {
      try {
        ProductModel data = ProductModel(
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
        products.add(data);
      } catch (e) {
        print(e);
      }
    }
    return products;
  }

  searchProduct(String str) {
    var strisEiext = str.length > 0 ? true : false;
    if (strisEiext) {
      var filterdata = [];
      for (var i = 0; i < unfilddata.length; i++) {
        String name = unfilddata[i]['product_name'].toUpperCase();
        if (name.contains(str.toUpperCase())) {
          filterdata.add(unfilddata[i]);
        }
      }
      setState(() {
        data = filterdata;
        searchs = true;
      });
    } else {
      setState(() {
        data = unfilddata;
        searchs = false;
      });
    }
  }

  void updatevalue(String name) {
    setState(() {
      this._name = name;
    });
  }

  Future<void> initProfile() async {
    Users u = await SharedPrefManager.getUserProfile();
    //    Products u1 = await SharedPrefManager.getProducts();
    setState(() {
      user = u;
    });
  }

  Widget navtest() {
  //  print(user.role.toString());
    if (user.role.toString() == '3') {
      return NavBar();
    } else {
      return NavBar2();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scf,
      drawer: navtest(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                appBars(context),
                SizedBox(height: 5),
                //searchArea(),
                Column(
                  children: <Widget>[
                    Container(
                        height: MediaQuery.of(context).size.height * .90,
                        color: Colors.amber[100],
                        child: (searchs)
                            ? (data != null)
                                ? ListView.builder(
                                    itemCount: data.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                       
                                          print("LOL$data");
                                      return Card(
                                        child: ListTile(
                                          title: data[index]
                                              ['product_name'],
                                        ),
                                      );
                                    })
                                : CupertinoActivityIndicator(
                                    radius: 15,
                                  )
                            : productitems2(context)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FutureBuilder<List<ProductModel>> productitems(BuildContext context) {
    return FutureBuilder(
      future: _getProduct(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          return Center(
            child: CupertinoActivityIndicator(
              radius: 20,
            ),
          );
        } else {
          return AnimationLimiter(
            child: GridView.count(
              crossAxisCount: 2,
              children: List.generate(
                snapshot.data.length,
                (int index) {
                  return AnimationConfiguration.staggeredGrid(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    columnCount: 2,
                    child: ScaleAnimation(
                      child: FadeInAnimation(
                        child: GestureDetector(
                          child: Container(
                            height: MediaQuery.of(context).size.height * .6,
                            //  color: Colors.amberAccent,
                            child: Card(
                              elevation: 5,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        .08,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                "http://bigagora24.com/dashboard/uploads/${snapshot.data[index].productImage}"),
                                            fit: BoxFit.contain)),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            "${snapshot.data[index].productName}",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.bold),
                                            maxLines: 2,
                                            overflow: TextOverflow.clip,
                                          ),
                                          Text(
                                              "Price: ${snapshot.data[index].productPrice}",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      //  Icon(Icons.shopping_cart,size: 25,)
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            //  Navigator.popAndPushNamed(context, '/LoginPage');
                            showDialog(
                                context: context,
                                builder: (_) => new AlertDialog(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                    content: StatefulBuilder(
                                      builder: (BuildContext context,
                                          StateSetter setState) {
                                        _setState = setState;
                                        return Container(
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
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
                                                _bottomButton(index, snapshot),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    )));
                            setState(() {
                              a = 0;
                            });
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }

  var col = Colors.black;
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
                Text("Price: ${snapshot.data[index].productPrice} Tk",
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
            "${snapshot.data[index].productDetails} ",
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
                Navigator.pop(context, this);
                _addtoCart(mail, pid, pname, amount, entry, dis);

                // setState(() {
                //   col=Colors.blue[100];
                // });
              },
            ),
            SizedBox(
              width: 20,
            ),
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

  Widget searchArea() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * .65,
          margin: EdgeInsets.symmetric(horizontal: 10),
          color: Colors.black12,
          child: TextField(
              autofocus: false,
              
              onChanged: (String value) {
                searchProduct(value);
              },
              decoration: InputDecoration(
                hintText: "Search Here !",
                enabled: true,
                labelStyle: TextStyle(fontSize: 15),contentPadding: EdgeInsets.symmetric(horizontal: 5,vertical: 5 )
              )),
        ),
        GestureDetector(
          child: Container(
            height: MediaQuery.of(context).size.height * .06,
            color: Colors.green,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.amber[100],
            ),
            child: Icon(Icons.search),
          ),
          onTap: () {
            //Navigator.pop(context, this);
         Navigator.pushNamed(context, '/Searchpro');}
        ),
        // CupertinoButton(
        //   child: Text(
        //     "Create Cart",
        //     style: TextStyle(
        //         fontFamily: 'Roboto',
        //         fontSize: 16,
        //         fontWeight: FontWeight.bold),
        //   ),
        //   padding: EdgeInsets.symmetric(
        //       horizontal: 10, vertical: 15),
        //   color: Colors.blueAccent,
        //   onPressed: () {
        //     //_createcart();
        //   },
        // )
      ],
    );
  }

  Widget appBars(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .07,
      color: Color(0XFF16a085),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          GestureDetector(
            child: Icon(Icons.subject, size: 45, color: Colors.white),
            onTap: () {
              _scf.currentState.openDrawer();
            },
          ),
          searchArea(),
          // Text(
          //   user.fullname,

          //   style: TextStyle(
          //       fontSize: 15,
          //       fontFamily: 'Roboto',
          //       fontWeight: FontWeight.bold),
          // ),
          // CircleAvatar(
          //   backgroundImage: NetworkImage(
          //       "http://bigagora24.com/dashboard/uploads/profile/${user.image}"),
          //   maxRadius: 20,
          //   backgroundColor: Colors.green,
          // ),
        ],
      ),
    );
  }

  FutureBuilder<List<ProductModel>> productitems2(BuildContext context) {
    return FutureBuilder(
      future: _getProduct(),
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
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
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
                            height: 5,
                          ),
                          Expanded(
                            flex: 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * .08,
                              color: Colors.black12,
                              padding: EdgeInsets.all(2),
                              child: Text(
                                "${snapshot.data[index].productName}",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.clip,
                                maxLines: 3,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
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
                          Text("Price: ${snapshot.data[index].productPrice}",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber)),
                        ],
                      )
                    ],
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

  void dialogbox({BuildContext context, Widget child}) {
    showCupertinoDialog(
        context: context, builder: (BuildContext context) => child);
  }

  Future<void> _addtoCart(String email, String pid, String pname, String amount,
      String entry, String dis) async {
    String url = "https://bigagora24.com/apps/CartInsert.php";
//String cart=SharedPrefManager.getcart().toString();
    //print(_name);
    if (_name != null) {
      dialogbox(
        context: context,
        child: CupertinoAlertDialog(
          content: CupertinoActivityIndicator(),
        ),
      );
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
        Navigator.pop(context, this);

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
                ));
      }
    } else {
      Navigator.pop(context, this);
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
}
