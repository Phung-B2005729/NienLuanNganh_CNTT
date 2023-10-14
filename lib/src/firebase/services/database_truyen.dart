import 'package:apparch/src/firebase/fire_base_storage.dart';
import 'package:apparch/src/helper/date_time_function.dart';
import 'package:apparch/src/model/truyen_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseTruyen {
  final String? idtruyen;
  DatabaseTruyen({this.idtruyen});

  final CollectionReference truyenColection =
      FirebaseFirestore.instance.collection('truyen');

  // tao moi truyen
  Future createTruyen(TruyenModel truyenModel) async {
    DocumentReference truyenDocument =
        await truyenColection.add(truyenModel.toMap()); // them truyen
    await truyenDocument.update({
      "idtruyen": truyenDocument.id // update idtruyen;
    });
    // ignore: avoid_print, prefer_interpolation_to_compose_strings
    print('Gọi hàm create truyenDocumentid' + truyenDocument.id.toString());
    return truyenDocument.id;
  }

  Future getTruyenId(String idtruyen) async {
    return truyenColection.doc(idtruyen).get();
  }

  // lay danh sach tat ca truyen theo dieukien
  getAllTruyenDK(String filequery, dynamic value) async {
    return truyenColection.where(filequery, isEqualTo: value).snapshots();
  }

  getAllTruyenDK2(String filequery, dynamic value, String filequery2,
      dynamic value2, bool ktr) async {
    if (ktr == true) {
      return truyenColection
          .where(filequery, isEqualTo: value)
          .where(filequery2, isEqualTo: value2)
          .snapshots();
    } else {
      return truyenColection
          .where(filequery, isEqualTo: value)
          .where(filequery2, isNotEqualTo: value2)
          .snapshots();
    }
  }

  // lay tat ca danh sach theo sap xep thu tu lớn đến bé
  getAllTruyenSapXep(String tencot) async {
    return truyenColection.orderBy(tencot, descending: true).snapshots();
  }

  getAllTruyenMoi() async {
    return truyenColection
        .where('tinhtrang', isNotEqualTo: 'Bản thảo')
        .orderBy('ngaycapnhat', descending: true)
        .snapshots();
  }

  // tat ca truyen
  getAllTruyen() async {
    return truyenColection.snapshots();
  }

  getALLTruyenNotBanThao() async {
    return truyenColection
        .where('tinhtrang', isNotEqualTo: 'Bản thảo')
        .snapshots();
  }

  Future getTheLoaiTruyen(String idtheloai) async {
    return FirebaseFirestore.instance
        .collection('theloai')
        .doc(idtheloai)
        .get();
  }
  // update

  Future<void> updateAnhTruyen(String idtruyen, String URL) async {
    truyenColection.doc(idtruyen).update({'linkanh': URL});
    return updataNgayCapNhat(idtruyen);
  }

  Future<void> updateOneTruyen(
      String idtruyen, Map<String, dynamic> map) async {
    return truyenColection.doc(idtruyen).update(map);
  }

  Future<void> updateTinhTrangTruyen(String idtruyen, String tinhtrang) async {
    truyenColection.doc(idtruyen).update({'tinhtrang': tinhtrang});
    return updataNgayCapNhat(idtruyen);
  }

  Future<void> updataNgayCapNhat(String idtruyen) {
    return truyenColection
        .doc(idtruyen)
        .update({'ngaycapnhat': DatetimeFunction.getTimeToInt(DateTime.now())});
  }

  Future<bool> kiemTraDSDocGia(String idtruyen, String iduser) async {
    var ds = await truyenColection.doc(idtruyen).get();
    for (var i = 0; i < ds['danhsachdocgia'].length; i++) {
      if (iduser == ds['danhsachdocgia'][i].toString()) {
        return true;
      }
    }
    return false;
  }

  Future deleleOneTruyen(String idtruyen) async {
    var documentReference = await truyenColection.doc(idtruyen).get();
    await FireStorage()
        .deleteImageFromStorage(documentReference['linkanh'].toString());
    return await truyenColection.doc(idtruyen).delete();
  }

  // them danh sach doc
  Future insertDSDocGia(String idu, String idtruyen) async {
    var ktr = await kiemTraDSDocGia(idtruyen, idu);
    if (ktr == false) {
      return await truyenColection.doc(idtruyen).update({
        'danhsachdocgia': FieldValue.arrayUnion([idu])
      });
    }
  }

  Future deleteDSDocGia(String idu, String idtruyen) async {
    var ktr = await kiemTraDSDocGia(idtruyen, idu);
    if (ktr == true) {
      return await truyenColection.doc(idtruyen).update({
        'danhsachdocgia': FieldValue.arrayRemove([idu])
      });
    }
  }

  Future timKiemTruyen(String value) async {
    return await truyenColection
        .where("tentruyen", isGreaterThanOrEqualTo: value)
        .where("tentruyen", isLessThan: value + 'z')
        .snapshots();
  }
}
