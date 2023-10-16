import 'dart:convert';

import 'package:apparch/src/firebase/services/database_truyen.dart';
import 'package:apparch/src/firebase/services/database_user.dart';
import 'package:apparch/src/helper/temple/app_theme.dart';
import 'package:apparch/src/helper/temple/color.dart';
import 'package:apparch/src/screen/share/mgsDiaLog.dart';
import 'package:apparch/src/screen/truyen/modal_insert_ds.dart';
import 'package:apparch/src/screen/truyen/tacgia_avata.dart';
import 'package:apparch/src/screen/truyen/truyen_chi_tiet_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../firebase/services/database_chuong.dart';
import '../../firebase/services/database_danhsachdoc.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

// ignore: must_be_immutable
class ChuongNoiDungScreen extends StatefulWidget {
  String idtruyen;
  String iduser;
  bool edit;
  // ignore: prefer_typing_uninitialized_variables
  var vtChuong;

  ChuongNoiDungScreen({
    super.key,
    required this.idtruyen,
    required this.vtChuong,
    required this.iduser,
    required this.edit,
  });

  @override
  State<ChuongNoiDungScreen> createState() => _ChuongNoiDungScreenState();
}

class _ChuongNoiDungScreenState extends State<ChuongNoiDungScreen> {
  bool sapxep = false;
  Stream<QuerySnapshot>? chuongStream;
  var truyenData;
  var tapbarbool = true;
  String idchuong = '';
  var binhchon = false;
  int _currentIndex = 3;
  List<String> noidung = [];
  Stream<QuerySnapshot>? DsDocStream;
  final ScrollController _controller = ScrollController();
  double scrollProgress = 0.0;
  var blocUserLogin;
  Stream<QuerySnapshot>? thuvien;
  @override
  void initState() {
    super.initState();

    getData();
    getIndex();
    _controller.addListener(() {
      _scrollListener();
    });
  }

  getIndex() {
    if (widget.vtChuong > 0) {
      _currentIndex = 0;
    } else {
      _currentIndex = 3;
    }
  }

  void _scrollListener() {
    setState(() {
      scrollProgress =
          _controller.position.pixels / _controller.position.maxScrollExtent;
      if (idchuong != '') {
        if (scrollProgress == 1.00) {
          print(scrollProgress);
          updateLuotXem(widget.idtruyen, idchuong);
        }
      }
    });
  }

  Future updateLuotXem(String idtruyen, String idchuong) async {
    print('gọi update');
    try {
      await DatabaseChuong().updateLuotXem(idtruyen, idchuong);

      await DatabaseTruyen().updateLuotXem(idtruyen);
    } catch (e) {
      print('Lỗi ' + e.toString());
    }
  }

  Future updateBinhChon(String idtruyen, String idchuong, bool ktr) async {
    print('gọi update');
    try {
      await DatabaseChuong().updateBinhChon(idtruyen, idchuong, ktr);

      await DatabaseTruyen().updateBinhChon(idtruyen, ktr);
    } catch (e) {
      print('Lỗi ' + e.toString());
    }
  }

  getData() async {
    // lay noi dung truyen
    await DatabaseTruyen().getTruyenId(widget.idtruyen).then((value) {
      setState(() {
        truyenData = value;
      });
    });
    bool ktrbanthao = true;
    if (widget.edit == true) ktrbanthao = false;
    // lay ds tat ca chuong // noi dung 1 truyen;
    try {
      await DatabaseChuong()
          .getALLChuongSnapshots(widget.idtruyen, sapxep, ktrbanthao)
          .then((vale) {
        setState(() {
          chuongStream = vale;
        });
      });
    } catch (e) {
      // ignore: prefer_interpolation_to_compose_strings
      print('Lỗi  ' + e.toString());
    }
    DsDocStream = await DatabaseDSDoc().getALLDanhSachDoc(widget.iduser);
    await DatabaseChuong()
        .getStringIdChuong(widget.idtruyen, widget.vtChuong, sapxep)
        .then((value) {
      setState(() {
        idchuong = value;
      });
    });
    await DatabaseUser()
        .getALLTruyenThuVien(widget.iduser, widget.idtruyen)
        .then((value) {
      setState(() {
        thuvien = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: chuongStream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return SafeArea(
              child: Scaffold(
                floatingActionButton: widget.edit == true
                    ? Visibility(
                        visible: tapbarbool,
                        child: FloatingActionButton(
                          onPressed: () {
                            // chinh sua chuong
                          },
                          child: const Icon(
                            Icons.edit,
                          ),
                        ),
                      )
                    : null,
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(
                      kToolbarHeight), // Đặt chiều cao của AppBar bằng kToolbarHeight
                  child: Visibility(
                    visible:
                        tapbarbool, // Ẩn hoặc hiển thị AppBar dựa trên giá trị của biến tapbarbool
                    child: AppBar(
                      backgroundColor: ColorClass.xanh2Color,
                      title: Align(
                        alignment: Alignment.topLeft,
                        child: widget.edit &&
                                snapshot.data!.docs[widget.vtChuong]
                                        ['tinhtrang'] ==
                                    'Bản thảo'
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    snapshot.data!.docs[widget.vtChuong]
                                        ['tenchuong'],
                                    style:
                                        AppTheme.lightTextTheme.displayMedium,
                                    softWrap: true,
                                  ),
                                  Text(
                                    '(Bản thảo)',
                                    style: AppTheme.lightTextTheme.bodySmall,
                                  )
                                ],
                              )
                            : Text(
                                snapshot.data!.docs[widget.vtChuong]
                                    ['tenchuong'],
                                style: AppTheme.lightTextTheme.displayMedium,
                                softWrap: true,
                              ),
                      ),
                    ),
                  ),
                ),
                endDrawer: Drawer(
                    child: ListView(
                  physics: const ScrollPhysics(),
                  children: <Widget>[
                    DrawerHeader(
                      // ignore: sort_child_properties_last
                      child: Image.network(
                        // ignore: prefer_interpolation_to_compose_strings
                        truyenData['linkanh'],
                        height: 150,
                      ),
                      decoration: const BoxDecoration(color: Colors.white),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => TruyenChiTietScreen(
                                    idtruyen: truyenData['idtruyen'] as String,
                                    edit: widget.edit)));
                      },
                      title: Center(
                        child: Text(
                          truyenData['tentruyen'] ?? 'Tên truyện',
                          style: AppTheme.lightTextTheme.displayMedium,
                          softWrap: true,
                        ),
                      ),
                    ),
                    ListTile(
                        onTap: () {
                          // chuyen trang ca nhan
                        },
                        title:
                            Center(child: TacGiaAvata(truyenData['tacgia']))),
                    Padding(
                      padding: const EdgeInsets.only(left: 50, right: 50),
                      child: Container(
                        decoration: BoxDecoration(
                            color: ColorClass
                                .thirdColor, // const Color.fromARGB(255, 213, 216, 218),
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(15)),
                        height: 40,
                        child: TextButton(
                            onPressed: () {
                              ModelInser().ShowModal(
                                context,
                                DsDocStream,
                                thuvien,
                                widget.idtruyen,
                              );
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  color: Colors.black,
                                  size: 14,
                                ),
                                Text(
                                  "Thêm vào danh sách đọc",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ],
                            )),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(
                      color: Color.fromARGB(255, 83, 82, 82),
                    ),
                    for (int i = 0;
                        i < snapshot.data!.docs.length;
                        i++) // Thay 10 bằng số chương thực tế của bạn
                      ListTile(
                        title: Text(
                            snapshot.data!.docs[i]['tenchuong']), // Tên chương
                        onTap: () {
                          setState(() {
                            widget.vtChuong = i;

                            // gui du lieu noi dung
                          });
                        },
                        textColor: widget.vtChuong == i
                            ? ColorClass.fiveColor
                            : Colors.black,
                      ),
                  ],
                )),
                body: Column(
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            tapbarbool = !tapbarbool;
                          });
                        },
                        onLongPress: () {
                          setState(() {
                            tapbarbool = false;
                          });
                        },
                        child: SingleChildScrollView(
                          controller: _controller,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 25, right: 25, top: 30, bottom: 20),
                            child: quill.QuillEditor.basic(
                              controller: quill.QuillController(
                                onSelectionChanged: (textSelection) {
                                  setState(() {
                                    tapbarbool = !tapbarbool;
                                  });
                                },
                                document: quill.Document.fromJson(jsonDecode(
                                    snapshot.data!.docs[widget.vtChuong]
                                        ['noidung'])),
                                selection:
                                    const TextSelection.collapsed(offset: 0),
                              ),
                              readOnly: true,
                              focusNode: null,
                              autoFocus: false,

                              //enableInteractiveSelection: false
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 18,
                      margin: EdgeInsets.only(bottom: 2),
                      child: Visibility(
                        visible: tapbarbool,
                        child: Slider(
                          activeColor: ColorClass
                              .xanh3Color, // Đây là màu cho phần slider đã chọn
                          inactiveColor: ColorClass.xanh1Color,
                          value: scrollProgress,
                          onChanged: (value) {
                            print('gọi onchang');

                            setState(() {
                              scrollProgress = value;
                              // cập nhật tiến trình đọc nội dung dựa trên giá trị của `value`.
                              double newScrollPosition =
                                  value * _controller.position.maxScrollExtent;
                              _controller.jumpTo(newScrollPosition);
                            });
                          },
                          min: 0.0,
                          max: 1.0,
                        ),
                      ),
                    ),
                  ],
                ),
                bottomNavigationBar: PreferredSize(
                    preferredSize: const Size.fromHeight(
                        kBottomNavigationBarHeight), // Đặt chiều cao của AppBar bằng kToolbarHeight
                    child: Visibility(
                        visible:
                            tapbarbool, // Ẩn hoặc hiển thị AppBar dựa trên giá trị của biến tapbarbool
                        child: BottomNavigationBar(
                          selectedItemColor: ColorClass.xanh3Color,
                          unselectedItemColor: ColorClass.xanh3Color,

                          unselectedLabelStyle:
                              const TextStyle(color: ColorClass.xanh3Color),
                          selectedLabelStyle:
                              const TextStyle(color: ColorClass.xanh3Color),
                          backgroundColor:
                              const Color.fromARGB(181, 213, 213, 213),
                          //fixedColor: Colors.grey,
                          currentIndex:
                              _currentIndex, // Chỉ định mục được chọn bằng currentIndex
                          onTap: (int index) {
                            setState(() {
                              _currentIndex =
                                  index; // Cập nhật currentIndex khi người dùng chọn một mục khác
                            });

                            // Xử lý sự kiện tương ứng với mục được chọn
                            switch (index) {
                              case 0:
                                setState(() {
                                  if (widget.vtChuong <= 0) {
                                  } else {
                                    widget.vtChuong = widget.vtChuong - 1;
                                    binhchon = false;
                                  }
                                  //  _currentIndex = 1;
                                });
                                break;
                              case 1:
                                setState(() {
                                  // them so luong binh chon cho chuong
                                  binhchon = !binhchon;
                                  updateBinhChon(
                                      widget.idtruyen, idchuong, binhchon);
                                  //  _currentIndex = 1;
                                });
                                break;
                              case 2:
                                // chuyen den binh luan
                                break;
                              case 3:
                                setState(() {
                                  if (widget.vtChuong >=
                                      (snapshot.data!.docs.length - 1)) {
                                    MsgDialog.showSnackbarTextColor(
                                        context,
                                        ColorClass.second2Color,
                                        Colors.black,
                                        "Đã cập nhật đến chương hiện có");
                                  } else {
                                    widget.vtChuong = widget.vtChuong + 1;
                                    binhchon = false;
                                  }
                                  // _currentIndex = 1;
                                });
                                break;
                            }
                          },
                          items: [
                            const BottomNavigationBarItem(
                              icon: Icon(Icons.arrow_back),
                              label: 'Trở lại',
                            ),
                            BottomNavigationBarItem(
                              icon: (binhchon)
                                  ? const Icon(
                                      Icons.star,
                                      color: ColorClass.xanh3Color,
                                    )
                                  : const Icon(
                                      Icons.star_border_outlined,
                                      color: ColorClass.xanh3Color,
                                    ),
                              label:
                                  '${snapshot.data!.docs[widget.vtChuong]['binhchon']}',
                            ),
                            const BottomNavigationBarItem(
                              icon: Icon(Icons.chat_bubble_outline),
                              label: 'Bình luận',
                            ),
                            const BottomNavigationBarItem(
                              icon: Icon(Icons.arrow_forward),
                              label: 'Tiếp theo',
                            ),
                          ],
                        ))),
              ),
            );
          } else {
            return const Center(
                child: CircularProgressIndicator(
              color: ColorClass.fiveColor,
            ));
          }
        });
  }
}
