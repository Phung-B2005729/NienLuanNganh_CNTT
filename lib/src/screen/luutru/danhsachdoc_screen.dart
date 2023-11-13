import 'package:apparch/src/bloc/bloc_userlogin.dart';
import 'package:apparch/src/firebase/services/database_danhsachdoc.dart';
import 'package:apparch/src/firebase/services/database_truyen.dart';
import 'package:apparch/src/helper/temple/app_theme.dart';
import 'package:apparch/src/helper/temple/color.dart';
import 'package:apparch/src/screen/luutru/danhsachdoc_chitiet_sceen.dart';
import 'package:apparch/src/screen/share/mgsDiaLog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DanhSachDocScreen extends StatefulWidget {
  const DanhSachDocScreen({super.key});

  @override
  State<DanhSachDocScreen> createState() => _DanhSachDocScreenState();
}

class _DanhSachDocScreenState extends State<DanhSachDocScreen> {
  // ignore: non_constant_identifier_names
  Stream<QuerySnapshot>? DanhSachDoc;
  late final blocUserLogin;
  final _formKey = new GlobalKey<FormState>();
  final _formKey2 = new GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    blocUserLogin = context.read<BlocUserLogin>();
    getData();
  }

  getData() async {
    print(blocUserLogin.id);
    try {
      DatabaseDSDoc().getALLDanhSachDoc(blocUserLogin.id).then((vsl) {
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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('gọi tap');
          showCreateDSDiaLog(context, blocUserLogin.id);
        },
        // ignore: sort_child_properties_last
        child: const Icon(Icons.add),
        backgroundColor: ColorClass.fiveColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: DanhSachDoc,
          builder: (context, AsyncSnapshot snapshot) {
            // ignore: avoid_print
            print(snapshot.hasData);
            if (snapshot.hasData && snapshot.data != null) {
              return ListView.separated(
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 2);
                },
                scrollDirection:
                    Axis.vertical, // true cuon doc, false cuon ngang
                itemCount: snapshot.data.docs.length, // Số lượng phần tử ngang
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // chuyển danh sách chi tiết các truyện
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => DanhSachDocChiTietScreen(
                                  idds: snapshot.data.docs[index]['iddanhsach'],
                                  name: snapshot.data.docs[index]
                                      ['tendanhsachdoc'],
                                  soluong: snapshot.data
                                      .docs[index]['danhsachtruyen'].length)));
                    },
                    child: Container(
                      height: 200,
                      width: 325,
                      margin: const EdgeInsets.only(
                          top: 10, bottom: 8, left: 8, right: 0),
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
                      child: Dismissible(
                        // loai bo bang cach luot
                        key: ValueKey(snapshot.data.docs[index]
                            ['iddanhsach']), // dinh danh widget
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
                          return MsgDialog.showConfirmDialogDismissible(
                            context,
                            "Bạn chắc chăn muốn xoá truyện này ?",
                          );
                        },
                        onDismissed: (direction) async {
                          try {
                            await DatabaseDSDoc().deleteOneDs(
                                snapshot.data.docs[index]['iddanhsach']);
                            for (var i = 0;
                                i <
                                    snapshot.data.docs[index]['danhsachtruyen']
                                        .length;
                                i++) {
                              await DatabaseTruyen().deleteDSDocGia(
                                  snapshot.data.docs[index]['iddanhsach'],
                                  snapshot.data.docs[index]['danhsachtruyen']
                                      [i]);
                            }
                            // ignore: use_build_context_synchronously
                            MsgDialog.showSnackbar(
                                context, ColorClass.fiveColor, 'Đã xoá');
                          } catch (e) {
                            // ignore: use_build_context_synchronously
                            MsgDialog.showSnackbar(
                                context, Colors.red, "Lỗi vui lòng thử lại!!");
                            print('Lỗi xoá ds ' + e.toString());
                          }
                          // xoá danh sách
                          print('Đã xoá');
                        },
                        child: Card(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
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
                                        color: const Color.fromARGB(
                                            239, 255, 255, 255),
                                        height: 180,
                                        width: 140,
                                      ),
                                    ),
                                    Positioned(
                                      right: 5,
                                      top: 13,
                                      bottom: 13,
                                      child: Container(
                                        color: const Color.fromARGB(
                                            219, 255, 255, 255),
                                        height: 180,
                                        width: 140,
                                      ),
                                    ),
                                    Positioned(
                                      top: 5,
                                      right: 12,
                                      bottom: 5,
                                      child: Container(
                                        color:
                                            Color.fromARGB(206, 255, 255, 255),
                                        height: 180,
                                        width: 140,
                                      ),
                                    ),
                                    (snapshot.data.docs[index]['danhsachtruyen']
                                                .length ==
                                            0)
                                        ? Positioned(
                                            right: 20,
                                            child: Container(
                                              color: const Color.fromARGB(
                                                  236, 243, 243, 243),
                                              height: 180,
                                              width: 140,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8),
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
                                                  color: const Color.fromARGB(
                                                      236, 243, 243, 243),
                                                  border: Border.all(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              182,
                                                              182,
                                                              182))),
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5,
                                                          top: 2,
                                                          bottom: 2,
                                                          right: 2),
                                                  child: AvataTruyen(
                                                    idtruyen: snapshot
                                                        .data
                                                        .docs[index]
                                                            ['danhsachtruyen']
                                                            [0]
                                                        .toString(),
                                                  )),
                                              // chứa hình ảnh
                                            ))
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Column(
                                    children: [
                                      Text(
                                        snapshot.data.docs[index]
                                            ['tendanhsachdoc'],
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
                                            snapshot
                                                    .data
                                                    .docs[index]
                                                        ['danhsachtruyen']
                                                    .length
                                                    .toString() +
                                                " Truyện",
                                            style: AppTheme
                                                .lightTextTheme.bodySmall,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: PopupMenuButton(
                                  onSelected: (value) async {
                                    if (value == 'Đổi tên') {
                                      showUpdateNameDiaLog(
                                          context,
                                          snapshot.data.docs[index]
                                              ['iddanhsach'],
                                          snapshot.data.docs[index]
                                              ['tendanhsachdoc']);
                                      // showmodal đổi tên.
                                    } else if (value == 'Xoá') {
                                      MsgDialog.showXacNhanThongTin(
                                          context,
                                          'Bạn có chắc chắn muốn xoá danh sách đọc này ?',
                                          ColorClass.fiveColor, () async {
                                        try {
                                          await DatabaseDSDoc().deleteOneDs(
                                              snapshot.data.docs[index]
                                                  ['iddanhsach']);
                                          for (var i = 0;
                                              i <
                                                  snapshot
                                                      .data
                                                      .docs[index]
                                                          ['danhsachtruyen']
                                                      .length;
                                              i++) {
                                            await DatabaseTruyen()
                                                .deleteDSDocGia(
                                                    snapshot.data.docs[index]
                                                        ['iddanhsach'],
                                                    snapshot.data.docs[index]
                                                        ['danhsachtruyen'][i]);
                                          }
                                          // ignore: use_build_context_synchronously
                                          MsgDialog.showSnackbar(context,
                                              ColorClass.fiveColor, 'Đã xoá');
                                        } catch (e) {
                                          // ignore: use_build_context_synchronously
                                          MsgDialog.showSnackbar(
                                              context,
                                              Colors.red,
                                              "Lỗi vui lòng thử lại!!");
                                          print('Lỗi xoá ds ' + e.toString());
                                        }
                                      });
                                      // gọi xoá danh sách.
                                    }
                                  },
                                  color:
                                      const Color.fromARGB(255, 237, 236, 236),
                                  icon: const Icon(
                                    Icons.more_vert,
                                    color: Colors.black,
                                  ),
                                  itemBuilder: (context) {
                                    return <PopupMenuEntry<String>>[
                                      PopupMenuItem<String>(
                                        value: 'Đổi tên',
                                        child: Text('Đổi tên',
                                            style: AppTheme
                                                .lightTextTheme.bodySmall),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'Xoá',
                                        child: Text('Xoá',
                                            style: AppTheme
                                                .lightTextTheme.bodySmall),
                                      ),
                                    ];
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
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
                        'Không có danh sách đọc\n',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }

  showUpdateNameDiaLog(BuildContext context, String idds, String namecu) async {
    String inputText = '';
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Đổi tên danh sách đọc',
                style: AppTheme.lightTextTheme.bodyLarge),
            content: Form(
              key: _formKey,
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isNotEmpty == false) {
                    return 'Bạn chưa nhập tên danh sách';
                  }
                  return null;
                },
                style: AppTheme.lightTextTheme.headlineMedium,
                cursorColor: ColorClass.fiveColor,
                onChanged: (value) => inputText = value,
                decoration: InputDecoration(
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorClass.fiveColor),
                    ),
                    // Để chỉnh màu gạch ngang khi focus
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorClass.fiveColor),
                    ),
                    // ignore: unnecessary_brace_in_string_interps
                    hintText: '${namecu}',
                    hintStyle:
                        const TextStyle(fontSize: 12, color: Colors.black)),
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Huỷ',
                    style: TextStyle(color: ColorClass.fiveColor),
                  )),
              TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await DatabaseDSDoc().updateName(idds, inputText);
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Đổi tên',
                      style: TextStyle(color: ColorClass.fiveColor))),
            ],
          );
        });
  }

  showCreateDSDiaLog(BuildContext context, String iduser) async {
    String inputText = '';
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Tạo danh sách đọc',
                style: AppTheme.lightTextTheme.bodyLarge),
            content: Form(
              key: _formKey2,
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isNotEmpty == false) {
                    return 'Bạn chưa nhập tên danh sách';
                  }
                  return null;
                },
                style: AppTheme.lightTextTheme.headlineMedium,
                cursorColor: ColorClass.fiveColor,
                onChanged: (value) => inputText = value,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorClass.fiveColor),
                    ),
                    // Để chỉnh màu gạch ngang khi focus
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorClass.fiveColor),
                    ),
                    hintText: 'Nhập vào tên danh sách',
                    hintStyle: TextStyle(fontSize: 12, color: Colors.black)),
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Huỷ',
                    style: TextStyle(color: ColorClass.fiveColor),
                  )),
              TextButton(
                  onPressed: () async {
                    if (_formKey2.currentState!.validate()) {
                      await DatabaseDSDoc()
                          .createDanhSachDoc(iduser, inputText);

                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Thêm',
                      style: TextStyle(color: ColorClass.fiveColor))),
            ],
          );
        });
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
