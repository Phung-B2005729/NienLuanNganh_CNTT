import 'package:apparch/src/firebase/services/database_truyen.dart';
import 'package:apparch/src/helper/temple/Color.dart';
import 'package:apparch/src/screen/viettruyen/viet_truyen_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TruyenDangTai extends StatefulWidget {
  late String iduser;
  TruyenDangTai({super.key, required this.iduser});

  @override
  State<TruyenDangTai> createState() => _TruyenDangTaiState();
}

class _TruyenDangTaiState extends State<TruyenDangTai> {
  Stream<QuerySnapshot>? truyenDang;
  @override
  void initState() {
    super.initState();
    getTruyen();
  }

  getTruyen() async {
    try {
      await DatabaseTruyen()
          .getAllTruyenDK2(
              'tacgia', widget.iduser, 'tinhtrang', 'Bản thảo', false)
          .then((val) {
        setState(() {
          truyenDang = val;
        });
      });
    } catch (e) {
      print('Lỗi khi lấy dữ liệu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (truyenDang != null) {
      return Scaffold(body: VietTruyenList(truyenDang, false, Colors.black));
    } else {
      return const Center(
          child: CircularProgressIndicator(
        color: ColorClass.fiveColor,
      ));
    }
  }
}
