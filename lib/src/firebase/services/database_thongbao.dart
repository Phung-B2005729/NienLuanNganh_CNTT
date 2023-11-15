import 'package:apparch/src/model/thongbao_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseThongBao {
  final String? id;
  DatabaseThongBao({this.id});

  // reference for our collections
  final CollectionReference thongbaoCollection =
      FirebaseFirestore.instance.collection("thongbao");

  // saving the userdata
  // ignore: non_constant_identifier_names
  Future<ThongBaoModel> createthongbao(ThongBaoModel thongBaoModel) async {
    DocumentReference thongbaoDocument =
        await thongbaoCollection.add(thongBaoModel.toMap());
    await thongbaoDocument.update({"id": thongbaoDocument.id});
    return thongBaoModel.copyWith(id: thongbaoDocument.id);
  }

  Future<ThongBaoModel?> getOnethongbao(String id) async {
    // ignore: unused_local_variable
    DocumentSnapshot thongbaoSnapshot = await thongbaoCollection.doc(id).get();
    if (thongbaoSnapshot.exists) {
      Map<String, dynamic> thongbaoData =
          thongbaoSnapshot.data() as Map<String, dynamic>;
      return ThongBaoModel.fromJson(thongbaoData);
    } else {
      // Xử lý trường hợp không tìm thấy
      return null;
    }
  }

  Future<List<ThongBaoModel>> getALLthongbao() async {
    // ignore: unused_local_variable
    QuerySnapshot thongbaoQuery = await thongbaoCollection.get();
    List<ThongBaoModel> thongbaoList = [];

    for (QueryDocumentSnapshot thongbaoSnapshot in thongbaoQuery.docs) {
      if (thongbaoSnapshot.exists) {
        Map<String, dynamic> thongbaoData =
            thongbaoSnapshot.data() as Map<String, dynamic>;
        ThongBaoModel thongBaoModel = ThongBaoModel.fromJson(thongbaoData);
        thongbaoList.add(thongBaoModel);
      }
    }
    return thongbaoList;
  }

  Future insertDanhSachIdUser(String idthongbao, String idIdUser) async {
    return await thongbaoCollection.doc(idthongbao).update({
      'danhsachiduser': FieldValue.arrayUnion([idIdUser])
    });
  }

  Future deleteDanhSachIdUser(String idthongbao, String idIdUser) async {
    return await thongbaoCollection.doc(idthongbao).update({
      'danhsachiduser': FieldValue.arrayRemove([idIdUser])
    });
  }

  Future insertDanhSachIdUserDaDoc(String idthongbao, String idIdUser) async {
    return await thongbaoCollection.doc(idthongbao).update({
      'danhsachiduserdadoc': FieldValue.arrayUnion([idIdUser])
    });
  }

  Future deleteDanhSachIdUserDaDoc(String idthongbao, String idIdUser) async {
    return await thongbaoCollection.doc(idthongbao).update({
      'danhsachiduserdadoc': FieldValue.arrayRemove([idIdUser])
    });
  }

  Future deleteOnethongbao(String idthongbao) async {
    return await thongbaoCollection.doc(idthongbao).delete();
  }

  Future updateOnethongbao(
      String idthongbao, ThongBaoModel thongBaoModel) async {
    return await thongbaoCollection
        .doc(idthongbao)
        .update(thongBaoModel.toMap());
  }
}
