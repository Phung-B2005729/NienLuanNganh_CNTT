import 'package:apparch/src/firebase/services/database_truyen.dart';
import 'package:flutter/material.dart';

import '../../helper/temple/app_theme.dart';

// ignore: must_be_immutable
class TruyenTheLoai extends StatefulWidget {
  String idtheloai;
  TruyenTheLoai({super.key, required this.idtheloai});

  @override
  State<TruyenTheLoai> createState() => _TruyenTheLoaiState();
}

class _TruyenTheLoaiState extends State<TruyenTheLoai> {
  var theloai;
  String tentheloai = '';

  @override
  void initState() {
    super.initState();
    getTheLoai();
  }

  getTheLoai() async {
    print('da goi ham');
    await DatabaseTruyen().getTheLoaiTruyen(widget.idtheloai).then((va) {
      setState(() {
        theloai = va;
        tentheloai = theloai['tenloai'];
        print("the loai 2 " + theloai['tenloai']);
      });
    });
    // print("the loai " + tentheloai);
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      tentheloai,
      style: AppTheme.lightTextTheme.bodySmall,
    );
  }
}
