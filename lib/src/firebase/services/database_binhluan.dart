import 'package:apparch/src/model/binhluan_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseBinhLuan {
  final String? id;
  DatabaseBinhLuan({this.id});

  // reference for our collections
  final CollectionReference binhluanCollection =
      FirebaseFirestore.instance.collection("binhluan");

  // saving the userdata
  // ignore: non_constant_identifier_names
  Future<BinhLuanModel> createBinhLuan(BinhLuanModel binhLuanModel) async {
    DocumentReference binhLuanDocument =
        await binhluanCollection.add(binhLuanModel.toMap());
    await binhLuanDocument.update({"id": binhLuanDocument.id});
    return binhLuanModel.copyWith(id: binhLuanDocument.id);
  }

  Future<BinhLuanModel?> getOneBinhLuan(String id) async {
    // ignore: unused_local_variable
    DocumentSnapshot binhLuanSnapshot = await binhluanCollection.doc(id).get();
    if (binhLuanSnapshot.exists) {
      Map<String, dynamic> binhLuanData =
          binhLuanSnapshot.data() as Map<String, dynamic>;
      return BinhLuanModel.fromJson(binhLuanData);
    } else {
      // Xử lý trường hợp không tìm thấy
      return null;
    }
  }

  Future<List<BinhLuanModel>> getALLBinhLuan() async {
    // ignore: unused_local_variable, non_constant_identifier_names
    QuerySnapshot BinhLuanQuery = await binhluanCollection
        .orderBy('ngaycapnhat', descending: false)
        .get();
    List<BinhLuanModel> BinhLuanList = [];

    for (QueryDocumentSnapshot BinhLuanSnapshot in BinhLuanQuery.docs) {
      if (BinhLuanSnapshot.exists) {
        Map<String, dynamic> binhLuanData =
            BinhLuanSnapshot.data() as Map<String, dynamic>;
        BinhLuanModel binhLuanModel = BinhLuanModel.fromJson(binhLuanData);
        BinhLuanList.add(binhLuanModel);
      }
    }
    return BinhLuanList;
  }

  Future deleteOneBinhLuan(String idBinhLuan) async {
    return await binhluanCollection.doc(idBinhLuan).delete();
  }

  Future updateOneBinhLuan(
      // ignore: non_constant_identifier_names
      String idBinhLuan,
      BinhLuanModel binhLuanModel) async {
    return await binhluanCollection
        .doc(idBinhLuan)
        .update(binhLuanModel.toMap());
  }
}
