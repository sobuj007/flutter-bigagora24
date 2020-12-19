import 'dart:convert';

import 'package:bigagora24/Home.dart';
import 'package:bigagora24/utils/SharedPrefManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Models/Users.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  PageController _pageController;
  int _selectindex = 0;
  Color c1 = Color(0XFF16a085);
  Animation animation;
  AnimationController animationController;
  TextEditingController _email = new TextEditingController();
  TextEditingController _pass = new TextEditingController();
//SharedPrefManager logindata;
  bool newuser;
  @override
  void initState() {
    check_if_already_login();
    // TODO: implement initState
    super.initState();
    // _getProduct(context);
    //print(SharedPrefManager.isUserLogedIn());
   
    // if( SharedPrefManager.isUserLogedIn()==true){
    //   Navigator.popAndPushNamed(context, '/HomePage');
    // }

    animationController =
        AnimationController(duration: Duration(seconds: 0), vsync: this);
    animation = Tween(begin: 1.1, end: 0.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeIn));
    animationController.forward();
  }
void check_if_already_login() async {
    newuser=await SharedPrefManager.isUserLogedIn();
    //newuser = (logindata.get('isuser') ?? true);
    print(newuser);
    if (newuser ==true) {
      //Navigator.pop(context,this);
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => Home()));
    }
  }
  Future<void> _userLogin(BuildContext context) async {
    dialogbox(
      context: context,
      child: CupertinoAlertDialog(
        content: CupertinoActivityIndicator(),
      ),
    );

    String url = "https://bigagora24.com/apps/userlogin.php";
    var respons = await http.post(url, body: {
      'email': _email.text,
      'password': _pass.text,
    });
    var jsonrespons = json.decode(respons.body);
    print(jsonrespons);
  //  Navigator.pushNamed(context, '/HomePage');
    if (!jsonrespons['error']) {
      Navigator.pop(context);
// user datra to shared pref
      Users user = new Users.fromJson(jsonrespons['user']);
      SharedPrefManager.setUserLogedIn(true);
      SharedPrefManager.setUserProfile(user);
// user dailog box
      Navigator.popAndPushNamed(context, '/HomePage');
      
    } else {
      Navigator.pop(context);
      dialogbox(
          context: context,
          child: CupertinoAlertDialog(
            content: Text("Login Failed"),
            actions: <Widget>[
              CupertinoButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _email = null;
                    _pass = null;
                  });
                },
                child: Text("Done"),
              )
            ],
          ));
           Navigator.of(context).pushNamedAndRemoveUntil('/Loginpage', (Route<dynamic> route) => false);
    }
  }

  void dialogbox({BuildContext context, Widget child}) {
    showCupertinoDialog(
        context: context, builder: (BuildContext context) => child);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return Scaffold(
          body: SafeArea(
                      child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Transform(
                  transform: Matrix4.translationValues(
                      animation.value * width, 0.0, 0.0),
                  child: Column(
                    children: <Widget>[
                      
                      Container(
                        height: MediaQuery.of(context).size.height * .28,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Color(0xFFFE980F),
                          //image: DecorationImage(image: AssetImage('assets/bigagoralog.png'))
                        ),
                        child: Image(image: AssetImage("assets/bigagoralog.png"),fit: BoxFit.cover, ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      _loginfrom(width),
                      
                        Text(
                "from CS Lab",
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    color: Color(0XFF2c3e50),
                    fontWeight: FontWeight.bold),
              ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _loginfrom(double width) {
    return Container(
      height: MediaQuery.of(context).size.height * .52,
      color: Colors.amberAccent,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      child: Card(
        elevation: 8,
        child: Transform(
          transform: Matrix4.translationValues(0.0, animation.value*width, 0.0),
                  child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height*.06,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                child: Text(
                  "Login",
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 30,
                      fontWeight: FontWeight.w700),
                      textAlign: TextAlign.start,
                ),
              ),
              SizedBox(
                width: 30,
              ),
              CupertinoTextField(
                placeholder: "Enter Email Address",
                controller: _email,
                keyboardType: TextInputType.text,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                decoration: BoxDecoration(
                   color: Color(0XFFecf0f1),
                  //  borderRadius: BorderRadius.circular(5),
                    ),
                prefix: Icon(
                  CupertinoIcons.person_solid,
                  size: 30,
                ),
                autofocus: false,
                placeholderStyle:
                    TextStyle(color: Colors.black, fontFamily: 'Roboto'),
              ),
              SizedBox(
                height: 15,
              ),
              CupertinoTextField(
                placeholder: "Enter Password",
                controller: _pass,
                obscureText: true,
                keyboardType: TextInputType.text,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                decoration: BoxDecoration(
                    color: Color(0XFFecf0f1),
                    borderRadius: BorderRadius.circular(0)),
                prefix: Icon(
                  CupertinoIcons.padlock_solid,
                  size: 30,
                ),
                autofocus: false,
                placeholderStyle:
                    TextStyle(color: Colors.black, fontFamily: 'Roboto'),
              ),
              SizedBox(
                height: 20,
              ),
              CupertinoButton(
                color: Colors.blue,
                child: Text(
                  "Sing In",
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
                onPressed: () {
                  _userLogin(context);
                  // Navigator.popAndPushNamed(context, '/HomePage');
                  // Navigator.pushNamed(context, '/HomePage');
                },
              ),
              SizedBox(
                height: 30,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Tap hear to "),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                                              child: Text(
                          "Sign Up !",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 20,
                              color: Colors.greenAccent,
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: (){
                          Navigator.pushNamed(context, '/SignUp');
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                                      child: Text(
                      "Forget Password",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          color: Colors.amber,
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: (){
                      Navigator.pushNamed(context, '/Forgetpass');
                    },
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .03,
              ),
            
            ],
          ),
        ),
      ),
    );
  }
}
