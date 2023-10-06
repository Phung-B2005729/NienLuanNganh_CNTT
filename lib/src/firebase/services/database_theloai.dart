import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseTheLoai {
  final CollectionReference theLoaiColection =
      FirebaseFirestore.instance.collection('theloai');

  //
  getALLTheLoai() async {
    return theLoaiColection.snapshots();
  }

  Future getTheLoaiId(String idtheloai) async {
    return FirebaseFirestore.instance
        .collection('theloai')
        .doc(idtheloai)
        .get();
  }
}
