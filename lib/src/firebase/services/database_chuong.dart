import 'package:apparch/src/helper/date_time_function.dart';
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
    await chuongDocument.update({
      "idchuong": chuongDocument.id // update idchuong;
    });
    return chuongDocument.id;
  }

// lay tat ca chuong theo truyen
  getALLChuongSnapshots(String idtruyen, bool des, bool dkbanthao) async {
    // ignore: await_only_futures
    if (dkbanthao == false) {
      return truyenColection
          .doc(idtruyen)
          .collection("chuong")
          .orderBy('ngaycapnhat', descending: des)
          .snapshots();
    } else {
      return truyenColection
          .doc(idtruyen)
          .collection("chuong")
          .where('tinhtrang', isEqualTo: 'Đã đăng')
          .orderBy('ngaycapnhat', descending: des)
          .snapshots();
    }
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
        .get();
  }

// xoa
  Future deleteOneChuong(String idtruyen) async {
    return truyenColection
        .doc(idtruyen)
        .collection('chuong')
        .doc(idchuong)
        .delete();
  }

  Future updateTinhTrangChuong(String idtruyen, String tinhtrang) async {
    return await truyenColection
        .doc(idtruyen)
        .collection('chuong')
        .doc(idchuong)
        .update({
      'tinhtrang': tinhtrang,
      'ngaycapnhat': DatetimeFunction.getTimeToInt(DateTime.now())
    });
  }

  Future<void> updateAllTinhTrangChuong(
      String idtruyen, String tinhtrang) async {
    QuerySnapshot chuongSnapshot = await truyenColection
        .doc(idtruyen)
        .collection('chuong')
        .orderBy('ngaycapnhat')
        .get();

    for (QueryDocumentSnapshot chuongDoc in chuongSnapshot.docs) {
      await chuongDoc.reference.update({
        'tinhtrang': tinhtrang,
        'ngaycapnhat': DatetimeFunction.getTimeToInt(DateTime.now())
      });
    }
  }

  Future<void> updateOneChuong(
      String idtruyen, String idchuong, Map<String, dynamic> map) async {
    return await truyenColection
        .doc(idtruyen)
        .collection('chuong')
        .doc(idchuong)
        .update(map);
  }
}
