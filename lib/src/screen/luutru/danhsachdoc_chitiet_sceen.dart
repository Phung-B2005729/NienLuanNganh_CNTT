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
class DanhSachDocChiTietScreen extends StatefulWidget {
  String idds;
  String name;
  int soluong;
  DanhSachDocChiTietScreen(
      {super.key,
      required this.idds,
      required this.name,
      required this.soluong});

  @override
  State<DanhSachDocChiTietScreen> createState() =>
      _DanhSachDocChiTietScreenState();
}

class _DanhSachDocChiTietScreenState extends State<DanhSachDocChiTietScreen> {
  Stream<QuerySnapshot>? ListTruyen;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    await DatabaseTruyen().getAllTruyen().then((va) {
      setState(() {
        ListTruyen = va;
      });
    });
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
          "Danh sách đọc " + widget.name,
          style: AppTheme.lightTextTheme.titleSmall,
        ),
      ),
      body: (widget.soluong == 0)
          ? Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, bottom: 70, top: 0),
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
            )
          : StreamBuilder<QuerySnapshot>(
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
                          if (ktrTruyenTrongDs(
                                  snapshot.data.docs[index]['danhsachdocgia'],
                                  widget.idds) ==
                              true)
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TruyenChiTietAmition(
                                              lisTruyen: snapshot.data.docs,
                                              vttruyen: index,
                                              edit: false,
                                            )));
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                    top: 15, bottom: 10, left: 2, right: 2),
                                height: 300,
                                width: 325,
                                decoration: BoxDecoration(
                                  //   color: Color.fromARGB(255, 231, 237, 242),
                                  color:
                                      const Color.fromARGB(255, 239, 236, 236),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromARGB(255, 191, 188, 188),
                                      offset: Offset(10, 15),
                                      blurRadius: 8.0,
                                    )
                                  ],
                                ),
                                child: Dismissible(
                                  key: ValueKey(snapshot.data.docs[index]
                                      ['idtruyen']), // dinh danh widget
                                  background: Container(
                                    color: Theme.of(context).colorScheme.error,
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(right: 20),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 4),
                                    child: const Icon(Icons.delete,
                                        color: Colors.white, size: 40),
                                  ),
                                  direction: DismissDirection.endToStart,
                                  // huong vuot
                                  confirmDismiss: (direction) {
                                    // ham xac nhan loai bo
                                    return MsgDialog
                                        .showConfirmDialogDismissible(
                                      context,
                                      "Bạn chắc chăn muốn xoá truyện này ?",
                                    );
                                  },
                                  onDismissed: (direction) async {
                                    try {
                                      // xoa truyen khoi danh sach
                                      await DatabaseDSDoc().deleteTruyen(
                                          widget.idds,
                                          snapshot.data.docs[index]
                                              ['idtruyen']);
                                      await DatabaseTruyen().deleteDSDocGia(
                                          widget.idds,
                                          snapshot.data.docs[index]
                                              ['idtruyen']);
                                      setState(() {
                                        widget.soluong = widget.soluong - 1;
                                      });
                                      // xoa id danh khoi truyen
                                      // ignore: use_build_context_synchronously
                                      MsgDialog.showSnackbar(context,
                                          ColorClass.fiveColor, 'Đã xoá');
                                      // ignore: use_build_context_synchronously
                                    } catch (e) {
                                      // ignore: use_build_context_synchronously

                                      // ignore: use_build_context_synchronously
                                      MsgDialog.showSnackbar(context,
                                          Colors.red, "Lỗi vui lòng thử lại!!");
                                      print("loi xoa image " + e.toString());
                                    }

                                    print('Đã xoá');
                                  },
                                  child: Card(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            snapshot.data.docs[index]
                                                        ['linkanh'] !=
                                                    null
                                                ? Container(
                                                    margin:
                                                        const EdgeInsets.all(0),
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    height: 150,
                                                    width: 110,
                                                    child: Image.network(
                                                      snapshot.data.docs[index]
                                                          ['linkanh'],
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                                : Container(
                                                    margin:
                                                        const EdgeInsets.all(0),
                                                    padding:
                                                        const EdgeInsets.all(8),
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
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    snapshot.data.docs[index]
                                                        ['tentruyen'],
                                                    style: GoogleFonts.arizonia(
                                                      //roboto
                                                      // arizonia
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                    softWrap: true,
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  ElevatedButton(
                                                    style: TextButton.styleFrom(
                                                      backgroundColor:
                                                          Colors.white,
                                                      foregroundColor: snapshot
                                                                          .data
                                                                          .docs[
                                                                      index][
                                                                  'tinhtrang'] ==
                                                              'Hoàn thành'
                                                          ? const Color
                                                              .fromARGB(
                                                              255, 53, 180, 146)
                                                          : const Color
                                                              .fromARGB(255,
                                                              136, 118, 81),
                                                      textStyle:
                                                          const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                    child: Text(snapshot
                                                            .data.docs[index]
                                                        ['tinhtrang']),
                                                    onPressed: () {},
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Icon(
                                                            Icons.visibility,
                                                            size: 18,
                                                          ),
                                                          const SizedBox(
                                                            width: 4,
                                                          ),
                                                          Text(
                                                            snapshot
                                                                .data
                                                                .docs[index][
                                                                    'tongluotxem']
                                                                .toString(),
                                                            style: AppTheme
                                                                .lightTextTheme
                                                                .bodySmall,
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(width: 25),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Icon(
                                                            Icons.star,
                                                            size: 18,
                                                          ),
                                                          const SizedBox(
                                                            width: 4,
                                                          ),
                                                          Text(
                                                            snapshot
                                                                .data
                                                                .docs[index][
                                                                    'tongbinhchon']
                                                                .toString(),
                                                            style: AppTheme
                                                                .lightTextTheme
                                                                .bodySmall,
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                          child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              child: RowCountChuong(
                                                  idtruyen: snapshot.data
                                                      .docs[index]['idtruyen']
                                                      .toString())),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                              bottom: 15,
                                              top: 10),
                                          child: Text(
                                            snapshot.data.docs[index]['mota'],
                                            style: AppTheme
                                                .lightTextTheme.bodySmall,
                                            softWrap: true,
                                            maxLines:
                                                4, // Giới hạn hiển thị 3 dòng
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                      ]);
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: ColorClass.fiveColor,
                    ),
                  );
                }
              }),
    );
  }
}
