import 'package:apparch/src/firebase/services/database_danhsachdoc.dart';
import 'package:apparch/src/firebase/services/database_truyen.dart';
import 'package:apparch/src/helper/temple/app_theme.dart';
import 'package:apparch/src/helper/temple/color.dart';
import 'package:apparch/src/screen/share/mgsDiaLog.dart';
import 'package:apparch/src/screen/timkiem/tim_kiem_tags_screen.dart';
import 'package:apparch/src/screen/truyen/truyen_chi_tiet_amition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class TruyenDang extends StatefulWidget {
  String iduser;
  String name;
  TruyenDang({super.key, required this.iduser, required this.name});

  @override
  State<TruyenDang> createState() => _TruyenDangState();
}

class _TruyenDangState extends State<TruyenDang> {
  Stream<QuerySnapshot>? ListTruyen;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    try {
      await DatabaseTruyen()
          .getAllTruyenDK2(
              'tacgia', widget.iduser, 'tinhtrang', 'Bản thảo', false)
          .then((val) {
        setState(() {
          ListTruyen = val;
        });
      });
    } catch (e) {
      print('Lỗi khi lấy dữ liệu: $e');
    }
  }

  bool ktrTruyenTrongDs(List<dynamic> ListIdds, String idds) {
    for (var i = 0; i < ListIdds.length; i++) {
      if (ListIdds[i] == idds) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorClass.xanh3Color,
        title: Text(
          // ignore: prefer_interpolation_to_compose_strings
          "Truyện của " + widget.name,
          style: AppTheme.lightTextTheme.titleSmall,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: ListTruyen,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData &&
                snapshot.data.docs.length != 0 &&
                snapshot.data != null) {
              return ListView(
                  scrollDirection:
                      Axis.vertical, // true cuon doc, false cuon ngang
                  children: [
                    for (var index = 0;
                        index < snapshot.data.docs.length;
                        index++)
                      BuildTruyenDS(context, snapshot, index)
                  ]);
            } else {
              return BuildDanhSachRong();
            }
          }),
    );
  }

  Widget BuildDanhSachRong() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 70, top: 0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Image.asset('assets/images/sachempty.png'),
              ),
            ),
            const Text(
              'Danh sách rỗng\n',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget BuildTruyenDS(
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
      child: BuildTruyen(snapshot, index, context),
    );
  }

  Widget BuildTruyen(
      AsyncSnapshot<dynamic> snapshot, int index, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15, bottom: 10, left: 2, right: 2),
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
      child: BuildDismissible(snapshot, index, context),
    );
  }

  Widget BuildDismissible(
      AsyncSnapshot<dynamic> snapshot, int index, BuildContext context) {
    return BuildCardChiTiet(snapshot, index);
  }

  Widget BuildCardChiTiet(AsyncSnapshot<dynamic> snapshot, int index) {
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
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(8),
                height: 150,
                width: 110,
                child: Image.network(
                  snapshot.data.docs[index]['linkanh'],
                  fit: BoxFit.cover,
                ),
              )
            : Container(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(8),
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
            TinhTrang(snapshot, index),
            const SizedBox(
              height: 10,
            ),
            LuotXemBinhChon(snapshot, index),
          ],
        ),
      ),
    );
  }

  Widget LuotXemBinhChon(AsyncSnapshot<dynamic> snapshot, int index) {
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
        // const SizedBox(width: 20),
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
}
