import 'package:apparch/src/firebase/services/database_chuong.dart';
import 'package:apparch/src/firebase/services/database_truyen.dart';
import 'package:apparch/src/helper/temple/app_theme.dart';
import 'package:apparch/src/helper/temple/color.dart';
import 'package:apparch/src/screen/truyen/truyen_chi_tiet_amition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class TimKiemTagsSreen extends StatefulWidget {
  String value;
  TimKiemTagsSreen({super.key, required this.value});

  @override
  State<TimKiemTagsSreen> createState() => _TimKiemTagsSreenState();
}

class _TimKiemTagsSreenState extends State<TimKiemTagsSreen> {
  Stream<QuerySnapshot>? truyenStream;
  @override
  void initState() {
    super.initState();
    getAllTruyen();
  }

  getAllTruyen() {
    DatabaseTruyen().getALLTruyenNotBanThao().then((vale) {
      setState(() {
        truyenStream = vale;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: truyenStream,
        builder: (context, AsyncSnapshot snapshot) {
          return (snapshot.hasData && snapshot.data.docs.length != 0)
              ? Scaffold(
                  appBar: AppBar(
                    backgroundColor: ColorClass.xanh3Color,
                    title: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        // ignore: prefer_interpolation_to_compose_strings
                        "#" + widget.value,
                        style: GoogleFonts.roboto(
                          //roboto
                          // arizonia
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  body: ListView(
                      scrollDirection:
                          Axis.vertical, // true cuon doc, false cuon ngang
                      children: [
                        for (var index = 0;
                            index < snapshot.data.docs.length;
                            index++)
                          if (ktrTruyen(snapshot.data.docs[index]['tags']) ==
                              true)
                            BuildTruyenChiTiet(context, snapshot, index)
                      ]),
                )
              : BuildRong();
        });
  }

  Widget BuildTruyenChiTiet(
      BuildContext context, AsyncSnapshot<dynamic> snapshot, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TruyenChiTietAmition(
                      lisTruyen: snapshot.data.docs,
                      vttruyen: index,
                      edit: false,
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 0),
        child: Container(
          height: 300,
          width: 325,
          decoration: BoxDecoration(
            //   color: Color.fromARGB(255, 231, 237, 242),
            color: const Color.fromARGB(255, 239, 236, 236),
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(255, 191, 188, 188),
                offset: Offset(10, 15),
                blurRadius: 8.0,
              )
            ],
          ),
          child: BuildCardTruyen(snapshot, index),
        ),
      ),
    );
  }

  Widget BuildCardTruyen(AsyncSnapshot<dynamic> snapshot, int index) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BuildTruyen(snapshot, index),
          Padding(
              padding: EdgeInsets.only(left: 10),
              child: RowCountChuong(
                  idtruyen: snapshot.data.docs[index]['idtruyen'].toString())),
          Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, bottom: 15, top: 10),
            child: Text(
              snapshot.data.docs[index]['mota'],
              style: AppTheme.lightTextTheme.bodySmall,
              softWrap: true,
              maxLines: 4, // Giới hạn hiển thị 3 dòng
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget BuildTruyen(AsyncSnapshot<dynamic> snapshot, int index) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        snapshot.data.docs[index]['linkanh'] != null
            ? Container(
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(8),
                height: 150,
                width: 110,
                child: Image.network(
                  snapshot.data.docs[index]['linkanh'],
                  fit: BoxFit.cover,
                ),
              )
            : Container(
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(8),
                height: 150,
                width: 110,
                child: Image.asset(
                  "assets/images/avatarmacdinh.png",
                  fit: BoxFit.cover,
                ),
              ),
        const SizedBox(
          width: 5,
        ),
        BuildChiTiet(snapshot, index),
      ],
    );
  }

  Expanded BuildChiTiet(AsyncSnapshot<dynamic> snapshot, int index) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            TenTruyen(snapshot, index),
            TinhTrang(snapshot, index),
            const SizedBox(
              height: 10,
            ),
            LuotXemBinhLuan(snapshot, index),
          ],
        ),
      ),
    );
  }

  Widget LuotXemBinhLuan(AsyncSnapshot<dynamic> snapshot, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(
              Icons.visibility,
              size: 18,
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              snapshot.data.docs[index]['tongluotxem'].toString(),
              style: AppTheme.lightTextTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(width: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(
              Icons.star,
              size: 18,
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              snapshot.data.docs[index]['tongbinhchon'].toString(),
              style: AppTheme.lightTextTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(
          width: 10,
        ),
      ],
    );
  }

  ElevatedButton TinhTrang(AsyncSnapshot<dynamic> snapshot, int index) {
    return ElevatedButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: snapshot.data.docs[index]['tinhtrang'] == 'Hoàn thành'
            ? const Color.fromARGB(255, 53, 180, 146)
            : const Color.fromARGB(255, 136, 118, 81),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      child: Text(snapshot.data.docs[index]['tinhtrang']),
      onPressed: () {},
    );
  }

  Text TenTruyen(AsyncSnapshot<dynamic> snapshot, int index) {
    return Text(
      snapshot.data.docs[index]['tentruyen'],
      style: GoogleFonts.arizonia(
        //roboto
        // arizonia
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      softWrap: true,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget BuildRong() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 20),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: Image.asset('assets/images/sachempty.png'),
            ),
          ),
          Text('Không có truyện mà bạn muốn tìm',
              style: AppTheme.lightTextTheme.headlineLarge),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  bool ktrTruyen(List<dynamic> tags) {
    for (var i = 0; i < tags.length; i++) {
      if (tags[i].toLowerCase().contains(widget.value.toLowerCase())) {
        return true;
      }
    }
    return false;
  }
}

// ignore: must_be_immutable
class RowCountChuong extends StatefulWidget {
  String idtruyen;
  RowCountChuong({super.key, required this.idtruyen});

  @override
  State<RowCountChuong> createState() => _RowCountChuongState();
}

class _RowCountChuongState extends State<RowCountChuong> {
  // ignore: prefer_typing_uninitialized_variables
  var countChuong;
  Stream<QuerySnapshot>? truyenStream;
  // ignore: non_constant_identifier_names
  Stream<QuerySnapshot>? DsDocStream;
  @override
  void initState() {
    super.initState();
    getCountChuong();
  }

  getCountChuong() async {
    await DatabaseChuong().getALLChuongSX(widget.idtruyen, false).then((value) {
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
