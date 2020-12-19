import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bigagora24/Models/Users.dart';
import 'package:bigagora24/utils/SharedPrefManager.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
class ImagePro extends StatefulWidget {
  @override
  _ImageProState createState() => _ImageProState();
}

class _ImageProState extends State<ImagePro> {

  static final String uploadEndPoint =
      'http://bigagora24.com/apps/uploadinfo.php';
  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';
  Users user;
 
  chooseImage() {
    setState(() {
    //  file = ImagePicker.pickImage(source: ImageSource.gallery);
    });
    setStatus('');
  }
 
  setStatus(String message) {
    setState(() {
      status = message;
    });
  }
 
  startUpload() {
    setStatus('Uploading Image...');
    if (null == tmpFile) {
      setStatus(errMessage);
      return;
    }
    String fileName = tmpFile.path.split('/').last;
   _upload(fileName);
  }
   Future<void> initProfile() async {
    Users u = await SharedPrefManager.getUserProfile();
    //    Products u1 = await SharedPrefManager.getProducts();
    setState(() {
      user = u;
    //_setdatas();
  //  _getData();
    });
  }
Future _upload( String filename)async{
  print(base64Image);
  var response= await http.post(uploadEndPoint,body:{
      'email':user.email.toString(),
      'fname':filename,
      'fimage':base64Image,
  });
  print(response);
}
  // upload(String fileName) {
  //   print(fileName);
  //   print(base64Image);
  //   http.post(uploadEndPoint, body: {
  //     "email":user.email.toString(),
  //     "fname": fileName,
  //     "fimage": base64Image,
      
  //   }).then((result) {
  //     setStatus(result.statusCode == 200 ? result.body : errMessage);
  //   }).catchError((error) {
  //     setStatus(error);
  //   });
  // }
 
  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return Flexible(
            child: Image.file(
              snapshot.data,
              fit: BoxFit.fill,
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            OutlineButton(
              onPressed: chooseImage,
              child: Text('Choose Image'),
            ),
            SizedBox(
              height: 20.0,
            ),
            showImage(),
            SizedBox(
              height: 20.0,
            ),
            OutlineButton(
              onPressed: startUpload,
              child: Text('Upload Image'),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              status,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w500,
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    
    );
  }
}