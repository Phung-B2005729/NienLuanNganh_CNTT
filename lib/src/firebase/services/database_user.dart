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
      "avata":
          "https://firebasestorage.googleapis.com/v0/b/apparch-351df.appspot.com/o/images%2F1696494580475.jpg?alt=media&token=7f48e133-6caa-45cb-807c-bfa42c46054b",
      "anhnen": "",
      "hopchat": [],
    });
  }

  getALLUser() async {
    return userCollection.snapshots();
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

  // updata anh
  Future<void> updateUser(String iduser, String URL) async {
    return userCollection.doc(iduser).update({'avata': URL});
  }

  Future timKiemUser(String value) async {
    return await userCollection
        .where("username", isGreaterThanOrEqualTo: value)
        .where("username", isLessThan: value + 'z')
        .snapshots();
  }
}
