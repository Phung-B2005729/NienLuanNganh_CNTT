import 'package:apparch/src/firebase/services/database_chuong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RowCountChuong extends StatefulWidget {
  String idtruyen;
  RowCountChuong({super.key, required this.idtruyen});

  @override
  State<RowCountChuong> createState() => _RowCountChuongState();
}

class _RowCountChuongState extends State<RowCountChuong> {
  var countChuong;
  Stream<QuerySnapshot>? truyenStream;
  // ignore: non_constant_identifier_names
  // Stream<QuerySnapshot>? DsDocStream;
  @override
  void initState() {
    super.initState();
    getCountChuong();
  }

  getCountChuong() async {
    await DatabaseChuong()
        .getALLChuongSX(widget.idtruyen, false, false)
        .then((value) {
      setState(() {
        countChuong = value.size;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.format_list_bulleted),
        Text(' ${countChuong.toString()} chuong')
        // so chuong
      ],
    );
  }
}
