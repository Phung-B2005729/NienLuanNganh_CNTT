import 'package:apparch/src/helper/date_time_function.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HopChat {
  // ignore: prefer_final_fields
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference chatCollection =
      FirebaseFirestore.instance.collection('hopchat');

//tao
  Future createHopChat(String uid1, String uid2) async {
    Map<String, dynamic> hopChat = {
      'idhopchat': '',
      'thoigianbatdau': DatetimeFunction.getTimeToInt(DateTime.now()),
      'noidungguiganday': '',
      'thoigianguiganday': '',
      'nguoiguiganday': '',
      'thanhvien': []
    };

    //them du lieu
    DocumentReference documentHopChat = await chatCollection.add(hopChat);

    //them id
    documentHopChat.update({
      'idhopchat': documentHopChat.id,
      "thanhvien": FieldValue.arrayUnion([uid1, uid2]),
    });
    // them danh sach hopchat vao
    await firebaseFirestore.collection('user').doc(uid1).update({
      'hopchat': FieldValue.arrayUnion([documentHopChat.id])
    });
    return await firebaseFirestore.collection('user').doc(uid2).update({
      'hopchat': FieldValue.arrayUnion([documentHopChat.id])
    });
  }

  // gui tin nhan
  sendMessage(String idhopchat, String mess, String username) async {
    Map<String, dynamic> chatMessage = {
      "idmess": '',
      "message": mess,
      "nguoigui": username,
      "thoigiangui": DatetimeFunction.getTimeToInt(DateTime.now()),
    };
    // ignore: unused_local_variable
    DocumentReference messDocument = await chatCollection
        .doc(idhopchat)
        .collection('message')
        .add(chatMessage);

    messDocument.update({'idmess': messDocument.id});

    chatCollection.doc(idhopchat).update({
      'noidungguiganday': mess,
      'nguoiguiganday': username,
      'thoigianguiganday': DatetimeFunction.getTimeToInt(DateTime.now()),
    });
  }
}
