import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gigchat/screens/welcome_screen.dart';

import 'chat_screen.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;

class ChatListScreen extends StatefulWidget {

  static String id = 'chatlist_screen';

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {

  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if(user != null){
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: Text('⚡️List of Chats'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: SafeArea(
        child: MessagesStream(),
        ),
      );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('messages')
            .orderBy('time', descending: false)
            .snapshots(),
        builder: (context, snapshot){
          if (!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.orangeAccent,
              ),
            );
          }
          final messages = snapshot.data.docs;
          List<String> emailsOnly = [];
          final currentUser = loggedInUser.email;
          for (var message in messages){
            final messageSender = message.data()['sender'];
            final messageReceiver = message.data()['receiver'];
            if(messageSender != currentUser) {
              emailsOnly.add(messageReceiver);
              emailsOnly.add(messageSender);
            }
          }
          List<String> listOfUsers = emailsOnly.toSet().toList();
          listOfUsers.remove(currentUser);
          return ListView.builder(
              itemCount: listOfUsers.length,
              itemBuilder: (context, i){
                return ListTile(
                  title: Text('${listOfUsers[i]}'),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => ChatScreen(chatWith: listOfUsers[i])));
                  },
                );
              });
        });
  }
}