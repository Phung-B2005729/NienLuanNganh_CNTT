import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseBinhLuan {
  CollectionReference binhLuanColecction =
      FirebaseFirestore.instance.collection('binhluan');
  Future create(
      String nd, String username, String idphanhoi, String idchuong) async {
    Map<String, dynamic> binhluan = {
      'idbinhluan': '',
      'idphanhoi': idphanhoi,
      'noidung': nd,
      'idchuong': idchuong,
      'nguoiphanhoi': username,
    };
    DocumentReference binhluanDocument = await binhLuanColecction.add(binhluan);
    return binhluanDocument.update({'idbinhluan': binhluanDocument.id});
  }
}
