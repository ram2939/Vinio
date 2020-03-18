import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:streaming_app/HomePage.dart';
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
    _children=[HomePage(user),Profile(user)];
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
     appBar: AppBar(
       title: Text(user.email),
       backgroundColor: Colors.pink[300],
     ),
     bottomNavigationBar: BottomNavigationBar(
       unselectedItemColor: Colors.black,
       selectedItemColor: Colors.white,
       backgroundColor: Colors.pink[300],
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
           icon: Icon(Icons.person),
           title: Text('Profile')
         )
       ],
     ),
     body: _children[currentIndex],
   );
 
  }
}
