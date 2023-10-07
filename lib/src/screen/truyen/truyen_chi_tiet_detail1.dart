import 'package:apparch/src/firebase/services/database_truyen.dart';
import 'package:apparch/src/helper/temple/color.dart';
import 'package:apparch/src/screen/chuong/chuong_amition.dart';
import 'package:apparch/src/screen/share/mgsDiaLog.dart';
import 'package:apparch/src/screen/share/tag.dart';
import 'package:apparch/src/screen/truyen/tacgia_avata.dart';
import 'package:apparch/src/screen/truyen/truyen_the_loai.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../firebase/services/database_chuong.dart';
import '../../firebase/services/database_danhsachdoc.dart';
import '../../helper/temple/app_theme.dart';
import 'modal_insert_ds.dart';

// ignore: must_be_immutable
class TruyenChiTietDetail1 extends StatefulWidget {
  final String idtruyen;
  final String iduser;
  bool edit;
  TruyenChiTietDetail1(
      {super.key,
      required this.idtruyen,
      required this.iduser,
      required this.edit});

  @override
  State<TruyenChiTietDetail1> createState() => _TruyenChiTietDetail1State();
}

class _TruyenChiTietDetail1State extends State<TruyenChiTietDetail1> {
  var them1 = false;
  var them2 = false;
  // ignore: prefer_typing_uninitialized_variables
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
    truyenStream =
        await DatabaseTruyen().getAllTruyenDK("idtruyen", widget.idtruyen);
    await DatabaseChuong().getALLChuongSX(widget.idtruyen, false).then((value) {
      setState(() {
        countChuong = value.size;
      });
    });
    try {
      DsDocStream = await DatabaseDSDoc().getALLDanhSachDoc(widget.iduser);
      print(DsDocStream == null);
    } catch (e) {
      print('Lỗi khi lấy dữ liệu: $e');
    }
  }

//
  // ignore: empty_constructor_bodies
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(253, 253, 253, 253),
        body: StreamBuilder<QuerySnapshot>(
            stream: truyenStream,
            builder: (context, AsyncSnapshot snapshot) {
              return snapshot.hasData
                  ? ListView(physics: const ScrollPhysics(), children: [
                      ListTile(
                        title: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Center(
                            child: widget.edit
                                ? Column(
                                    children: [
                                      Text(
                                        snapshot.data.docs[0]['tentruyen'],
                                        style: AppTheme
                                            .lightTextTheme.displayMedium,
                                      ),
                                      Text(
                                        '(Bản xem trước)',
                                        style:
                                            AppTheme.lightTextTheme.bodySmall,
                                      )
                                    ],
                                  )
                                : Text(
                                    snapshot.data.docs[0]['tentruyen'],
                                    style:
                                        AppTheme.lightTextTheme.displayMedium,
                                  ),
                          ),
                        ),
                      ),
                      ListTile(
                          title: TacGiaAvata(snapshot.data.docs[0]['tacgia'])),
                      ListTile(
                        title: Card(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.visibility),
                                    Text(snapshot.data.docs[0]['tongluotxem']
                                        .toString()),
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.star),
                                    Text(snapshot.data.docs[0]['tongbinhchon']
                                        .toString()),
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.format_list_bulleted),
                                    Text(' ${countChuong.toString()} chuong')
                                    // so chuong
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // doc
                      ListTile(
                        title: Padding(
                          padding: const EdgeInsets.only(left: 50, top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: ColorClass.xanh2Color,
                                    border: Border.all(width: 1),
                                    borderRadius: BorderRadius.circular(20)),
                                width: 200,
                                height: 50,
                                child: TextButton(
                                    onPressed: () {
                                      if (countChuong != 0) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ChuongAmition(
                                                        listchuong:
                                                            snapshot.data.docs,
                                                        vt: 0,
                                                        idtruyen:
                                                            widget.idtruyen,
                                                        iduser: widget.iduser,
                                                        edit: widget.edit)));
                                      } else {
                                        MsgDialog.showSnackbar(
                                            context,
                                            ColorClass.fiveColor,
                                            "Chưa có chương được cập nhật");
                                      }
                                    },
                                    child: Text(
                                      "Đọc",
                                      style: AppTheme.lightTextTheme.bodyLarge,
                                    )),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              FloatingActionButton(
                                onPressed: () {
                                  ModelInser().ShowModal(
                                      context, DsDocStream!, widget.idtruyen);
                                },
                                backgroundColor:
                                    const Color.fromARGB(255, 229, 230, 231),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ListTile(
                        title: Card(
                          child: Container(
                            padding: const EdgeInsets.only(left: 10),
                            height:
                                snapshot.data.docs[0]['tags'] != null ? 90 : 20,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ElevatedButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: snapshot.data.docs[0]
                                                ['tinhtrang'] ==
                                            'Hoàn thành'
                                        ? const Color.fromARGB(
                                            255, 53, 180, 146)
                                        : const Color.fromARGB(
                                            255, 136, 118, 81),
                                    textStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  child:
                                      Text(snapshot.data.docs[0]['tinhtrang']),
                                  onPressed: () {},
                                ),
                                if (snapshot.data.docs[0]['tags'] != null)
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, top: 0),
                                      child: TagTruyen(
                                          tag: snapshot.data.docs[0]['tags']),
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        title: Card(
                          child: SizedBox(
                            height: them1 == false ? 230 : 900,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          them1 = !them1;
                                        });
                                      },
                                      icon: Icon(them1
                                          ? Icons.expand_less
                                          : Icons.expand_more),
                                    ),
                                  ),
                                  if (snapshot.data.docs[0]['theloai'] != null)
                                    Row(
                                      children: [
                                        const Text(
                                          'Thể loại: ',
                                          //   style:
                                          //      AppTheme.lightTextTheme.bodySmall,
                                        ),
                                        const SizedBox(width: 3),
                                        TruyenTheLoai(
                                            idtheloai: snapshot.data.docs[0]
                                                ['theloai']),
                                      ],
                                    ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        snapshot.data.docs[0]['mota'],
                                        softWrap: true,
                                        style:
                                            AppTheme.lightTextTheme.bodySmall,
                                        // textHeightBehavior: ,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            them1 = !them1;
                                          });
                                        },
                                        child: Text(
                                          them1 ? 'thu gọn' : 'xem thêm',
                                          style: const TextStyle(
                                              color: ColorClass.selectedColor),
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ])
                  : Container();
            }));
  }
}
