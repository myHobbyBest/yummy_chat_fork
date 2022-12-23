
import 'package:cloud_firestore/cloud_firestore.dart';
import 'globals.dart' as globals;

Future isFirstChat(userId ) async {
   bool _isFirst = true;
  CollectionReference _collectionChatRef = FirebaseFirestore.instance.collection('chat');
  QuerySnapshot queryChatSnapshot = await _collectionChatRef .orderBy('time', descending: true).get();
  final allChat = queryChatSnapshot.docs.map((doc) => doc.data()).toList();

  int ii=0;
   allChat.forEach((datas) {
     Map data = datas as Map;
     if (data['userID'] == userId) {//_user!.uid) {
       ii++;   
       _isFirst = false;
     }
   });
    globals.count=ii;
    if (_isFirst == false) { globals.isFirstChat = false;}
    else  { globals.isFirstChat = true;};

 globals.isChatDoc=false;
  int i=0;
  for (var datas in allChat) {
    i=i+1;
    Map data = datas as Map;
    if (data.containsKey('userName') ) {
      globals.isChatDoc=true;
  //    print('####### userName :"${data['userName'] }" This ChatDoc is not empty #######');
    }else{
  //    print('####### ${data['userID'] } This ChatDoc is empty #######');
    }
    if (i==1) {break;}
  };
  

}