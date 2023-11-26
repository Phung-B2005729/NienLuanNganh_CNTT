import 'package:apparch/src/firebase/services/database_chuong.dart';
import 'package:apparch/src/helper/temple/app_theme.dart';
import 'package:apparch/src/helper/temple/color.dart';
import 'package:apparch/src/screen/chuong/chuong_amition.dart';
import 'package:apparch/src/screen/chuong/chuong_them.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../helper/date_time_function.dart';

// ignore: must_be_immutable
class TruyenChiTietDetail2 extends StatefulWidget {
  final String idtruyen;
  String iduser;
  bool edit;
  TruyenChiTietDetail2(
      {super.key,
      required this.idtruyen,
      required this.iduser,
      required this.edit});

  @override
  State<TruyenChiTietDetail2> createState() => _TruyenChiTietDetail2State();
}

class _TruyenChiTietDetail2State extends State<TruyenChiTietDetail2> {
  bool sapxep = false;
  Stream<QuerySnapshot>? allChuongStream;
  // ignore: prefer_typing_uninitialized_variables
  var countChuong;
  var countChuongNotBanThao;
  @override
  void initState() {
    super.initState();
    getALLChuong();
  }

  getALLChuong() async {
    bool ktrbanthao = true;
    if (widget.edit == true) ktrbanthao = false;
    await DatabaseChuong()
        .getALLChuongSnapshots(widget.idtruyen, sapxep, ktrbanthao)
        .then((vale) {
      setState(() {
        allChuongStream = vale;
      });
    });
    await DatabaseChuong()
        .getALLChuongSX(widget.idtruyen, false, widget.edit)
        .then((value) {
      setState(() {
        countChuong = value.size;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(253, 253, 253, 253),
      floatingActionButton:
          widget.edit == true ? BuildFloatingButton(context) : null,
      body: StreamBuilder<QuerySnapshot>(
        stream: allChuongStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Card(
                color: Colors.white,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4, right: 4, top: 140),
                    child: BuildCardSapXepChuong(snapshot),
                  ),
                  if (snapshot.data.docs.length > 0)
                    Expanded(
                      child: BuildDanhSachChuong(snapshot),
                    ),
                ]),
              ),
            );
          } else {
            return const CircularProgressIndicator(
              color: ColorClass.fiveColor,
            );
          }
        },
      ),
    );
  }

  FloatingActionButton BuildFloatingButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => InsertChuong(
                      idtruyen: widget.idtruyen,
                    )));

        // chuyen qua them chương mới
      },
      child: const Icon(
        Icons.add,
      ),
    );
  }

  Widget BuildDanhSachChuong(AsyncSnapshot<dynamic> snapshot) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      height: snapshot.data.docs.length * 1.0 + 5,
      child: ListView.builder(
        physics: const ScrollPhysics(),
        itemCount: snapshot.data.docs.length, // Số lượng phần tử ngang
        itemBuilder: (context, index) {
          return BuildTilteChuong(snapshot, index, context);
        },
      ),
    );
  }

  Widget BuildTilteChuong(
      AsyncSnapshot<dynamic> snapshot, int index, BuildContext context) {
    return ListTile(
      // ignore: prefer_interpolation_to_compose_strings
      title: sapxep
          ? Text(
              // ignore: prefer_interpolation_to_compose_strings
              '${snapshot.data.docs.length - index}. ' +
                  snapshot.data.docs[index]['tenchuong'],
              style: AppTheme.lightTextTheme.bodyMedium,
            )
          : Text(
              // ignore: prefer_interpolation_to_compose_strings
              '${index + 1}. ' + snapshot.data.docs[index]['tenchuong'],
              style: AppTheme.lightTextTheme.bodyMedium,
            ),
      subtitle: buildSubtitle(snapshot, index),
      onTap: () async {
        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChuongAmition(
                      listchuong: snapshot.data.docs,
                      vt: (sapxep == true)
                          ? (snapshot.data.docs.length - 1 - index)
                          : index,
                      idtruyen: widget.idtruyen,
                      iduser: widget.iduser,
                      edit: widget.edit,
                    )));
      },
    );
  }

  Padding buildSubtitle(AsyncSnapshot<dynamic> snapshot, int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 2, bottom: 2),
      child: Row(
        children: [
          Text(
            DatetimeFunction.getTimeFormatDatabase(
                snapshot.data.docs[index]['ngaycapnhat']),
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w300, color: Colors.grey),
          ),
          const SizedBox(
            width: 15,
          ),
          const Icon(
            Icons.visibility,
            size: 12,
            color: Colors.grey,
          ),
          Text(snapshot.data.docs[index]['luotxem'].toString(),
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey)),
          const SizedBox(
            width: 15,
          ),
          const Icon(
            Icons.star,
            size: 12,
            color: Colors.grey,
          ),
          Text(snapshot.data.docs[index]['binhchon'].toString(),
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey))
        ],
      ),
    );
  }

  Widget BuildCardSapXepChuong(AsyncSnapshot<dynamic> snapshot) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.format_list_bulleted),
              const SizedBox(
                width: 4,
              ),
              Text(
                '${snapshot.data.docs.length} chuong',
                style: AppTheme.lightTextTheme.bodyLarge,
              ),
            ],
          ),
          BuildSapXep(),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget BuildSapXep() {
    return Row(
      children: [
        TextButton(
            style: TextButton.styleFrom(
                foregroundColor:
                    (sapxep == false) ? ColorClass.fiveColor : Colors.black),
            onPressed: () {
              setState(() {
                sapxep = false;
                getALLChuong();
              });
            },
            child: const Text(
              'củ nhất',
              style: TextStyle(fontSize: 18),
            )),
        TextButton(
            style: TextButton.styleFrom(
                foregroundColor:
                    (sapxep == true) ? ColorClass.fiveColor : Colors.black),
            onPressed: () {
              setState(() {
                sapxep = true;
                getALLChuong();
              });
            },
            child: const Text(
              'mới nhất',
              style: TextStyle(fontSize: 18),
            ))
      ],
    );
  }
}
