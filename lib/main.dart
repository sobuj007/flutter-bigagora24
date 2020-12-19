import 'package:bigagora24/Allproduct.dart';

import 'package:bigagora24/CartInfo.dart';
import 'package:bigagora24/CartInfoCheck.dart';
import 'package:bigagora24/CatbyPro.dart';
import 'package:bigagora24/ChangeProf.dart';
import 'package:bigagora24/ForgetPass.dart';

import 'package:bigagora24/Home.dart';
import 'package:bigagora24/HomePage.dart';
import 'package:bigagora24/ImagePro.dart';
import 'package:bigagora24/IntroPage.dart';
import 'package:bigagora24/LoginPage.dart';
import 'package:bigagora24/OrderPage.dart';
import 'package:bigagora24/Proimage.dart';
import 'package:bigagora24/Searchpro.dart';
import 'package:bigagora24/ShowmyOrder.dart';
import 'package:bigagora24/SignUp.dart';
import 'package:bigagora24/SplashScreen.dart';
import 'package:bigagora24/SubCat.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
            SystemChrome.setPreferredOrientations([
   DeviceOrientation.portraitDown,
   DeviceOrientation.portraitUp,
]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
     home:SplashScreen(),
     //home: CatbyPro(),
     
      initialRoute:'/',
      routes: {
        '/IntroPage':(context)=> IntroPage(),
        '/Loginpage':(context)=> LoginPage(),
        '/HomePage':(context)=> Home(),
        '/Allproduct':(context)=> Allproduct(),
        '/SignUp':(context)=> SignUp(),
        '/SubCat':(context)=> SubCat(),
        '/CartInfo':(context)=> CartInfo(),
       '/CartInfoCheck':(context)=>CartInfoCheck(),
        '/OrderPage':(context)=> OrderPage(),
        '/ImagePro':(context)=> ImagePro(),
        '/Proimage':(context)=> Proimage(),
        '/Forgetpass':(context)=> ForgetPass(),
        '/ChangeProf':(context)=> ChangeProf(),
        '/ShowmyOrder':(context)=> ShowmyOrder(),
        '/Searchpro':(context)=> SearchPro(),
      },
    );
  }
}
