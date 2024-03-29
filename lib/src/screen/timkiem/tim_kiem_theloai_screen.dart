import 'package:apparch/src/firebase/services/database_chuong.dart';
import 'package:apparch/src/firebase/services/database_truyen.dart';
import 'package:apparch/src/helper/temple/app_theme.dart';
import 'package:apparch/src/helper/temple/color.dart';
import 'package:apparch/src/screen/truyen/truyen_chi_tiet_amition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class TimKiemTheLoaiSreen extends StatefulWidget {
  String value;
  String tenloai;
  TimKiemTheLoaiSreen({super.key, required this.value, required this.tenloai});

  @override
  State<TimKiemTheLoaiSreen> createState() => _TimKiemTheLoaiSreenState();
}

class _TimKiemTheLoaiSreenState extends State<TimKiemTheLoaiSreen> {
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
                        "Thể loại " + widget.tenloai,
                        style: GoogleFonts.arizonia(
                          //roboto
                          // arizonia
                          fontSize: 25,
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
                          if (ktrTruyen(snapshot.data.docs[index]['theloai']) ==
                              true)
                            BuildtilteTruyen(context, snapshot, index)
                      ]),
                )
              : BuildTimKiemRong();
        });
  }

  Widget BuildtilteTruyen(
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
          BuildChiTiet(snapshot, index),
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

  Widget BuildChiTiet(AsyncSnapshot<dynamic> snapshot, int index) {
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
        SizedBox(
          width: 5,
        ),
        BuildTenTruyen(snapshot, index),
      ],
    );
  }

  Widget BuildTenTruyen(AsyncSnapshot<dynamic> snapshot, int index) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            TenTruyen(snapshot, index),
            BuildTinhTrang(snapshot, index),
            const SizedBox(
              height: 10,
            ),
            BuildLuotXemBinhChon(snapshot, index),
          ],
        ),
      ),
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

  Row BuildLuotXemBinhChon(AsyncSnapshot<dynamic> snapshot, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
        // const SizedBox(width: 25),
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

  ElevatedButton BuildTinhTrang(AsyncSnapshot<dynamic> snapshot, int index) {
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

  Widget BuildTimKiemRong() {
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

  bool ktrTruyen(dynamic theloai) {
    if (theloai.toLowerCase().contains(widget.value.toLowerCase())) {
      return true;
    } else {
      return false;
    }
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
