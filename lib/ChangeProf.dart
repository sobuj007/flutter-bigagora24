import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChangeProf extends StatefulWidget {
  @override
  _ChangeProfState createState() => _ChangeProfState();
}

class _ChangeProfState extends State<ChangeProf>
    with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;
  TextEditingController _email = new TextEditingController();
  TextEditingController _pass = new TextEditingController();
 
  TextEditingController _mobile = new TextEditingController();
  Future<void> _signup() async {
    String url = "https://bigagora24.com/apps/updateProf.php";
    var response = await http.post(url, body: {

      'email': _email.text,
      'mobile': _mobile.text,
      'address': _pass.text,
      
    });

    var jsonrespos = json.decode(response.body);
    if (!jsonrespos['error']) {
      showDialog(
          context: context,
          // child: CupertinoAlertDialog(
          //   content: Text("Register successfully "),
          //   actions: <Widget>[
          //     CupertinoButton(
          //       onPressed: () {
          //         Navigator.pop(context);

          //         setState(() {
          //           _email.clear();
          //           _pass.clear();
          //           _fullname.clear();
          //           _mobile.clear();
          //         });
          //       },
          //       child: Text("Done"),
          //     )
          //   ],
          // )
          child: AlertDialog(
            actions: <Widget>[
              Row(
                children: <Widget>[
                  Text("Profile Update successfully"),
                ],
              ),
              CupertinoButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.popAndPushNamed(context, '/Loginpage');
                  setState(() {
                    _email.clear();
                    _pass.clear();
                  
                    _mobile.clear();
                  });
                },
                child: Text("Done"),
              )
            ],
          ));
    } else {
      showDialog(
          context: context,
          
          child: AlertDialog(
            actions: <Widget>[
              Text("Somting Wrong"),
              CupertinoButton(
                onPressed: () {
                  Navigator.pop(context);
               //   Navigator.popAndPushNamed(context, '/Loginpage');
                  setState(() {
                    _email.clear();
                    _pass.clear();
                
                    _mobile.clear();
                  });
                },
                child: Text("Done"),
              )
            ],
          ));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController =
        AnimationController(duration: Duration(seconds: 0), vsync: this);
    animation = Tween(begin: 1.1, end: 0.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeIn));
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * .28,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Color(0xFFFE980F),
                        //image: DecorationImage(image: AssetImage('assets/bigagoralog.png'))
                      ),
                      child: Image(
                        image: AssetImage("assets/bigagoralog.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Transform(
                      transform: Matrix4.translationValues(
                          animation.value * width, 0.0, 0.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * .60,
                        width: MediaQuery.of(context).size.width,
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Card(
                          elevation: 8,
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Change your Info ! ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Roboto',
                                    fontSize: 18),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              CupertinoTextField(
                                autofocus: false,
                                controller: _mobile,
                                maxLength: 11,
                                placeholderStyle: TextStyle(
                                    color: Colors.black, fontFamily: 'Roboto'),
                                placeholder: "Enter New Mobile Number",
                                keyboardType: TextInputType.text,
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 15),
                                decoration: BoxDecoration(
                                  color: Color(0XFFecf0f1),
                                ),
                                prefix: Icon(
                                  Icons.phone,
                                  size: 40,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              CupertinoTextField(
                                autofocus: false,
                                controller: _pass,
                                obscureText: false,
                                maxLines: 5,
                                placeholderStyle: TextStyle(
                                    color: Colors.black, fontFamily: 'Roboto'),
                                placeholder: "Enter New  Address",
                                keyboardType: TextInputType.text,
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 15),
                                decoration: BoxDecoration(
                                  color: Color(0XFFecf0f1),
                                ),
                                prefix: Icon(
                                  Icons.map,
                                  size: 40,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              CupertinoButton(
                                  child: Text(
                                    "Update",
                                    style: TextStyle(fontFamily: 'Roboto'),
                                  ),
                                  color: Colors.blueAccent,
                                  onPressed: () {
                                    _signup();
                                  }),
                              SizedBox(
                                height: 20,
                              ),
                              Text("If you face any problem Mail us "),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "bigagora24.aid@gmail.com",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amberAccent),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
