import 'package:apparch/src/helper/helper_function.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BlocTimKiem with ChangeNotifier {
  late List<String> lichSuTimKiem;
  late List<String> dstentruyen;
  late List<String> dstags;

  void getData() async {
    dstentruyen = [];
    dstags = [];
    lichSuTimKiem = await HelperFunctions.getLishSuTimKiem();
    notifyListeners();
  }

  void updataList(String timkiem) {
    bool add = true;
    for (var i = 0; i < lichSuTimKiem.length; i++) {
      if (lichSuTimKiem[i] == timkiem) {
        add = false;
      }
    }
    if (add == true) {
      lichSuTimKiem.add(timkiem);
      HelperFunctions.saveLichSuTimKiem(lichSuTimKiem);
    }
    notifyListeners();
  }

  bool ktrItem(String value, List<dynamic> list) {
    bool add = false;
    for (var i = 0; i < list.length; i++) {
      if (list[i] == value) {
        add = true;
      }
    }
    return add;
  }

  void deleteOneList(String tk) {
    lichSuTimKiem.remove(tk);
    HelperFunctions.saveLichSuTimKiem(lichSuTimKiem);
    notifyListeners();
  }

  //void updateDSNguoiDung(String value) async {}

  void updateDSTruyen(String value) async {
    // gợi ý danh sách truyện
    List<String> dstam = [];
    final querySnapshot = await FirebaseFirestore.instance
        .collection('truyen')
        .where('tinhtrang', isNotEqualTo: 'Bản thảo')
        .get();
    for (final doc in querySnapshot.docs) {
      // ignore: unnecessary_cast
      final truyenData = doc.data() as Map<String, dynamic>;
      final truyenTen = truyenData['tentruyen'] as String;
      final ten = truyenTen.toLowerCase();

      if (ten.contains(value.toLowerCase())) {
        dstam.add(truyenTen);
      }
    }
    dstentruyen = dstam;
    notifyListeners();
  }

  void updateDStags(String value) async {
    List<String> dstam = [];
    final querySnapshot = await FirebaseFirestore.instance
        .collection('truyen')
        .where('tinhtrang', isNotEqualTo: 'Bản thảo')
        .get();
    print('gọi update tags');
    for (final doc in querySnapshot.docs) {
      // ignore: unnecessary_cast
      final truyenData = doc.data() as Map<String, dynamic>;
      final tags = truyenData['tags'] as List<dynamic>;
      if (truyenData['tentruyen'].toLowerCase().contains(value.toLowerCase())) {
        print('dk truyen đúng');
        // lay tat cat tags ở đây thêm vào?
        for (var i = 0; i < tags.length; i++) {
          dstam.add(tags[i]);
          print('thêm vào ' + tags[i]);
        }
      } else {
        // thi loc
        for (var i = 0; i < tags.length; i++) {
          final tag = tags[i].toLowerCase();
          print(tags[i]);
          if (tag.contains(value.toLowerCase())) {
            if (ktrItem(tags[i], dstam) == false) {
              dstam.add(tags[i]);

              print('thêm vào ' + tags[i]);
            }
          }
        }
      }
    }
    dstags = dstam;
    notifyListeners();
    //  dstags = dstam;
  }
}
