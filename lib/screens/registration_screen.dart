import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gigchat/components/rounded_button.dart';
import 'package:gigchat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gigchat/screens/chatlist_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {

  static String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

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
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDeclaration.copyWith(
                  hintText: 'Enter your Password (Min 7 char)...'
                )
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                color: Colors.orange,
                title: 'Register',
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  if(email==null && password==null){
                    Fluttertoast.showToast(
                        msg: 'Please Enter Something!',
                        toastLength: Toast.LENGTH_SHORT);
                  }else{
                    try{
                      final newUser = await _auth.createUserWithEmailAndPassword(
                          email: email,
                          password: password);
                      if(newUser != null){
                        await FirebaseFirestore.instance.collection('messages').add({
                          'text': "Welcome to GigChat!",
                          'sender': "official@gigchat.com",
                          'receiver': email,
                          'time': FieldValue.serverTimestamp()
                        });
                        Fluttertoast.showToast(
                            msg: 'Register Successful!',
                            toastLength: Toast.LENGTH_SHORT);
                        Navigator.pushReplacementNamed(context, ChatListScreen.id);
                      }
                    }catch (e){
                      Fluttertoast.showToast(
                          msg: 'Error: $e',
                          toastLength: Toast.LENGTH_SHORT);
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