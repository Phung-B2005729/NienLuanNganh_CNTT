import 'package:apparch/src/firebase/services/database_truyen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseDSDoc {
  final CollectionReference dsCollection =
      FirebaseFirestore.instance.collection("danhsachdoc");
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
      'iduser': UserID
    };
    DocumentReference dsDocument = await dsCollection.add(danhsachdoc);
    await dsDocument.update({'iddanhsach': dsDocument.id});
  }

  // tao va them
  Future createNewInsert(
      String iduser, String idtruyen, String tentruyen) async {
    Map<String, dynamic> danhsachdoc = {
      'iddanhsach': '',
      'tendanhsachdoc': tentruyen,
      'danhsachtruyen': [],
      'iduser': iduser
    };
    DocumentReference dsDocument = await dsCollection.add(danhsachdoc);
    await dsDocument.update({'iddanhsach': dsDocument.id});
    await DatabaseTruyen().insertDSDocGia(dsDocument.id, idtruyen);
    return inserTruyen(dsDocument.id, idtruyen);
  }

  // get danh sach doc cua nguoi dung
  getALLDanhSachDoc(String idu) async {
    return await dsCollection.where('iduser', isEqualTo: idu).snapshots();
  }

  //
  Future inserTruyen(String iddanhsach, String idtruyen) async {
    return dsCollection.doc(iddanhsach).update({
      'danhsachtruyen': FieldValue.arrayUnion([idtruyen])
    });
  }

  // delte one ds
  Future deleteOneDs(String idds) async {
    return dsCollection.doc(idds).delete();
  }

// delete
  Future deleteTruyen(String iddanhsach, String idtruyen) async {
    return await dsCollection.doc(iddanhsach).update({
      'danhsachtruyen': FieldValue.arrayRemove([idtruyen])
    });
  }

  Future updateName(String idds, String name) async {
    return dsCollection.doc(idds).update({'tendanhsachdoc': name});
  }

  // kiemtratruyen co nam danh sach hay chua
  Future<bool> kiemTraDSTruyen(String idtruyen, String idds) async {
    var ds = await dsCollection.doc(idds).get();
    for (var i = 0; i < ds['danhsachtruyen'].length; i++) {
      if (idtruyen == ds['danhsachtruyen'][i].toString()) {
        return true;
      }
    }
    return false;
  }

  Future<void> deleteTruyenTrongDSDoc(String idtruyen) async {
    var danhSachDocs = await dsCollection.get();
    for (var doc in danhSachDocs.docs) {
      await deleteTruyen(doc.id, idtruyen);
    }
  }
}
