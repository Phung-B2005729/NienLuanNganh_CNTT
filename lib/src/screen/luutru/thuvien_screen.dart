// ignore_for_file: avoid_print

import 'package:apparch/src/bloc/bloc_userlogin.dart';
import 'package:apparch/src/firebase/services/database_chuong.dart';
import 'package:apparch/src/firebase/services/database_danhsachdoc.dart';
import 'package:apparch/src/firebase/services/database_truyen.dart';
import 'package:apparch/src/firebase/services/database_user.dart';
import 'package:apparch/src/helper/date_time_function.dart';
import 'package:apparch/src/helper/temple/app_theme.dart';
import 'package:apparch/src/helper/temple/color.dart';
import 'package:apparch/src/screen/chuong/chuong_amition.dart';
import 'package:apparch/src/screen/luutru/tacgia.dart';
import 'package:apparch/src/screen/share/mgsDiaLog.dart';
import 'package:apparch/src/screen/share/modal_insert_danhsachdoc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ThuVienScreen extends StatefulWidget {
  const ThuVienScreen({super.key});

  @override
  State<ThuVienScreen> createState() => _ThuVienScreenState();
}

class _ThuVienScreenState extends State<ThuVienScreen> {
  Stream<QuerySnapshot>? listtruyenThuVien;
  Stream<QuerySnapshot>? truyenData;
  QuerySnapshot? allChuongStream;
  var valuetinhtrinh;
  late final blocUserLogin;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    blocUserLogin = context.read<BlocUserLogin>();

    await DatabaseUser().getALLTruyenThuVien(blocUserLogin.id).then((vs) {
      listtruyenThuVien = vs;
    });
    await DatabaseTruyen().getAllTruyen().then((value) {
      setState(() {
        truyenData = value;
      });
    });
    print(truyenData == null);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: listtruyenThuVien,
        builder: (context, AsyncSnapshot snapshot4) {
          if (snapshot4.hasData) {
            // ignore: prefer_interpolation_to_compose_strings
            print("lenght " + snapshot4.data.docs.length.toString());
            return StreamTruyenData(snapshot4);
          } else {
            return Padding(
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
                      'Không có truyện\n',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }

  bool ktrTruyen(String idtruyen, List<dynamic> lisTruyen) {
    bool ktr = false;
    for (var i = 0; i < lisTruyen.length; i++) {
      if (idtruyen == lisTruyen[i]['idtruyen']) {
        ktr = true;
      }
    }
    return ktr;
  }

  // ignore: non_constant_identifier_names
  StreamBuilder<QuerySnapshot<Object?>> StreamTruyenData(
      AsyncSnapshot<dynamic> snapshot4) {
    return StreamBuilder<QuerySnapshot>(
        stream: truyenData,
        builder: (context, AsyncSnapshot snapshot) {
          return (snapshot.hasData)
              ? ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    for (var i = 0; i < snapshot4.data.docs.length; i++)
                      for (var index = 0;
                          index < snapshot.data.docs.length;
                          index++)
                        if (snapshot.data.docs[index]['idtruyen'] ==
                            snapshot4.data.docs[i]['idtruyen'])
                          GestureDetector(
                            onTap: () async {
                              // chuyen den noi dung chuong
                              // ignore: prefer_interpolation_to_compose_strings

                              await DatabaseChuong()
                                  .getALLChuongSX(
                                      snapshot4.data.docs[i]['idtruyen'], false)
                                  .then((vale) {
                                setState(() {
                                  allChuongStream = vale;
                                });
                              });
                              // ignore: prefer_interpolation_to_compose_strings

                              // ignore: use_build_context_synchronously
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ChuongAmition(
                                          listchuong: allChuongStream!.docs,
                                          vt: snapshot4.data.docs[i]
                                                      ['chuongdadoc'] ==
                                                  0
                                              ? 0
                                              : (snapshot4.data.docs[i]
                                                      ['chuongdadoc'] -
                                                  1),
                                          idtruyen: snapshot4.data.docs[i]
                                              ['idtruyen'],
                                          iduser: blocUserLogin.id,
                                          edit: false)));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 15, bottom: 10, left: 5, right: 3),
                              child: Container(
                                height: 200,
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
                                      "Bạn chắc chăn muốn xoá truyện này khỏi thư viện ?",
                                    );
                                  },
                                  onDismissed: (direction) async {
                                    try {
                                      await DatabaseUser()
                                          .deleteOneTruyenOnThuVien(
                                              blocUserLogin.id,
                                              snapshot.data.docs[index]
                                                  ['idtruyen']);
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
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      //  mainAxisAlignment:
                                      //     MainAxisAlignment.spaceAround,
                                      children: [
                                        snapshot.data.docs[index]['linkanh'] !=
                                                null
                                            ? SizedBox(
                                                height: 180,
                                                width: 120,
                                                child: Image.network(
                                                  snapshot.data.docs[index]
                                                      ['linkanh'],
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            : SizedBox(
                                                height: 180,
                                                width: 120,
                                                child: Image.asset(
                                                  "assets/images/avatarmacdinh.png",
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8),
                                                child: Text(
                                                  snapshot.data.docs[index]
                                                      ['tentruyen'],
                                                  style: GoogleFonts.arizonia(
                                                    //roboto
                                                    // arizonia
                                                    fontSize: 26,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),

                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    TacGia(snapshot.data
                                                        .docs[index]['tacgia']),
                                                    Text(
                                                      // ignore: prefer_interpolation_to_compose_strings
                                                      "Cập nhật gần đây \n" +
                                                          DatetimeFunction
                                                              .getTimeFormatDatabase(snapshot
                                                                          .data
                                                                          .docs[
                                                                      index][
                                                                  'ngaycapnhat']),
                                                      style: AppTheme
                                                          .lightTextTheme
                                                          .bodySmall,
                                                      maxLines: 2,
                                                      softWrap: true,
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              //  tien trinh thanh tien trinh
                                              TienTrinhDoc(
                                                idtruyen: snapshot.data
                                                    .docs[index]['idtruyen'],
                                                chuongdadoc: snapshot4.data
                                                    .docs[i]['chuongdadoc'],
                                                idu: blocUserLogin.id,
                                              )
                                              // 3 chấm cho xoá khỏi thư viện
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(
                    color: ColorClass.fiveColor,
                  ),
                );
        });
  }
}

// ignore: must_be_immutable
class TienTrinhDoc extends StatefulWidget {
  String idtruyen;
  String idu;
  int chuongdadoc;
  TienTrinhDoc(
      {super.key,
      required this.idtruyen,
      required this.chuongdadoc,
      required this.idu});

  @override
  State<TienTrinhDoc> createState() => _TienTrinhDocState();
}

class _TienTrinhDocState extends State<TienTrinhDoc> {
  double valuetientrinh = 0.01;
  // ignore: prefer_typing_uninitialized_variables
  var countChuong;
  Stream<QuerySnapshot>? truyenStream;
  // ignore: non_constant_identifier_names
  Stream<QuerySnapshot>? DsDocStream;
  Stream<QuerySnapshot>? thuvien;
  // Add this flag
  // ignore: non_constant_identifier_names
  // Stream<QuerySnapshot>? DsDocStream;
  @override
  void initState() {
    super.initState();
    getCountChuong();
  }

  @override
  void dispose() {
    super.dispose();
    // Set the flag to false when disposed
  }

  void xoaTruyen(BuildContext context, String idu, String idtruyen) async {
    MsgDialog.showXacNhanThongTin(
        context, 'Bạn có chắc muốn xoá truyện khỏi thư viện ?', Colors.black,
        () async {
      try {
        await DatabaseUser().deleteOneTruyenOnThuVien(idu, idtruyen);
        // ignore: use_build_context_synchronously
      } catch (e) {
        // ignore: use_build_context_synchronously

        // ignore: use_build_context_synchronously
        MsgDialog.showSnackbar(context, Colors.red, "Lỗi vui lòng thử lại!!");
        // ignore: prefer_interpolation_to_compose_strings
        print("loi xoa image " + e.toString());
      }

      print('Đã xoá');
    });
  }

  getCountChuong() async {
    await DatabaseChuong().getALLChuongSX(widget.idtruyen, false).then((value) {
      setState(() {
        countChuong = value.size;
      });
    });
    // ignore: prefer_interpolation_to_compose_strings
    print('countchuong' + countChuong.toString());
    // ignore: prefer_interpolation_to_compose_strings
    print('chuong da doc  ' + widget.chuongdadoc.toString());
    if (countChuong != null && countChuong > 0) {
      setState(() {
        valuetientrinh = (((widget.chuongdadoc) / countChuong)).toDouble();
        if (valuetientrinh == 0.0) valuetientrinh = 0.01;
        // ignore: prefer_interpolation_to_compose_strings
        print("Tien trinh  " + valuetientrinh.toString());
      });
    }
    DsDocStream = await DatabaseDSDoc().getALLDanhSachDoc(widget.idu);

    thuvien = await DatabaseUser().getALLTruyenThuVien(widget.idu);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(right: 40),
        child: Align(
          alignment: Alignment.topRight,
          child: Container(
            //  padding: const EdgeInsets.all(2.0),
            //  margin: const EdgeInsets.only(left: ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: ColorClass.xanh2Color,
            ),
            constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
            child: const Text(
              'Mới', // so chuong gan day 3 ngay ma chưa doc
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: valuetientrinh,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(ColorClass.xanh3Color),
                backgroundColor: const Color.fromARGB(255, 171, 171, 171),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: PopupMenuButton(
                onSelected: (value) async {
                  if (value == 'thêm vào danh sách đọc') {
                    ModelInser().ShowModal(context, DsDocStream, thuvien, false,
                        widget.idtruyen, widget.chuongdadoc);
                  } else if (value == 'xoá') {
                    xoaTruyen(context, widget.idu, widget.idtruyen);
                    print(value);
                    // Xử lý khi chọn "Xóa"

                    // Đặt mã xử lý ở đây
                  }
                },
                color: const Color.fromARGB(255, 237, 236, 236),
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.black,
                ),
                itemBuilder: (context) {
                  return <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'thêm vào danh sách đọc',
                      child: Text(
                        'Thêm vào danh sách đọc',
                        style: AppTheme.lightTextTheme.bodySmall,
                        softWrap: true,
                        maxLines: 2,
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'xoá',
                      child: Text(
                        'Xoá khỏi thư viện',
                        style: AppTheme.lightTextTheme.bodySmall,
                        softWrap: true,
                        maxLines: 2,
                      ),
                    ),
                  ];
                },
              ),
            ),
          ],
        ),
      ),
    ]);
  }
} 
// ignore: unused_import

