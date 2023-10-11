import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseTheLoai {
  final CollectionReference theLoaiColection =
      FirebaseFirestore.instance.collection('theloai');

  //
  getALLTheLoai() async {
    return theLoaiColection.snapshots();
  }

  Future getOneTheLoaiThepId(String idtheloai) async {
    return theLoaiColection.doc(idtheloai).get();
  }

  Future getIdTheLoai(String name) async {
    QuerySnapshot snapshot =
        await theLoaiColection.where("tenloai", isEqualTo: name).get();
    return snapshot.docs[0]['idloai'].toString();
  }

  Future getNameTheLoai(String idtheloai) async {
    QuerySnapshot snapshot =
        await theLoaiColection.where("idloai", isEqualTo: idtheloai).get();
    return snapshot.docs[0]['tenloai'].toString();
  }
}
