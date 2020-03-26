// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:streaming_app/HomePage.dart';
import 'package:streaming_app/SignIn.dart';
import 'package:streaming_app/Signup.dart';
import 'package:permission_handler/permission_handler.dart';

class LoginPage extends StatelessWidget {
  requestPermissions() async {
    await PermissionHandler().requestPermissions([
      PermissionGroup.storage,
      PermissionGroup.photos,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    requestPermissions();
    BoxDecoration decoration = BoxDecoration(
      // border: Border.all(),
        borderRadius: BorderRadius.circular(40), color: Color(0xffFA817E));

    return Scaffold(
      // appBar: AppBar(
      //     title: Center(child: Text("Vinio")),
      //     backgroundColor: Color(0xffFA817E)),
      body: SafeArea(
        child: Center(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(padding: const EdgeInsets.only(bottom: 10),
              child: Center(child: Text("Vinio",
              style: TextStyle(
                fontSize: 100,
                fontWeight: FontWeight.bold
              ),)),),
             Padding(
               padding: const EdgeInsets.only(top: 10.0),
               child: Image(image: AssetImage("assets/logo.png"),
               height: 200,
               ),
             ),
             Padding(
               padding: const EdgeInsets.only(top: 50,bottom: 20),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: <Widget>[
                   
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: <Widget>[
                       Text("Experience  ",
                       textAlign: TextAlign.center,
                       style: TextStyle(
                         color: Colors.grey,
                         fontSize: 35,
                       ),
                       ),
                       Text("the",
                       textAlign: TextAlign.center,
                       style: TextStyle(
                         color: Colors.grey,
                         fontSize: 25,
                       ),
                       ),
                     ],
                   ),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: <Widget>[
                       Text("Future  ",
                       textAlign: TextAlign.center,
                       style: TextStyle(
                         color: Colors.grey,
                         fontSize: 35,
                       ),
                       ),
                       Text("of",
                       textAlign: TextAlign.center,
                       style: TextStyle(
                         color: Colors.grey,
                         fontSize: 25,
                       ),
                       ),
                     ],
                   ),
                   Text("Expressions",
                      //  textAlign: TextAlign.center,
                       style: TextStyle(
                         color: Colors.grey,
                         fontSize: 35,
                       ),
                       ),

                 ],
               ),
             ),


              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  child: Container(
                    decoration: decoration,
                    height: 50,
                    width: 150,
                    child: Center(child: Text("Sign In")),
                  ),
                  onTap: () {
                    print("Signin tapped");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignIn()));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  child: Container(
                    decoration: decoration,
                    height: 50,
                    width: 150,
                    child: Center(child: Text("Sign Up")),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUp()));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
