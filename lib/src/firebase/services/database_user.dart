import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseUser {
  final String? uid;
  DatabaseUser({this.uid});

  // reference for our collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  // saving the userdata
  // ignore: non_constant_identifier_names
  Future savingUserData(String UserName, String email) async {
    return await userCollection.doc(uid).set({
      "uid": uid,
      "username": UserName,
      "fullname": "",
      "email": email,
      "ngaysinh": "",
      "avata": "avatarmacdinh.png",
      "anhnen": "",
      "hopchat": [],
    });
  }

  // getting user data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  Future gettingUsernameData(String us) async {
    QuerySnapshot snapshot =
        await userCollection.where("username", isEqualTo: us).get();
    return snapshot;
  }

  // thong tin nguoi dung id
  Future gettingUserIDData() async {
    QuerySnapshot snapshot =
        await userCollection.where("uid", isEqualTo: uid).get();
    return snapshot;
  }
}
