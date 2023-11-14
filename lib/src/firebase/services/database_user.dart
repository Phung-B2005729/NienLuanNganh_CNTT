import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseUser {
  final String? uid;
  DatabaseUser({this.uid});

  // reference for our collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference thuvienCollection =
      FirebaseFirestore.instance.collection("thuvien");

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
  Future<void> updateAvataUser(String iduser, String URL) async {
    return userCollection.doc(iduser).update({'avata': URL});
  }

  Future timKiemUser(String value) async {
    return await userCollection
        .where("username", isGreaterThanOrEqualTo: value)
        .where("username", isLessThan: value + 'z')
        .snapshots();
  }
  //thuvien

  Future createThuVien(String iduser, String idtruyen) async {
    // print('gọi create');
    Map<String, dynamic> thuvien = {
      'idtruyen': idtruyen,
      'chuongdadoc': 0,
    };
    await userCollection
        .doc(iduser)
        .collection('thuvien')
        .doc(idtruyen)
        .set(thuvien);
    //  await dsDocument.update({'iddanhsach': dsDocument.id});
  }

  Future deleteOneTruyenOnThuVien(String iduser, String idtruyen) async {
    // print('gọi delete');
    return userCollection
        .doc(iduser)
        .collection('thuvien')
        .doc(idtruyen)
        .delete();
  }

  getALLTruyenThuVien(String iduser) async {
    return userCollection.doc(iduser).collection('thuvien').snapshots();
  }

  Future getALLTruyenThuVienGet(String iduser) async {
    return userCollection.doc(iduser).collection('thuvien').get();
  }

  Future updateChuongDaDoc(String idu, String idtruyen, int chuongdadoc) async {
    return userCollection
        .doc(idu)
        .collection('thuvien')
        .doc(idtruyen)
        .update({'chuongdadoc': chuongdadoc});
  }

  Future getOneTruyenThuVien(String idu, String idtruyen) {
    return userCollection.doc(idu).collection('thuvien').doc(idtruyen).get();
  }
}
