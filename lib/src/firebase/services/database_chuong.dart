import 'package:apparch/src/model/chuong_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseChuong {
  String? idchuong;
  DatabaseChuong({this.idchuong});

  final CollectionReference truyenColection =
      FirebaseFirestore.instance.collection('truyen');
  //
// chuong
  Future createChuong(ChuongModel chuongModel, String idtruyen) async {
    DocumentReference chuongDocument = await truyenColection
        .doc(idtruyen)
        .collection('chuong')
        .add(chuongModel.toMap());
    return await chuongDocument.update({
      "idchuong": chuongDocument.id // update idchuong;
    });
  }

// lay tat ca chuong theo truyen
  getALLChuongSnapshots(String idtruyen, bool des) async {
    // ignore: await_only_futures
    return truyenColection
        .doc(idtruyen)
        .collection("chuong")
        .orderBy('ngaycapnhat', descending: des)
        .snapshots();
  }

//
  Future getALLChuongSX(String idtruyen, bool des) async {
    return truyenColection
        .doc(idtruyen)
        .collection("chuong")
        .orderBy('ngaycapnhat', descending: des)
        .get();
  }

  // lay 5 chuong cuoi cung
  Future getLimitChuong(String idtruyen) async {
    return truyenColection
        .doc(idtruyen)
        .collection('chuong')
        .orderBy('ngaycapnhat', descending: true)
        .limit(5)
        .get();
  }

  // lay noi dung 1 chuong
  Future getIdChuong(String idtruyen) async {
    return truyenColection
        .doc(idtruyen)
        .collection('chuong')
        .doc(idchuong)
        .snapshots();
  }
}
