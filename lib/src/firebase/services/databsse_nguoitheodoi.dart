import 'package:cloud_firestore/cloud_firestore.dart';

class DatabseNguoiTheoDoi {
  CollectionReference nguoiTheoDoiCollection =
      FirebaseFirestore.instance.collection('nguoitheodoi');
  Future create(String idnguoitheodoi, String idnguoiduoctheodoi) async {
    Map<String, dynamic> nguoiTheoDoi = {
      'idnguoiduoctheodoi': idnguoiduoctheodoi,
      'nguoitheodoi': [],
    };
    DocumentReference nguoiTheoDoiDocument =
        await nguoiTheoDoiCollection.add(nguoiTheoDoi);
    return nguoiTheoDoiDocument.update({
      'nguoitheodoi': FieldValue.arrayUnion([idnguoitheodoi])
    });
  }
}
