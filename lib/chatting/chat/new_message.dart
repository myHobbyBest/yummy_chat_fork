

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'globals.dart' as globals;
import 'is_first_chat.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  var _userEnterMessage = '';
  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final _user = FirebaseAuth.instance.currentUser;
    final _userData = await FirebaseFirestore.instance.collection('user').doc(_user!.uid).get();

      isFirstChat(_user!.uid);

     if ( globals.userData[ _user.uid]==null) {

   //    print(' isSignUpUser at new message' );
       FirebaseFirestore.instance.collection('chat').add({
         'text': _userEnterMessage,
         'time': Timestamp.now(),
         'userID': _user.uid,
         'userImage' : _userData.data()!['picked_image'],
         'userName' : _userData.data()!['userName']
       });

    } else {

       FirebaseFirestore.instance.collection('chat').add({
         'text': _userEnterMessage,
         'time': Timestamp.now(),
         'userID': _user.uid
       });

        var docId;
        CollectionReference _collectionChatRef = FirebaseFirestore.instance.collection('chat');
        QuerySnapshot queryChatSnapshot = await _collectionChatRef .orderBy('time', descending: true).get();
        final allId = queryChatSnapshot.docs.map((doc) => doc.id ).toList();
        final allChat = queryChatSnapshot.docs.map((doc) => doc.data()).toList();

      //  print('allChat ${allChat}') ;

        for (var i = 0; i < allId.length; i++) {
        //    userChat[ allId[i] ] = allChat[i];
            var chat= allChat[i] as Map;

          if (chat['userImage']!=null  && chat['userID']==_user.uid){
              docId=allId[i];
          //    print('ch: ${ i } ::: ${ch}') ;
              break;
            }
        }

    //    print('docId ${docId} userChat[docId] ${userChat[docId ]}') ;
          if(docId!=null){
            final docRef = _collectionChatRef.doc(docId);
            final updates = <String, dynamic>{
              "userName": FieldValue.delete(),
              "userImage": FieldValue.delete(),
            };
            docRef.update(updates);
          }

          isFirstChat(_user!.uid);
     }
        _controller.clear();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 8.0,
      ),
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              maxLines: null,
              controller: _controller,
              decoration: InputDecoration(labelText: 'Send a message...'),
              onChanged: (value) {
                setState(() {
                  _userEnterMessage =value;
                });
             },
            ),
          ),
          IconButton(
            onPressed: _userEnterMessage.trim().isEmpty ? null :_sendMessage,
            icon: Icon(Icons.send),
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}
