import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gigchat/constants.dart';
import 'package:gigchat/components/rounded_button.dart';
import 'package:gigchat/screens/chatlist_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {

  static String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDeclaration.copyWith(
                  hintText: 'Enter your Email...'
                )
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                controller: passCtrl,
                  obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDeclaration.copyWith(
                  hintText: 'Enter your Password...'
                )
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                  color: Colors.orange,
                  title: 'Login',
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });

                    if(email==null && password==null){
                      Fluttertoast.showToast(
                          msg: 'Please Enter Something!',
                          toastLength: Toast.LENGTH_SHORT);
                    }else{
                      emailCtrl.clear();
                      passCtrl.clear();
                      try {
                        final user = await _auth.signInWithEmailAndPassword(email: email, password: password);
                        if(user != null){
                          Navigator.pushReplacementNamed(context, ChatListScreen.id);
                        }
                      } on FirebaseAuthException catch (e) {
                        if(e.code == 'user-not-found'){
                          Fluttertoast.showToast(
                              msg: 'No such account!',
                              toastLength: Toast.LENGTH_LONG);
                        }else if (e.code == 'wrong-password'){
                          Fluttertoast.showToast(
                              msg: 'Wrong Email or Password!',
                              toastLength: Toast.LENGTH_LONG);
                        }
                      }
                    }
                    setState(() {
                        showSpinner = false;
                      });
                  }),
            ],
          ),
        ),
      ),
    );
  }
}