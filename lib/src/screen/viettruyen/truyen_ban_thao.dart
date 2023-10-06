import 'package:apparch/src/firebase/services/database_truyen.dart';

import 'package:apparch/src/screen/viettruyen/viet_truyen_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../helper/temple/Color.dart';

// ignore: must_be_immutable
class TruyenBanThao extends StatefulWidget {
  String iduser;
  TruyenBanThao({super.key, required this.iduser});

  @override
  State<TruyenBanThao> createState() => _TruyenBanThaoState();
}

class _TruyenBanThaoState extends State<TruyenBanThao> {
  Stream<QuerySnapshot>? truyenbanthao;
  @override
  void initState() {
    super.initState();
    getTruyen();
  }

  getTruyen() {
    DatabaseTruyen()
        .getAllTruyenDK2('tacgia', widget.iduser, 'tinhtrang', 'Bản thảo', true)
        .then((val) {
      setState(() {
        truyenbanthao = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    if (truyenbanthao != null) {
      return Scaffold(body: VietTruyenList(truyenbanthao, true, Colors.black));
    } else {
      return const Center(
          child: CircularProgressIndicator(
        color: ColorClass.fiveColor,
      ));
    }
  }
}
