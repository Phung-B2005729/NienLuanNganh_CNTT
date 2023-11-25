import 'dart:convert';

import 'package:apparch/src/firebase/services/database_truyen.dart';
import 'package:apparch/src/firebase/services/database_user.dart';
import 'package:apparch/src/helper/helper_function.dart';
import 'package:apparch/src/helper/temple/app_theme.dart';
import 'package:apparch/src/helper/temple/color.dart';
import 'package:apparch/src/screen/binhluan/binhluan_screen.dart';
import 'package:apparch/src/screen/chuong/chuong_edit.dart';
import 'package:apparch/src/screen/share/mgsDiaLog.dart';
import 'package:apparch/src/screen/share/modal_insert_danhsachdoc.dart';
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
  // ignore: prefer_typing_uninitialized_variables
  var truyenData;
  var tapbarbool = true;
  String idchuong = '';
  var binhchon = false;
  List<String> noidung = [];
  Stream<QuerySnapshot>? DsDocStream;
  final ScrollController _controller = ScrollController();
  double scrollProgress = 0.0;
  var blocUserLogin;
  Stream<QuerySnapshot>? thuvien;
  QuerySnapshot? ListIdTruyenThuVien;
  bool ktrthuvien = false;
  int chuongdadoc = 0;
  int chuongtam = 0;
  @override
  void initState() {
    super.initState();
    getData();
    getChuongDaDoc();
    _controller.addListener(() {
      _scrollListener();
    });
  }

  @override
  void dispose() {
    // Dispose resources, timers, listeners, etc.
    _controller.dispose();
    super.dispose();
  }

  getChuongDaDoc() async {
    // luu lai tientrinh truoc lưu vào cục bộ
    HelperFunctions.saveIdtruyenTienTrinh(widget.idtruyen, widget.vtChuong + 1);
    await HelperFunctions.getIdTruyenTienTrinh(widget.idtruyen).then((value) {
      setState(() {
        chuongdadoc = value;
      });
    });
    await DatabaseUser()
        .getALLTruyenThuVienGet(widget.iduser)
        .then((value) => ListIdTruyenThuVien = value);
    final truyenThuVienDoc = await DatabaseUser()
        .getOneTruyenThuVien(widget.iduser, widget.idtruyen);
    if (mounted) {
      setState(() {
        // cập nhật xem có trong thư viện hay không ?
        ktrthuvien =
            ModelInser().ktrThuVien(ListIdTruyenThuVien!.docs, widget.idtruyen);
        print(ktrthuvien);

        if (truyenThuVienDoc != null && truyenThuVienDoc.exists) {
          chuongtam = truyenThuVienDoc.data() != null
              ? truyenThuVienDoc.data()['chuongdadoc'] as int
              : 0;
        }
        // ignore: avoid_print, prefer_interpolation_to_compose_strings
        print('chung tam ' + chuongtam.toString());
      });
    }
  }

  void _scrollListener() async {
    setState(() {
      scrollProgress =
          _controller.position.pixels / _controller.position.maxScrollExtent;
    });
    if (idchuong != '') {
      if (scrollProgress == 1.00) {
        // hoàn thành đọc xong 1 chương
        print(scrollProgress);
        updateLuotXem(widget.idtruyen, idchuong);
        // up date chương đã đọc idtruyen , so chương đã đọc = vt +1
        HelperFunctions.saveIdtruyenTienTrinh(
            widget.idtruyen, widget.vtChuong + 1);
        await HelperFunctions.getIdTruyenTienTrinh(widget.idtruyen)
            .then((value) {
          setState(() {
            chuongdadoc = value;
          });
        });
        // ignore: avoid_print, prefer_interpolation_to_compose_strings
        print('chuongdadoc' + chuongdadoc.toString());
        if (ktrthuvien == true) {
          if (chuongtam <= chuongdadoc) {
            await DatabaseUser()
                .updateChuongDaDoc(widget.iduser, widget.idtruyen, chuongdadoc);
          }
        }
      }
    }
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

  Future<void> updateBinhChon(
      String idtruyen, String idchuong, bool ktr) async {
    print('gọi update hàm' + ktr.toString());
    try {
      print('gọi update hàm' + ktr.toString());
      await DatabaseChuong().updateBinhChon(idtruyen, idchuong, ktr);
      await DatabaseTruyen().updateBinhChon(idtruyen, ktr);
    } catch (e) {
      print('Lỗi ' + e.toString());
    }
  }

  getData() async {
    // lay noi dung truyen
    await DatabaseTruyen().getTruyenId(widget.idtruyen).then((value) {
      if (mounted) {
        setState(() {
          truyenData = value;
        });
      }
    });
    bool ktrbanthao = true;
    if (widget.edit == true) ktrbanthao = false;
    // lay ds tat ca chuong // noi dung 1 truyen;
    try {
      await DatabaseChuong()
          .getALLChuongSnapshots(widget.idtruyen, sapxep, ktrbanthao)
          .then((vale) {
        if (mounted) {
          setState(() {
            chuongStream = vale;
          });
        }
      });
    } catch (e) {
      // ignore: prefer_interpolation_to_compose_strings
      print('Lỗi  ' + e.toString());
    }
    DsDocStream = await DatabaseDSDoc().getALLDanhSachDoc(widget.iduser);
    await DatabaseChuong()
        .getStringIdChuong(widget.idtruyen, widget.vtChuong, sapxep)
        .then((value) {
      if (mounted) {
        setState(() {
          idchuong = value;
        });
      }
    });
    thuvien = await DatabaseUser().getALLTruyenThuVien(widget.iduser);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: chuongStream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return SafeArea(
              child: Scaffold(
                floatingActionButton:
                    widget.edit == true ? BuildFloadtingEdit(snapshot) : null,
                appBar: BuildAppBarPreferSize(snapshot),
                endDrawer: BuildEndDrawer(context, snapshot),
                body: Column(
                  children: <Widget>[
                    BuildNoiDung(snapshot),
                    BuildSiderTienTrinh(context),
                    BuildRowBottom(snapshot, context)
                  ],
                ),
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

  // ignore: non_constant_identifier_names
  Visibility BuildFloadtingEdit(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    return Visibility(
      visible: tapbarbool,
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => EditChuong(
                      idtruyen: widget.idtruyen,
                      idchuong: idchuong,
                      tchuong: snapshot.data!.docs[widget.vtChuong]
                          ['tenchuong'],
                      nd: snapshot.data!.docs[widget.vtChuong]['noidung'],
                      tinhtrang: snapshot.data!.docs[widget.vtChuong]
                          ['tinhtrang'],
                      edit: true)));
        },
        child: const Icon(
          Icons.edit,
        ),
      ),
    );
  }

  Widget BuildRowBottom(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 0),
      child: Visibility(
        visible: tapbarbool,
        child: Container(
          // color: ColorC,
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 8, top: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              BuildTroLaiChuongSau(),
              BuildBinhChon(snapshot, context),
              BuildBinhLuan(snapshot, context),
              BuildChuongTiepTheo(snapshot, context)
            ],
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Column BuildChuongTiepTheo(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot, BuildContext context) {
    return Column(
      children: [
        IconButton(
            color: ColorClass.fiveColor,
            onPressed: () {
              setState(() {
                if (widget.vtChuong >= (snapshot.data!.docs.length - 1)) {
                  MsgDialog.showSnackbarTextColor(
                      context,
                      ColorClass.second2Color,
                      Colors.black,
                      "Đã cập nhật đến chương hiện có");
                } else {
                  widget.vtChuong = widget.vtChuong + 1;
                  binhchon = false;

                  scrollProgress =
                      0.0; // chuyển chương mới cập nhật lại tiến trình
                  double newScrollPosition =
                      scrollProgress * _controller.position.maxScrollExtent;
                  _controller.jumpTo(newScrollPosition);
                }
                // _currentIndex = 1;
              });
            },
            icon: const Icon(Icons.arrow_forward)),
        const Text('Tiếp theo',
            style: TextStyle(fontSize: 12, color: ColorClass.fiveColor))
      ],
    );
  }

  Column BuildBinhLuan(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot, BuildContext context) {
    return Column(
      children: [
        IconButton(
            color: ColorClass.fiveColor,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => BinhLuanScreen(
                          tenchuong: snapshot.data!.docs[widget.vtChuong]
                              ['tenchuong'],
                          idtacgia: truyenData['tacgia'],
                          idtruyen: widget.idtruyen,
                          idchuong: snapshot.data!.docs[widget.vtChuong]
                              ['idchuong'])));
            },
            icon: Icon(Icons.chat_bubble_outline)),
        const Text('Bình luận',
            style: TextStyle(fontSize: 12, color: ColorClass.fiveColor))
      ],
    );
  }

  Column BuildBinhChon(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot, BuildContext context) {
    return Column(
      children: [
        IconButton(
          color: ColorClass.fiveColor,
          onPressed: () {
            setState(() {
              // them so luong binh chon cho chuong
              binhchon = !binhchon;
              print('Before update: $binhchon');
              updateBinhChon(widget.idtruyen,
                  snapshot.data!.docs[widget.vtChuong]['idchuong'], binhchon);

              print('After update: $binhchon');
            });
          },
          icon: (binhchon)
              ? const Icon(
                  Icons.star,
                  color: ColorClass.xanh3Color,
                )
              : const Icon(
                  Icons.star_border_outlined,
                  color: ColorClass.xanh3Color,
                ),
        ),
        Text(snapshot.data!.docs[widget.vtChuong]['binhchon'].toString(),
            style: TextStyle(fontSize: 12, color: ColorClass.fiveColor))
      ],
    );
  }

  Column BuildTroLaiChuongSau() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
            onPressed: () {
              setState(() {
                if (widget.vtChuong <= 0) {
                } else {
                  widget.vtChuong = widget.vtChuong - 1;
                  binhchon = false;

                  scrollProgress = 0.0;
                  double newScrollPosition =
                      scrollProgress * _controller.position.maxScrollExtent;
                  _controller.jumpTo(newScrollPosition);
                }
              });
            },
            color: ColorClass.fiveColor,
            icon: const Icon(
              Icons.arrow_back,
            )),
        const Text('Trở lại',
            style: TextStyle(fontSize: 12, color: ColorClass.fiveColor))
      ],
    );
  }

  Widget BuildSiderTienTrinh(BuildContext context) {
    return SizedBox(
      height: 10,
      width: MediaQuery.of(context).size.width,
      //   margin: EdgeInsets.only(bottom: 2),
      child: Visibility(
        visible: tapbarbool,
        child: Slider(
          activeColor:
              ColorClass.xanh3Color, // Đây là màu cho phần slider đã chọn
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
    );
  }

  Expanded BuildNoiDung(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    return Expanded(
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
            padding:
                const EdgeInsets.only(left: 25, right: 25, top: 30, bottom: 20),
            child: quill.QuillEditor.basic(
              controller: quill.QuillController(
                onSelectionChanged: (textSelection) {
                  setState(() {
                    tapbarbool = !tapbarbool;
                  });
                },
                document: quill.Document.fromJson(jsonDecode(
                    snapshot.data!.docs[widget.vtChuong]['noidung'])),
                selection: const TextSelection.collapsed(offset: 0),
              ),
              readOnly: true,
              focusNode: null,
              autoFocus: false,

              //enableInteractiveSelection: false
            ),
          ),
        ),
      ),
    );
  }

  Drawer BuildEndDrawer(
      BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    return Drawer(
        child: ListView(
      physics: const ScrollPhysics(),
      children: <Widget>[
        BuildDrawerHeader(),
        BuildTenTruyen(context),
        BuildTacGia(),
        BuildButtonThemDSDoc(context),
        const SizedBox(height: 20),
        const Divider(
          color: Color.fromARGB(255, 83, 82, 82),
        ),
        for (int i = 0;
            i < snapshot.data!.docs.length;
            i++) // Thay 10 bằng số chương thực tế của bạn
          BuildTilteTenChuong(snapshot, i),
      ],
    ));
  }

  ListTile BuildTilteTenChuong(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot, int i) {
    return ListTile(
      title: Text(snapshot.data!.docs[i]['tenchuong']), // Tên chương
      onTap: () {
        setState(() {
          widget.vtChuong = i;
          scrollProgress = 0.0;
          binhchon = false;
          double newScrollPosition =
              scrollProgress * _controller.position.maxScrollExtent;
          _controller.jumpTo(newScrollPosition);

          // gui du lieu noi dung
        });
      },
      textColor: widget.vtChuong == i ? ColorClass.fiveColor : Colors.black,
    );
  }

  Padding BuildButtonThemDSDoc(BuildContext context) {
    return Padding(
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
              if (widget.edit == false) {
                ModelInser().ShowModal(context, DsDocStream, thuvien, true,
                    widget.idtruyen, chuongdadoc);
              } else {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                        "Bạn đang ở bản xem thử không thể mở sự kiện này")));
              }
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
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ],
            )),
      ),
    );
  }

  ListTile BuildTacGia() {
    return ListTile(title: Center(child: TacGiaAvata(truyenData['tacgia'])));
  }

  ListTile BuildTenTruyen(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.popUntil(context, (route) => route.isFirst);
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
    );
  }

  DrawerHeader BuildDrawerHeader() {
    return DrawerHeader(
      // ignore: sort_child_properties_last
      child: Image.network(
        // ignore: prefer_interpolation_to_compose_strings
        truyenData['linkanh'],
        height: 150,
      ),
      decoration: const BoxDecoration(color: Colors.white),
    );
  }

  PreferredSize BuildAppBarPreferSize(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    return PreferredSize(
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
                    snapshot.data!.docs[widget.vtChuong]['tinhtrang'] ==
                        'Bản thảo'
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        snapshot.data!.docs[widget.vtChuong]['tenchuong'],
                        style: AppTheme.lightTextTheme.displayMedium,
                        softWrap: true,
                      ),
                      Text(
                        '(Bản thảo)',
                        style: AppTheme.lightTextTheme.bodySmall,
                      )
                    ],
                  )
                : Text(
                    snapshot.data!.docs[widget.vtChuong]['tenchuong'],
                    style: AppTheme.lightTextTheme.displayMedium,
                    softWrap: true,
                  ),
          ),
        ),
      ),
    );
  }
}
