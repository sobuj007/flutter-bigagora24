import 'package:bigagora24/LoginPage.dart';
import 'package:bigagora24/utils/SharedPrefManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
final pages = [
    PageViewModel(
        pageColor: const Color(0xFF34495e),
        // iconImageAssetPath: 'assets/air-hostess.png',
        bubble: Icon(Icons.cloud_circle),
        body: Text(
          'You can order your favorite all kind of Product Online with us',
        ),
        title: Text(
          'Order',
        ),
        titleTextStyle: TextStyle(fontFamily: 'Roboto', color: Colors.white),
        bodyTextStyle: TextStyle(fontFamily: 'Roboto', color: Colors.white),
        mainImage: Image.asset(
          'assets/buyonline.png',
          height: 285.0,
          width: 285.0,
          alignment: Alignment.center,
        )),
    PageViewModel(
      pageColor: const Color(0xFF8BC34A),
     // iconImageAssetPath: 'assets/waiter.png',
      body: Text(
        'After order you get your product as soon possible',
      ),
      title: Text('Tap & Order'),
      mainImage: Image.asset(
        'assets/onorder.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      titleTextStyle: TextStyle(fontFamily: 'Roboto', color: Colors.white),
      bodyTextStyle: TextStyle(fontFamily: 'Roboto', color: Colors.white),
    ),
    PageViewModel(
      pageColor: const Color(0xFFe74c3c),
  //    iconImageAssetPath: 'assets/',
      body: Text(
        'Easy  & Safe Cash on Delivery System ',
      ),
      title: Text('Fast & Safe Delivery'),
      mainImage: Image.asset(
        'assets/del.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      titleTextStyle: TextStyle(fontFamily: 'Roboto', color: Colors.white),
      bodyTextStyle: TextStyle(fontFamily: 'Roboto', color: Colors.white),
    ),
  ];
@override
  Future<void> initState()  {
    // TODO: implement initState
    super.initState();
test();

  }
void test() async{
   bool  data= await SharedPrefManager.isUserLogedIn();
 print(data);
 if(data!=null){
    Navigator.popAndPushNamed(context, '/Loginpage');
 }
 
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body:  IntroViewsFlutter(
          pages,
          showNextButton: true,
          showBackButton: true,
          onTapDoneButton: () {
           Navigator.push(context, CupertinoPageRoute(builder: (_)=>LoginPage()));
             //MaterialPageRoute
            // Navigator.pop(context);
        // Navigator.popAndPushNamed(context,'/LoginPage');
          },
          pageButtonTextStyles: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),     
    );
  }


}