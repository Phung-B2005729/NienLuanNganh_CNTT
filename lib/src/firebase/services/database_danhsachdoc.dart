import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseDSDoc {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  // ignore: unused_field
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  // tao danh sach doc
  // ignore: non_constant_identifier_names
  Future createDanhSachDoc(String UserID, String NameDS) async {
    // ignore: non_constant_identifier_names
    Map<String, dynamic> danhsachdoc = {
      'iddanhsach': '',
      'tendanhsachdoc': NameDS,
      'danhsachtruyen': [],
    };
    DocumentReference dsDocument = await userCollection
        .doc(UserID)
        .collection("danhsachdoc")
        .add(danhsachdoc);
    await dsDocument.update({'iddanhsach': dsDocument.id});
  }

  // tao va them
  Future createNewInsert(
      String iduser, String idtruyen, String tentruyen) async {
    Map<String, dynamic> danhsachdoc = {
      'iddanhsach': '',
      'tendanhsachdoc': tentruyen,
      'danhsachtruyen': [],
    };
    DocumentReference dsDocument = await userCollection
        .doc(iduser)
        .collection("danhsachdoc")
        .add(danhsachdoc);
    await dsDocument.update({'iddanhsach': dsDocument.id});
    return inserTruyen(iduser, dsDocument.id, idtruyen);
  }

  // get danh sach doc
  getALLDanhSachDoc(String idu) {
    return userCollection.doc(idu).collection('danhsachdoc').snapshots();
  }

  //
  Future inserTruyen(String iduser, String iddanhsach, String idtruyen) async {
    return await userCollection
        .doc(iduser)
        .collection('danhsachdoc')
        .doc(iddanhsach)
        .update({
      'danhsachtruyen': FieldValue.arrayUnion([idtruyen])
    });
  }

// delete
  Future deleteTruyen(String iduser, String iddanhsach, String idtruyen) async {
    return await userCollection
        .doc(iduser)
        .collection('danhsachdoc')
        .doc(iddanhsach)
        .update({
      'danhsachtruyen': FieldValue.arrayRemove([idtruyen])
    });
  }

  // kiemtratruyen co nam danh sach hay chua
  Future<bool> kiemTraDSTruyen(
      String idtruyen, String iduser, String idds) async {
    var ds = await userCollection
        .doc(iduser)
        .collection('danhsachdoc')
        .doc(idds)
        .get();
    for (var i = 0; i < ds['danhsachtruyen'].length; i++) {
      if (idtruyen == ds['danhsachtruyen'][i].toString()) {
        return true;
      }
    }
    return false;
  }
}
