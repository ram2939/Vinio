import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:streaming_app/HomePage.dart';
import 'package:streaming_app/editVideo.dart';
import 'package:streaming_app/profile.dart';

class MainPage extends StatefulWidget{
  FirebaseUser user;
  MainPage(this.user);
  @override
  _MainPageState createState() => _MainPageState(user);
}

class _MainPageState extends State<MainPage> {
  int currentIndex=0;
  FirebaseUser user;
  _MainPageState(this.user);
  List<Widget> _children;
  @override
  void initState()
  {
    super.initState();
    _children=[HomePage(user),EditPage(user),Profile(user)];
  }

  _displayDeleteDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Are you sure want to exit'),
            actions: <Widget>[
              new FlatButton(
                child: new Text('NO'),
                onPressed: () {
                  Navigator.of(context).pop("false");
                },
              ),
              new FlatButton(
                  child: new Text('YES'),
                  onPressed: () {
                    exit(0);
                  })
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {

    return
     WillPopScope(
       onWillPop: (){
         _displayDeleteDialog(context);
       },
            child: Scaffold(
       appBar: AppBar(
         title: currentIndex==2
         ? Text(user.email)
         : currentIndex==1
          ? Center(child: Text("Edit Videos"))
          : Center(child: Text("My Videos")),
         backgroundColor: Color(0xffFA817E),
       ),
       bottomNavigationBar: BottomNavigationBar(
         unselectedItemColor: Colors.black,
         selectedItemColor: Colors.white,
         backgroundColor: Color(0xffFA817E),
         onTap: (int index){
           setState(() {
             currentIndex=index;
           });
         },
         currentIndex: currentIndex, // this will be set when a new tab is tapped
         items: [
           BottomNavigationBarItem(
             icon: new Icon(Icons.home),
             title: new Text('Home'),
             
           ),
           BottomNavigationBarItem(
             icon: Icon(Icons.edit),
             title: Text('Edit Video')
           ),
           BottomNavigationBarItem(
             icon: Icon(Icons.person),
             title: Text('Profile')
           )
         ],
       ),
       body: _children[currentIndex],
   ),
     );
 
  }
}
