import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bigagora24/CartInfo.dart';
import 'package:bigagora24/Models/Brandmodel.dart';
import 'package:bigagora24/Models/CartModel.dart';
import 'package:bigagora24/Models/Covermodel.dart';
import 'package:bigagora24/Models/Message.dart';
import 'package:bigagora24/Models/ProductModel.dart';
import 'package:bigagora24/Models/Users.dart';
import 'package:bigagora24/NavBar.dart';
import 'package:bigagora24/NavBar2.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:http/http.dart' as http;
import 'package:bigagora24/utils/SharedPrefManager.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;
  TextEditingController _cartname = new TextEditingController();
  String _name = "";
  static final String uploadEndPoint =
      'http://bigagora24.com/apps/uploadinfo.php';
  PageController pageController = PageController(initialPage: 0);
  int _selectindex = 0;
  StateSetter _setState;
  Users user;
  var i = CupertinoIcons.heart;
  int a = 1;
  bool liked = false;
  String result;
  var umail;

  //final ref = FirebaseDatabase.instance.reference();
  Future<void> _createcart() async {
    String names = _cartname.text;
    SharedPrefManager.setcart(names);
    setState(() {
      _cartname.clear();
      Navigator.popAndPushNamed(context, '/HomePage');
    });
  }

  List<Message> userData = [];
  @override
  void initState() {
    super.initState();
    initProfile();
    animationController =
        AnimationController(duration: Duration(seconds: 0), vsync: this);
    animation = Tween(begin: 1.1, end: 0.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.bounceIn));
    animationController.forward();
    SharedPrefManager.getcart().then(updatevalue);
    // _getData();
  }

  void _setdatas() {
    umail = user.email.toString();
    result = umail.replaceAll('@gmail.com', '');
  }

  Future<List<Covermodel>> getcover() async {
    var respons = await http.get("https://bigagora24.com/apps/getcover.php");
    var jsonresponse = json.decode(respons.body);
    List<Covermodel> _coverImg = [];
    try {
      for (var i in jsonresponse['covers']) {
        Covermodel data = Covermodel(
          id: i['id'].toString(),
          sliderName: i['slider_name'].toString(),
          imgLink: i['img_link'].toString(),
        );
        _coverImg.add(data);
      }
    } catch (e) {
      print(e);
    }
    return _coverImg;
  }

  Future<List<Brandmodel>> getbrand() async {
    var response =
        await http.get("https://bigagora24.com/apps/getAllbrand.php");
    var jsonResponse = json.decode(response.body);
    List<Brandmodel> brands = [];
    for (var i in jsonResponse['brands']) {
      try {
        Brandmodel data1 = Brandmodel(
          id: i['id'].toString(),
          bName: i['b_name'].toString(),
          brandCat: i['brand_cat'].toString(),
          brandDis: i['brand_dis'].toString(),
          imgLink: i['img_link'].toString(),
        );
        brands.add(data1);
      } catch (e) {
        print(e);
      }
    }
    return brands;
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

  Future<List<CartModel>> _getcarts() async {
    String url = "https://bigagora24.com/apps/getCart.php";
    var response = await http.post(url, body: {
      'email': user.email,
    });
    //  print(response);
    var jsonrespons = json.decode(response.body);
    List<CartModel> _cart = [];

    try {
      for (var i in jsonrespons['carts']) {
        CartModel data = CartModel(
          cartName: i['cart_name'].toString(),
        );
        _cart.add(data);
      }
    } catch (e) {
      print(e);
    }
    return _cart;
  }

  Future<void> initProfile() async {
    Users u = await SharedPrefManager.getUserProfile();
    //    Products u1 = await SharedPrefManager.getProducts();
    setState(() {
      user = u;
      _setdatas();
      //  _getData();
    });
    SharedPrefManager.getcart().then(updatevalue);
  }

  Future<void> cartcreate() async {
    // String url ="https://bigagora24.com/apps/CartInsert.php";
    // var response= await http.post(url,body: {

    // });
    String s = _cartname.text;
    SharedPrefManager.setcart(s);
    setState(() {
      _cartname = null;
    });
  }

  Widget navtest() {
    print(user.role.toString());
    if (user.role.toString() == '3') {
      return NavBar();
    } else {
      return NavBar2();
    }
  }

  final GlobalKey<ScaffoldState> _scf = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return Scaffold(
            drawer: navtest(),
            key: _scf,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      appBars(context),
                      SizedBox(
                        height: 2,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * .80,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: MediaQuery.of(context).size.height * .80,
                              // color: Color(0XFFf39c12),
                              color: Colors.amber[100],
                              child: SingleChildScrollView(
                                child: Transform(
                                  transform: Matrix4.translationValues(
                                      animation.value * width, 0.0, 0.0),
                                  child: Column(
                                    children: <Widget>[
                                      _horizontalslide(context),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: _nav(),
          );
        });
  }

  Widget appBars(BuildContext context) {
    if (user.image.toString() == "null") {
      return Container(
        height: MediaQuery.of(context).size.height * .08,
        color: Colors.green,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              child: Icon(Icons.subject, size: 45, color: Colors.white),
              onTap: () {
                _scf.currentState.openDrawer();
              },
            ),
            Text(
              user.fullname.toString(),
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
        height: MediaQuery.of(context).size.height * .08,
        color: Color(0XFF16a085),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              child: Icon(Icons.subject, size: 45, color: Colors.white),
              onTap: () {
                _scf.currentState.openDrawer();
              },
            ),
            Text(
              user.fullname,
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
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

  Widget _horizontalslide(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 1.3,
      //color: Colors.black54,
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            _selectindex = index;
          });
        },
        children: <Widget>[
          Container(
              height: MediaQuery.of(context).size.height,
              //  color: Colors.amberAccent[50],
              child: Column(
                children: <Widget>[
                  Card(
                    elevation: 5,
                    child: Container(
                      height: MediaQuery.of(context).size.height * .3,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                      color: Colors.amberAccent[50],
                      child: coverImg(context),
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Top Brands",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          // GestureDetector(
                          //   child: Container(
                          //     height: MediaQuery.of(context).size.height * .02,
                          //     child: Text(
                          //       "See All",
                          //       style: TextStyle(
                          //           fontSize: 14, fontWeight: FontWeight.bold),
                          //       textAlign: TextAlign.end,
                          //     ),
                          //   ),
                          // )
                        ],
                      )),
                  SizedBox(
                    height: 2,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * .12,
                    child: branditem(context),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "All Product",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          GestureDetector(
                            child: Container(
                              height: MediaQuery.of(context).size.height * .02,
                              width: MediaQuery.of(context).size.width*.50,
                              child: Text(
                                "See All",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.end,
                              ),
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, '/Searchpro');
                            },
                          )
                        ],
                      )),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * .75,
                    child: productitems(context),
                  )
                ],
              )),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            // color: Colors.blueAccent[100],
            child: Column(
              children: <Widget>[
                Card(
                  elevation: 5,
                  child: Container(
                    height: MediaQuery.of(context).size.height * .09,
                    width: MediaQuery.of(context).size.width,
                    //  color: Colors.red,
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * .6,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            controller: _cartname,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                border: OutlineInputBorder(),
                                hintText: 'Create new cart',
                                labelStyle: TextStyle(fontSize: 16),
                                fillColor: Colors.blueAccent),
                          ),
                        ),
                        CupertinoButton(
                          child: Text(
                            "Create Cart",
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          color: Colors.blueAccent,
                          onPressed: () {
                            _createcart();
                          },
                        )
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height * .95,
                    color: Colors.white,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          _activeCart(),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * .90,
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            color: Colors.amber[100],
                            child: cartName(context),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Card(
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      child: CircleAvatar(
                        radius: 90,
                        backgroundColor: Colors.amber[300],
                        child: Center(
                          child: _propic(),
                        ),
                      ),
                      onTap: () {
                        //_diaimag();
                        Navigator.pushNamed(context, '/Proimage');
                      },
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * .10,
                      width: MediaQuery.of(context).size.width * .85,
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Full Name:\t',
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold),
                          ),
                          Card(
                            elevation: 5,
                            child: Container(
                              height: MediaQuery.of(context).size.height * .05,
                              child: Center(
                                child: Text(
                                  user.fullname.toString(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * .10,
                      width: MediaQuery.of(context).size.width * .85,
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Email:\t',
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold),
                          ),
                          Card(
                            elevation: 5,
                            child: Container(
                              height: MediaQuery.of(context).size.height * .05,
                              child: Center(
                                child: Text(
                                  user.email.toString(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * .10,
                      width: MediaQuery.of(context).size.width * .85,
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: Text(
                              'Mobile:',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Card(
                            elevation: 5,
                            child: Container(
                              height: MediaQuery.of(context).size.height * .05,
                              child: Center(
                                child: Text(
                                  user.mobile.toString(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * .20,
                      width: MediaQuery.of(context).size.width * .85,
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: Text(
                              'Address:',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Card(
                            elevation: 5,
                            child: Container(
                              height: MediaQuery.of(context).size.height * .15,
                              width: MediaQuery.of(context).size.width * .85,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  user.address.toString(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height * .06,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.blue,
                          ),
                          child: IconButton(
                              icon: Icon(
                                Icons.edit,
                                size: 30,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/ChangeProf');
                              }),
                        )
                      ],
                    )
                    // Container(
                    //   height: MediaQuery.of(context).size.height * .70,
                    //   width: MediaQuery.of(context).size.width,
                    //   child: ListView.builder(
                    //     itemCount: userData.length,
                    //     itemBuilder: (BuildContext context,int index){
                    //       return _messagedata(userData[index].mess);

                    //   })
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: <Widget>[
                    //     Container(
                    //       height: MediaQuery.of(context).size.height * .09,
                    //       width: MediaQuery.of(context).size.width * .75,
                    //       child: CupertinoTextField(
                    //         //maxLength: 5,
                    //         padding:
                    //             EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    //         placeholder: 'Type Here',
                    //         controller: _messages,
                    //         maxLines: 8,
                    //         placeholderStyle: TextStyle(
                    //             fontFamily: 'Roboto',
                    //             fontSize: 14,
                    //             color: Colors.black),
                    //       ),
                    //     ),
                    //     Container(
                    //       height: MediaQuery.of(context).size.height * .09,
                    //       width: MediaQuery.of(context).size.width * .18,
                    //       margin: EdgeInsets.symmetric(horizontal: 5),
                    //       decoration: BoxDecoration(
                    //         color: Colors.blueAccent,
                    //         borderRadius: BorderRadius.circular(5),
                    //       ),
                    //       child: Center(
                    //         child: IconButton(
                    //             icon: Icon(
                    //               Icons.send,
                    //               size: 30,
                    //               color: Colors.white,
                    //             ),
                    //             onPressed: () {
                    //              // _addData();
                    //             }),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  void updatevalue(String name) {
    setState(() {
      this._name = name;
    });
  }

  Widget _nav() {
    return BottomNavyBar(
      selectedIndex: _selectindex,

      showElevation: true, // use this to remove appBar's elevation
      onItemSelected: (index) {
        setState(() {
          _selectindex = index;
          pageController.animateToPage(index,
              duration: Duration(seconds: 1), curve: Curves.ease);
        });
      },

      items: [
        BottomNavyBarItem(
          icon: Icon(Icons.apps),
          title: Text('Home'),
          activeColor: Colors.red,
        ),
        BottomNavyBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text('Cart'),
            activeColor: Colors.purpleAccent),
        BottomNavyBarItem(
            icon: Icon(Icons.verified_user),
            title: Text('Profile'),
            activeColor: Colors.pink),
      ],
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
          // int len= snapshot.data.length;
          if (snapshot.data.length <= 0) {
            return Center(
              child: Text(
                "Opps! :(\nTrun On your Internet Connection",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 25,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return AnimationLimiter(
              child: GridView.count(
                crossAxisCount: 2,
                children: List.generate(
                  10,
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
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .15,
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
                                                fontSize: 13,
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.clip,
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              "Price: ${snapshot.data[index].productPrice}",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.amberAccent),
                                              maxLines: 2,
                                            ),
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
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: <Widget>[
                                                  Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            .30,
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                "http://bigagora24.com/dashboard/uploads/${snapshot.data[index].productImage}"),
                                                            fit: BoxFit
                                                                .contain)),
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
                                                  _bottomButton(
                                                      index, snapshot),
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
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }
        }
      },
    );
  }

  FutureBuilder<List<Brandmodel>> branditem(BuildContext context) {
    return FutureBuilder(
      future: getbrand(),
      builder: (BuildContext context, AsyncSnapshot snapshot1) {
        if (snapshot1.data == null) {
          return CupertinoActivityIndicator(
            radius: 20,
          );
        } else {
          return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 15,
              itemBuilder: (BuildContext contex, int index) {
                return Container(
                  child: Card(
                    elevation: 10,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height * .08,
                          width: MediaQuery.of(context).size.width * .40,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "http://bigagora24.com/dashboard/uploads/brand/${snapshot1.data[index].imgLink}"),
                                  fit: BoxFit.contain)),
                        ),
                        Text("${snapshot1.data[index].bName}"),
                        //Text("${snapshot1.data[index].brandCat}"),
                      ],
                    ),
                  ),
                );
              });
        }
      },
    );
  }

  FutureBuilder<List<Covermodel>> coverImg(BuildContext context) {
    return FutureBuilder(
      future: getcover(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          return CupertinoActivityIndicator(
            radius: 30,
          );
        } else {
          return Swiper(
            autoplay: true,
            autoplayDelay: 9000,
            //autoplayDisableOnInteraction: true,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: MediaQuery.of(context).size.height * .3,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            "http://bigagora24.com/dashboard/coveruploads/${snapshot.data[index].imgLink}"),
                        fit: BoxFit.contain)),
              );
            },
            itemCount: snapshot.data.length,
            pagination: new SwiperPagination(),
            control: new SwiperControl(color: Colors.black54),
          );
        }
      },
    );
  }

  Widget _bottomButton(int index, AsyncSnapshot snapshot) {
    return Column(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * .08,
          width: MediaQuery.of(context).size.width,
          color: Colors.black12,
          child: Text(
            "Name: ${snapshot.data[index].productName} ",
            style: TextStyle(
                fontSize: 16,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.start,
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
          child: Text(
            "Brand: ${snapshot.data[index].productCatBrand}",
            style: TextStyle(
                fontSize: 14,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.start,
          ),
        ),
        Container(
            height: MediaQuery.of(context).size.height * .09,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(" Price: ${snapshot.data[index].productPrice} Tk",
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
                            if (a <= 0) {
                              a = 0;
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
        GestureDetector(
          child: Row(
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
                  String pid = snapshot.data[index].productId.toString();
                  String pname = snapshot.data[index].productName.toString();
                  String amount = snapshot.data[index].productPrice.toString();
                  String dis = snapshot.data[index].discount.toString();
                  String entryby = snapshot.data[index].entryby.toString();

                  _addtoCart(mail, pid, pname, amount, dis, entryby,context);
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
          onTap: () {},
        ),
      ],
    );
  }

  FutureBuilder<List<CartModel>> cartName(BuildContext context) {
    return FutureBuilder(
        future: _getcarts(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return CupertinoActivityIndicator(
              radius: 30,
            );
          } else if (_name == null) {
            return Center(
              child: Container(
                height: MediaQuery.of(context).size.height * .10,
                width: MediaQuery.of(context).size.width,
                child: Text(
                  "Create a Cart and it will show after product add",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 25,
                    color: Colors.black45,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
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
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 5,
                    child: ListTile(
                      leading: Icon(Icons.shopping_cart),
                      title: Text(
                        "${snapshot.data[index].cartName}",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                  "Do you want Delete this Cart",
                                  style: TextStyle(fontSize: 14),
                                ),
                                actions: <Widget>[
                                  CupertinoButton(
                                      child: Text("Yes"),
                                      onPressed: () {
                                        Navigator.pop(context, this);
                                        //String proid=snapshot.data[index].productId;
                                        removecartdata(
                                            snapshot.data[index].cartName
                                                .toString(),
                                            user.email);
                                      }),
                                  CupertinoButton(
                                      child: Text("No"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      })
                                ],
                              ),
                            );
                          }),
                      onTap: () {
                        String datas = snapshot.data[index].cartName.toString();
                        String email = user.email.toString();
                        String uid = user.id.toString();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CartInfo(
                                cname: datas, mail: email, userid: uid),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
          }
        });
  }

// Widget _cartoption(){
//   var s=SharedPrefManager.getCart();
//   print(s);
//   if (s == Null) {

//                  return  Container(
//                     height: MediaQuery.of(context).size.height,
//                     color: Colors.blueAccent,
//                     child: Center(
//                       child: Text("Cart is Empty"),
//                     ),

//                   );
//                 }else{
//                 return  cartName(context);
//                 }
// }

  Widget _activeCart() {
    if (_name == null) {
      return Text(
        "Active Cart:\t" + "Not Created",
        style: TextStyle(
            fontSize: 18,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            color: Colors.green),
      );
    } else {
      return Text(
        "Active Cart:\t" + _name,
        style: TextStyle(
            fontSize: 18,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            color: Colors.green),
      );
    }
  }

  void dialogbox({BuildContext context, Widget child}) {
    showCupertinoDialog(
        context: context, builder: (BuildContext context) => child);
  }
   void dialogbox2({BuildContext context, Widget child}) {
    showCupertinoDialog(
        context: context, builder: (BuildContext context) => child);
  }

  Future<void> _addtoCart(String email, String pid, String pname, String amount,
      String entry, String dis,context) async {
    String url = "https://bigagora24.com/apps/CartInsert.php";
//String cart=SharedPrefManager.getcart().toString();
    print(_name.toString());
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
    } else if(_name==null) {
           
             mes();
         
      // showDialog(
      //     context: context,
      //     builder: (context) => AlertDialog(
      //           actions: <Widget>[
      //             Container(
      //               height: MediaQuery.of(context).size.height * .10,
      //               width: MediaQuery.of(context).size.width,
      //               child: Center(
      //                 child: Text("First make a cart"),
      //               ),
      //             ),
      //           ],
      //         ));
         
    }
  }
 void mes(){
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
          Navigator.pop(context, this);
 }
  Future<void> delaysTime() async {
    Future.delayed(Duration(seconds: 2)).then((v) {
      // Navigator.popAndPushNamed(context, '/IntroPage');
      // Navigator.push(context, CupertinoPageRoute(builder: (_)=>IntroPage()));
      Navigator.pop(context);
    });
  }

  Widget _messagedata(String message) {
    var r = MainAxisAlignment.end;
    var l = MainAxisAlignment.start;
    if (user.role.toString() == '1') {
      return Container(
          height: MediaQuery.of(context).size.height * .15,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(vertical: 5),
          //  color: Colors.amber[100],
          child: Row(
            mainAxisAlignment: r,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * .15,
                width: MediaQuery.of(context).size.width * .85,
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10),
                ),

                // child: CupertinoTextField(
                //   maxLength: 5,
                //   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                //   placeholder: message,
                //   maxLines: 8,
                //   placeholderStyle: TextStyle(
                //       fontFamily: 'Roboto', fontSize: 14, color: Colors.black),
                // ),
                child: Text(message),
              )
            ],
          ));
    } else {
      return Container(
          height: MediaQuery.of(context).size.height * .06,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: l,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * .15,
                width: MediaQuery.of(context).size.width * .85,
                child: CupertinoTextField(
                  maxLength: 5,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  placeholder: message,
                  maxLines: 8,
                  placeholderStyle: TextStyle(
                      fontFamily: 'Roboto', fontSize: 14, color: Colors.black),
                ),
              )
            ],
          ));
    }
  }

//   void _addData() {

//     //print(result);
//     String dataKey = ref.push().child(result).key;

//      DateTime datenow =
//         DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,DateTime.now().hour, DateTime.now().minute, DateTime.now().second);

//     String res=datenow.toString().replaceAll('-', '');
//      String res1=res.replaceAll(':', '');
//      String res2=res1.replaceAll('.', '');
//       String res3=res2.replaceAll(' ', '');
//     print(res3);

//  String finalres = user.role.toString() + res3;
//   print(finalres);
//     String data = ref.push().child(finalres).key;
//     ref
//         .child('message')
//         .child(dataKey)
//         .child(data)
//         .set({'mess': _messages.text.toString(), });
//     _messages.clear();
//     setState(() {
//       _getData();
//     });
//   }

// void _getData(){

//     //ref.child('message').reference().child(result).once().then((DataSnapshot snap){
//      ref.child('message').reference().child(result).orderByKey().once().then((DataSnapshot snap){

//       var keys = snap.value.keys;
//       var data = snap.value;

//        userData.clear();

//        for(var key in keys){
//          Message u = new Message(
//            key: key,
//            mess: data[key]['mess'],
//          //  status: data[key]['status'],
//          );
//          userData.add(u);
//         //userData.sort();
//        }
//    //  userData.sort();
//     }).then((val){
//       setState(() {
//        _getData();
//       });
//     });

//    }

  Widget _propic() {
    if (user.image.toString() == "null") {
      return CircleAvatar(
        child: Text(
          "B",
          style: TextStyle(
              fontSize: 18, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
        ),
        maxRadius: 80,
        backgroundColor: Colors.green,
      );
    } else {
      return CircleAvatar(
        backgroundImage: NetworkImage(
            "http://bigagora24.com/dashboard/uploads/profile/${user.image}"),
        maxRadius: 80,
        backgroundColor: Colors.green,
      );
    }
  }

  void removecartdata(String cartname, String email) async {
    var url = "https://bigagora24.com/apps/deleteCart.php";
    var respons = await http.post(url, body: {
      'cart_name': cartname.toString(),
      'email': email.toString(),
    });
    var jsonrespons = json.decode(respons.body);
    print(jsonrespons);
    if (!jsonrespons['error']) {
      Navigator.pop(context, this);
  Navigator.of(context).pushNamedAndRemoveUntil('/HomePage', (Route<dynamic> route) => false);

      // setState(() {
      //   //initState();
      // });
      //   Navigator.push(
      //                         context,
      //                         MaterialPageRoute(
      //                           builder: (context) => CartInfo(
      //                               cname: cname, mail: mail, userid: userid),
      //                         ));
    }
  }
}
