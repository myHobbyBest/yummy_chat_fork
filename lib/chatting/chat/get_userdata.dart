
import 'package:cloud_firestore/cloud_firestore.dart';
import 'globals.dart' as globals;

Future getUserData(_userId , index) async {

  Map userData={};
  bool _isNewUser=true;
  CollectionReference _collectionRef =
  FirebaseFirestore.instance.collection('user');

  QuerySnapshot querySnapshot = await _collectionRef.get();//.orderBy('time', descending: false)
  final allId = querySnapshot.docs.map( (doc) => doc.id ).toList();
  final allData = querySnapshot.docs.map( (doc) => doc.data() ).toList();
  
    for (var i = 0; i < allId.length; i++) {
      userData[ allId[i] ] = allData[i];
      if (index==0 && allId[i] == _userId) {
        _isNewUser = false;
  //      print('${i} :: ${ allId[i] }  == ${ _userId } ==> ${ _isNewUser } ');
      }
    }
  globals.userData = userData;
  globals.isSignUpUser = _isNewUser;
}
