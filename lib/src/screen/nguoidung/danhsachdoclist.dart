import 'package:apparch/src/firebase/services/database_danhsachdoc.dart';
import 'package:apparch/src/firebase/services/database_truyen.dart';
import 'package:apparch/src/helper/temple/app_theme.dart';
import 'package:apparch/src/screen/luutru/danhsachdoc_chitiet_sceen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DanhSachDocList extends StatefulWidget {
  final String iduser;
  final bool nguoidung;
  const DanhSachDocList(
      {super.key, required this.iduser, required this.nguoidung});

  @override
  State<DanhSachDocList> createState() => _DanhSachDocListState();
}

class _DanhSachDocListState extends State<DanhSachDocList> {
  // ignore: non_constant_identifier_names
  Stream<QuerySnapshot>? DanhSachDoc;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    try {
      DatabaseDSDoc().getALLDanhSachDoc(widget.iduser).then((vsl) {
        setState(() {
          DanhSachDoc = vsl;
        });
      });
    } catch (e) {
      print('Looi ' + e.toString());
    }
    print(DanhSachDoc);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: DanhSachDoc,
        builder: (context, AsyncSnapshot snapshot) {
          // ignore: avoid_print
          print(snapshot.hasData);
          if (snapshot.hasData && snapshot.data != null) {
            return ListView.separated(
              separatorBuilder: (context, index) {
                return const SizedBox(width: 2);
              },
              scrollDirection: Axis.vertical, // true cuon doc, false cuon ngang
              itemCount: snapshot.data.docs.length, // Số lượng phần tử ngang
              itemBuilder: (context, index) {
                return BuildTilteDanhSach(context, snapshot, index);
              },
            );
          } else {
            return Text('');
          }
        });
  }

  Widget BuildTilteDanhSach(
      BuildContext context, AsyncSnapshot<dynamic> snapshot, int index) {
    return GestureDetector(
      onTap: () {
        // chuyển danh sách chi tiết các truyện
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => DanhSachDocChiTietScreen(
                    nguoidung: widget.nguoidung,
                    idds: snapshot.data.docs[index]['iddanhsach'],
                    name: snapshot.data.docs[index]['tendanhsachdoc'],
                    soluong:
                        snapshot.data.docs[index]['danhsachtruyen'].length)));
      },
      child: Container(
        height: 200,
        width: 325,
        margin: const EdgeInsets.only(top: 10, bottom: 8, left: 8, right: 0),
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
        child: BuildCardDanhSach(snapshot, index, context),
      ),
    );
  }

  Widget BuildCardDanhSach(
      AsyncSnapshot<dynamic> snapshot, int index, BuildContext context) {
    return Card(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BuildAnh(snapshot, index),
          const SizedBox(
            width: 20,
          ),
          BuildTenDS(snapshot, index),
        ],
      ),
    );
  }

  Padding BuildAnh(AsyncSnapshot<dynamic> snapshot, int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Stack(
        children: [
          Container(
            color: Color.fromARGB(195, 170, 170, 170),
            height: 180,
            width: 140,
          ),
          Positioned(
            right: 1,
            top: 20,
            bottom: 20,
            child: Container(
              color: const Color.fromARGB(239, 255, 255, 255),
              height: 180,
              width: 140,
            ),
          ),
          Positioned(
            right: 5,
            top: 13,
            bottom: 13,
            child: Container(
              color: const Color.fromARGB(219, 255, 255, 255),
              height: 180,
              width: 140,
            ),
          ),
          Positioned(
            top: 5,
            right: 12,
            bottom: 5,
            child: Container(
              color: Color.fromARGB(206, 255, 255, 255),
              height: 180,
              width: 140,
            ),
          ),
          (snapshot.data.docs[index]['danhsachtruyen'].length == 0)
              ? Positioned(
                  right: 20,
                  child: Container(
                    color: const Color.fromARGB(236, 243, 243, 243),
                    height: 180,
                    width: 140,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Image.asset(
                        'assets/images/danhsachdocempty.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    // chứa hình ảnh
                  ))
              : Positioned(
                  right: 20,
                  child: Container(
                    height: 180,
                    width: 140,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(236, 243, 243, 243),
                        border: Border.all(
                            color: const Color.fromARGB(255, 182, 182, 182))),
                    child: Padding(
                        padding: const EdgeInsets.only(
                            left: 5, top: 2, bottom: 2, right: 2),
                        child: AvataTruyen(
                          idtruyen: snapshot
                              .data.docs[index]['danhsachtruyen'][0]
                              .toString(),
                        )),
                    // chứa hình ảnh
                  ))
        ],
      ),
    );
  }

  Widget BuildTenDS(AsyncSnapshot<dynamic> snapshot, int index) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Text(
              snapshot.data.docs[index]['tendanhsachdoc'],
              style: GoogleFonts.arizonia(
                //roboto
                // arizonia
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              // maxLines: 2,
            ),
            Column(
              children: [
                Text(
                  // ignore: prefer_interpolation_to_compose_strings
                  snapshot.data.docs[index]['danhsachtruyen'].length
                          .toString() +
                      " Truyện",
                  style: AppTheme.lightTextTheme.bodySmall,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
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
    // ignore: avoid_print
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
