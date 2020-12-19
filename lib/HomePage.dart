import 'dart:convert';
import 'dart:math';

import 'package:bigagora24/CartInfo.dart';
import 'package:bigagora24/Models/Brandmodel.dart';
import 'package:bigagora24/Models/CartModel.dart';
import 'package:bigagora24/Models/Covermodel.dart';
import 'package:bigagora24/Models/ProductModel.dart';
import 'package:bigagora24/Models/Users.dart';
import 'package:bigagora24/NavBar.dart';
import 'package:bigagora24/utils/SharedPrefManager.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:http/http.dart' as http;
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
TextEditingController _cartname = new TextEditingController();
  var _name = "";

  PageController pageController = PageController(initialPage: 0);
  int _selectindex = 0;
  StateSetter _setState;
  Users user;
  var i = CupertinoIcons.heart;
  int a = 1;
  bool liked = false;
  Future<void> _createcart() async {
    String names = _cartname.text;
    SharedPrefManager.setcart(names);
    setState(() {
      _cartname.clear();
      Navigator.popAndPushNamed(context, '/HomePage');
    });
  }
  @override
  void initState() {
    super.initState();
    initProfile();
 
    SharedPrefManager.getcart().then(updatevalue);
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
    print(response);
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
    });
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

  final GlobalKey<ScaffoldState> _scf = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      key: _scf,
      body: SafeArea(child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            appBars(context),
                  SizedBox(
                    height: 5,
                  ),
                  Column(
                    children: <Widget>[
                      _horizontalslide(context),
                    ],
                  ),
                ],
              )),
            ),
            bottomNavigationBar: _nav(),
    );
  }

  Widget appBars(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .06,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            child: Icon(Icons.subject, size: 45, color: Color(0XFF16a085)),
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
            backgroundImage: NetworkImage(
                "http://bigagora24.com/dashboard/uploads/profile/${user.image}"),
            maxRadius: 20,
            backgroundColor: Colors.green,
          ),
        ],
      ),
    );
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
            icon: Icon(Icons.message),
            title: Text('Messages'),
            activeColor: Colors.pink),
      ],
    );
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
              child: Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * .3,
                    child: coverImg(context),
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
                            "Top Category",
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
                    height: 5,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * .15,
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
                              padding: EdgeInsets.symmetric(horizontal: 5,),
                              child: Text(
                                "See All",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.end,
                              ),
                            ),
                            onTap: () {
                              Navigator.popAndPushNamed(context, '/Allproduct');
                            },
                          )
                        ],
                      )),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * .70,
                    child: productitems(context),
                  )
                ],
              )),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            // color: Colors.amberAccent,
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * .09,
                  width: MediaQuery.of(context).size.width,
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
                          })
                    ],
                  ),
                ),
                Row(
                  
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                 _activeCart(),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * .80,
                  width: MediaQuery.of(context).size.width,
                  // color: Colors.blueAccent,
//child: _cartoption(),
                  child: cartName(context),
                )
              ],
            ),
          ),
          Text("hol"),
        ],
      ),
    );
  }
   void updatevalue(String name) {
    setState(() {
      this._name = name;
    });
  }
Widget _activeCart(){
  if(_name==null){
    return    Text(
                     "Active Cart:\t" + "Not Created",
                     
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    );
  }
  else{
    return    Text(
                     "Active Cart:\t" + _name,
                     
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    );
  }
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
                                         Container(
                                           height: MediaQuery.of(context).size.height*.04,
                                           //color: Colors.amberAccent[100],
                                           child:  Text(
                                              "${snapshot.data[index].productName}",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.bold),overflow: TextOverflow.clip,maxLines: 2),
                                         ),
                                          Text(
                                              "Price: ${snapshot.data[index].productPrice}",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.bold,color: Colors.amber)),
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
                          height: MediaQuery.of(context).size.height * .10,
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

          // return ListView.builder(
          //     scrollDirection: Axis.horizontal,
          //     itemBuilder: (BuildContext contex, int index) {
          //       return Swiper(
          //         itemCount: snapshot.data.length,
          //         autoplay: true,
          //         autoplayDelay: 500,
          //         itemBuilder: (BuildContext context, int index) {
          //           return Container(
          //             height: MediaQuery.of(context).size.height*.3,
          //             color: Colors.amberAccent,
          //             decoration: BoxDecoration(
          //                   image: DecorationImage(
          //                       image: NetworkImage(
          //                           "http://bigagora24.com/dashboard/coveruploads/${snapshot.data[index].imgLink}"),
          //                       fit: BoxFit.contain)),
          //           );
          //         },
          //       );
          //     });
        }
      },
    );
  }

  Widget _bottomButton(int index, AsyncSnapshot snapshot) {
    return Column(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * .05,
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
            "Price: ${snapshot.data[index].productDetails} ",
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
                  String pid = snapshot.data[index].productId;
                  String pname = snapshot.data[index].productName;
                  String amount = snapshot.data[index].productPrice;
                  String entry = snapshot.data[index].entryby;
                  String dis = snapshot.data[index].discount;
                  _addtoCart(mail, pid, pname, amount, entry, dis);
                },
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: IconButton(
                  icon: Icon(i),
                  color: Colors.red,
                  onPressed: liked
                      ? () {
                          _setState(() {
                            liked = false;
                            i = CupertinoIcons.heart;
                          });
                        }
                      : () {
                          _setState(() {
                            liked = true;
                            i = CupertinoIcons.heart_solid;
                          });
                        },
                ),
              ),
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
                          icon: Icon(Icons.delete), onPressed: () {}),
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
  Future<void> _addtoCart(String email, String pid, String pname, String amount,
      String entry, String dis) async {
    String url = "https://bigagora24.com/apps/CartInsert.php";
//String cart=SharedPrefManager.getcart().toString();
    print(_name);
    if(_name!=null){
      
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
                      child: Center(child: Text("Add successfully"),),),
                
                ],
              ));
   
    }
  }
  else{

showDialog(
          context: context,
          builder: (context) => AlertDialog(
                actions: <Widget>[
                  Container(
                      height: MediaQuery.of(context).size.height * .10,
                      width: MediaQuery.of(context).size.width,
                      child: Center(child: Text("First make a cart"),),
                      ),
                     
                ],
              ));


  
  }
}
}