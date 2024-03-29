import 'package:apparch/src/firebase/services/database_truyen.dart';
import 'package:apparch/src/helper/temple/app_theme.dart';
import 'package:apparch/src/screen/timkiem/tim_kiem_tags_screen.dart';
import 'package:apparch/src/screen/truyen/truyen_chi_tiet_amition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class TruyenNguoiDung extends StatefulWidget {
  String iduser;
  TruyenNguoiDung({super.key, required this.iduser});

  @override
  State<TruyenNguoiDung> createState() => _TruyenNguoiDungState();
}

class _TruyenNguoiDungState extends State<TruyenNguoiDung> {
  Stream<QuerySnapshot>? truyenStream;
  @override
  void initState() {
    super.initState();
    getAllTruyen();
  }

  getAllTruyen() async {
    try {
      await DatabaseTruyen()
          .getAllTruyenDK2(
              'tacgia', widget.iduser, 'tinhtrang', 'Bản thảo', false)
          .then((val) {
        if (mounted) {
          setState(() {
            truyenStream = val;
          });
        }
      });
    } catch (e) {
      print('Lỗi khi lấy dữ liệu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: truyenStream,
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
                    BuildTilteTruyen(context, snapshot, index)
                ]);
          } else {
            return BuildTimKiemRong();
          }
        });
  }

  Widget BuildTilteTruyen(
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
          child: BuildCardChiTiet(snapshot, index),
        ),
      ),
    );
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
        //const SizedBox(width: 25),
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

  Widget BuildTimKiemRong() {
    return Padding(
      padding: const EdgeInsets.only(left: 80, right: 15, bottom: 0, top: 0),
      child: Column(
        //  mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: Image.asset('assets/images/sachempty.png'),
            ),
          ),
          Text('Không có truyện', style: AppTheme.lightTextTheme.headlineLarge),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
