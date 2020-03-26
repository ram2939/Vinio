import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:streaming_app/MainPage.dart';
import 'package:streaming_app/my_flutter_app_icons.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:provider/provider.dart';
// import 'package:streaming_app/HomePage.dart';
// import 'package:streaming_app/Widgets/textField.dart';
class SignIn extends StatefulWidget {
  @override
  SignInState createState() => SignInState();
}

class SignInState extends State<SignIn> {
  String email = "", password = "";
  TextEditingController _email, _pass;
  bool showPass = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> _handleSignIn(BuildContext context) async {
    final storage = FlutterSecureStorage();
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    await storage.write(key: "1", value: "google");
    await storage.write(key: "2", value: googleAuth.accessToken);
    await storage.write(key: "3", value: googleAuth.idToken);
    print("signed in " + user.displayName);
    return user;
  }

  String message = "";
  @override
  Widget build(BuildContext context) {
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
        // borderRadius: BorderRadius.circular(50),
        borderSide: BorderSide(color: Colors.black));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFA817E),
        title: Padding(
            padding: EdgeInsets.only(left: 100), child: Text("Sign In")),
        // toolbarOpacity: 1,
      ),

      // backgroundColor: Color(0xffFA817E),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    top: 60, left: 20, right: 20, bottom: 10),
                child: TextFormField(
                  // textAlign: TextAlign.center,
                  controller: _email,
                  onChanged: (input) {
                    setState(() {
                      email = input;
                    });
                  },
                  validator: (input) {
                    if (input.isEmpty) return "Enter the Email ID";
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                    hintText: "Email",
                    enabledBorder: outlineInputBorder,
                    focusedBorder: outlineInputBorder,
                    errorBorder: outlineInputBorder,
                    focusedErrorBorder: outlineInputBorder,
                  ),
                  onSaved: (input) {
                    email = input;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, left: 20, bottom: 10, right: 20),
                child: TextFormField(
                  // textAlign: TextAlign.center,
                  controller: _pass,
                  validator: (input) {
                    if (input.length < 6)
                      return "Password needs to be greater than 6 characters";
                  },
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: showPass == true
                            ? Icon(MyFlutterApp.eye)
                            : Icon(MyFlutterApp.eye_off),
                        onPressed: () {
                          setState(() {
                            showPass = !showPass;
                          });
                        },
                      ),
                      hintStyle: TextStyle(color: Colors.black),
                      filled: true,
                      hintText: "Password",
                      fillColor: Colors.white,
                      enabledBorder: outlineInputBorder,
                      focusedBorder: outlineInputBorder,
                      errorBorder: outlineInputBorder,
                      focusedErrorBorder: outlineInputBorder),
                  onSaved: (input) {
                    password = input;
                  },
                  obscureText: !showPass,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 200, bottom: 20),
                child: GestureDetector(
                  onTap: () async {
                    if (email.isNotEmpty) {
                      try {
                        await FirebaseAuth.instance
                            .sendPasswordResetEmail(email: email);
                        showAlert(
                            context,
                            "The email for reset password has been successfully sent to your email id",
                            "Reset Passwor Mail sent");
                      } catch (e) {
                        showAlert(context, e.message, "Cannot Reset Password");
                      }
                    } else {
                      showAlert(
                          context, "Email is empty", "Cannot Reset Password");
                    }
                  },
                  child: Container(
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                child: Container(
                  child: Center(child: Text("Sign In")),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Color(0xffFA817E)),
                  height: 50,
                  width: 150,
                ),
                onTap: () {
                  signin(context);
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, left: 00, bottom: 10),
                child: Text(
                  "Or Sign in with",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(0),
                child: IconButton(
                  icon: Icon(MyFlutterApp.gplus_squared),
                  iconSize: 80,
                  onPressed: () {
                    _handleSignIn(context).then((FirebaseUser user) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainPage(user)));
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signin(BuildContext context) async {
    final storage = FlutterSecureStorage();
    final formState = formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        FirebaseUser user = (await FirebaseAuth.instance
                .signInWithEmailAndPassword(email: email, password: password))
            .user;
        await storage.write(key: "1", value: "email");
        await storage.write(key: "2", value: email);
        await storage.write(key: "3", value: password);
        Navigator.pop(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainPage(user)));
      } catch (e) {
        print(e.message);
        showAlert(context, e.message, "Cannot Sign In");
      }
    }
  }

  void showAlert(BuildContext context, String x, String y) {
    var alert = AlertDialog(title: Text(y), content: Text(x));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }
}
