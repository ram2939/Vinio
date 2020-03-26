import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:streaming_app/SignIn.dart';
import 'package:streaming_app/my_flutter_app_icons.dart';
class SignUp extends StatefulWidget {
  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  bool showPass=false;
  String email = "", password = "";
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    OutlineInputBorder outlineInputBorder= OutlineInputBorder(
                      // borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Colors.black,
                        // width: 2
                      )
                    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
        backgroundColor: Color(0xffFA817E),
      ),
      // backgroundColor: Colors.pink[100],
      body: SafeArea(
              child: Form(
          key: formKey,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 60,left: 20,right: 20,bottom: 10),
                child: TextFormField(
                  validator: (input) {
                    if (input.isEmpty) return "Enter the Email ID";
                  },
                  decoration: InputDecoration(
                    // labelText: "Email",
                    // labelStyle: TextStyle(
                    //   color: Theme.of(context).accentColor
                    // ),
                    fillColor: Colors.white,
                    filled: true,
                    hintStyle: TextStyle(
                      color:Colors.grey
                    ) ,
                    hintText: "Email",
                    enabledBorder: outlineInputBorder,
                    focusedErrorBorder: outlineInputBorder,
                    errorBorder: outlineInputBorder,
                    focusedBorder: outlineInputBorder,

                  ),
                  onSaved: (input) {
                    email = input;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20,top: 10,bottom:50),
                child: TextFormField(
                  validator: (input) {
                    if (input.length < 6)
                      return "Password needs to be greater than 6 characters";
                  },
                  decoration: InputDecoration(
                    // labelText: "Password",
                    // labelStyle: TextStyle(
                    //   color: Theme.of(context).accentColor
                    // ),
                    suffixIcon: IconButton(
                      icon: showPass==true
                      ? Icon(MyFlutterApp.eye)
                      : Icon(MyFlutterApp.eye_off),
                      onPressed: (){
                        setState(() {
                          showPass=!showPass;
                        });
                      },
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    hintStyle: TextStyle(
                      color:Colors.grey
                    ) ,
                    hintText: "Password",
                    enabledBorder: outlineInputBorder,
                    focusedErrorBorder: outlineInputBorder,
                    errorBorder: outlineInputBorder,
                    focusedBorder: outlineInputBorder,
  
                  ),
                  onSaved: (input) {
                    password = input;
                  },
                  obscureText: !showPass,
                ),
              ),
              GestureDetector(
                child: Container(child: Center(child: Text("Sign Up")),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Color(0xffFA817E)
                ),

                height: 50,
                width: 150,),
                onTap: () {
                  signup();
                },
              )
            
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signup() async {
    final formState = formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        FirebaseUser user = (await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                    email: email, password: password))
            .user;
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignIn()));
      } catch (e) {
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
