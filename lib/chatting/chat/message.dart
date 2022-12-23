
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_bubble.dart';
import 'get_userdata.dart';
import 'globals.dart' as globals;
import 'is_first_chat.dart';

class Messages extends StatelessWidget {
   Messages({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = snapshot.data!.docs;

        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (context, index) {
            var  userId = chatDocs[index]['userID'].toString();
            isFirstChat( userId) ;

            if(index==0  )  {              
             getUserData(user!.uid, index);
              //  print('user!.uid:  ${user!.uid}');
              // print('globals.isSignUpUser:  ${globals.isSignUpUser}');
              // print('globals.isFirstChat:  ${globals.isFirstChat}');
            }

          
              if ( globals.userData[ userId]==null) {
                  return ChatBubbles(
                    chatDocs[index]['text'],
                    userId == user!.uid,
                    chatDocs[index]['userName'],
                    chatDocs[index]['userImage']
                );
              }
              else{
                return ChatBubbles(
                    chatDocs[index]['text'],
                    userId == user!.uid,
                    globals.userData[userId]!['userName'],
                    globals.userData[userId]!['picked_image']
                );
              }

          },
        );
      },
    );
  }
}
