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
        borderRadius: BorderRadius.circular(10), color: Colors.redAccent);

    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
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
