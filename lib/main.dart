import 'package:flutter/material.dart';
import 'package:gigchat/screens/chatlist_screen.dart';
import 'package:gigchat/screens/welcome_screen.dart';
import 'package:gigchat/screens/login_screen.dart';
import 'package:gigchat/screens/registration_screen.dart';
import 'package:gigchat/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id : (context) => WelcomeScreen(),
        LoginScreen.id : (context) => LoginScreen(),
        RegistrationScreen.id : (context) => RegistrationScreen(),
        ChatListScreen.id : (context) => ChatListScreen(),
        ChatScreen.id : (context) => ChatScreen()
      },
    );
  }
}