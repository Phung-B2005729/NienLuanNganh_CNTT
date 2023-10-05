import 'package:cloud_firestore/cloud_firestore.dart';

class DatabseDangTheoDoi {
  CollectionReference dangTheoDoiCollection =
      FirebaseFirestore.instance.collection('dangtheodoi');

  Future create(String idnguoitheodoi, String idnguoiduoctheodoi) async {
    Map<String, dynamic> dangTheoDoi = {
      'idnguoitheodoi': idnguoitheodoi,
      'nguoiduoctheodoi': [],
    };

    DocumentReference dangTheoDoiDocument =
        await dangTheoDoiCollection.add(dangTheoDoi);
    return dangTheoDoiDocument.update({
      'nguoiduoctheodoi': FieldValue.arrayUnion([idnguoiduoctheodoi])
    });
  }
}
