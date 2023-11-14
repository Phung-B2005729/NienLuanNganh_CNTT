// ignore: must_be_immutable
import 'package:apparch/src/firebase/services/database_truyen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AvataTruyen extends StatefulWidget {
  String idtruyen;
  AvataTruyen({super.key, required this.idtruyen});

  @override
  State<AvataTruyen> createState() => _AvataTruyenState();
}

class _AvataTruyenState extends State<AvataTruyen> {
  DocumentSnapshot? truyenData;
  @override
  void initState() {
    super.initState();
    getTruyen();
  }

  getTruyen() async {
    // ignore: avoid_print, prefer_interpolation_to_compose_strings
    print("idtruyen " + widget.idtruyen);
    await DatabaseTruyen().getTruyenId(widget.idtruyen).then((value) {
      setState(() {
        truyenData = value;
      });
    });
    // ignore: avoid_print, prefer_interpolation_to_compose_strings
    print("link anh " + truyenData!['linkanh']);
  }

  @override
  Widget build(BuildContext context) {
    return (truyenData != null &&
            truyenData!.exists &&
            truyenData!['linkanh'] != null)
        ? Image.network(
            truyenData!['linkanh'],
            fit: BoxFit.cover,
          )
        : Image.asset(
            'assets/images/danhsachdocempty.jpg',
            fit: BoxFit.cover,
          );
  }
}
