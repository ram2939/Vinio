import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:streaming_app/HomePage.dart';
class SignIn extends StatefulWidget {
  @override
  SignInState createState() => SignInState();
}

class SignInState extends State<SignIn> {
  String email = "", password = "";
  TextEditingController _email, _pass;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
     OutlineInputBorder outlineInputBorder= OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Theme.of(context).accentColor,
                        width: 2
                      )
                    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _email,
                  validator: (input) {
                    if (input.isEmpty) return "Enter the Email ID";
                  },
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      color: Theme.of(context).accentColor
                    ),
                    labelText: "Email",
                    hintStyle: TextStyle(
                      color:Colors.grey,
                      
                    ) ,
                    hintText: "Enter the email id",
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
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _pass,
                  validator: (input) {
                    if (input.length < 6)
                      return "Password needs to be greater than 6 characters";
                  },
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      color: Theme.of(context).accentColor),
                    labelText: "Password",
                    hintStyle: TextStyle(
                      color:Colors.grey
                    ) ,
                    hintText: "Enter the Password",
                    fillColor: Colors.redAccent,
                    enabledBorder:outlineInputBorder ,
                    focusedBorder: outlineInputBorder,
                    errorBorder: outlineInputBorder,
                    focusedErrorBorder: outlineInputBorder
                  ),
                  onSaved: (input) {
                    password = input;
                  },
                  obscureText: true,
                ),
              ),
              GestureDetector(
                child: Container(child: Center(child: Text("Sign In")),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueAccent[400]
                ),

                height: 50,
                width: 150,),
                onTap: () {
                  signin();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signin() async {
    final formState = formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        FirebaseUser user = (await FirebaseAuth.instance
                .signInWithEmailAndPassword(email: email, password: password))
            .user;
         Navigator.pop(context);
         Navigator.pushReplacement(
             context, MaterialPageRoute(builder: (context) => new HomePage(user)));
      } catch (e) {
        print(e.message);
        showAlert(context, e.message);
      }
    }
  }

  void showAlert(BuildContext context, String x) {
    var alert = AlertDialog(title: Text("Cannot Sign In"), content: Text(x));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }
}
