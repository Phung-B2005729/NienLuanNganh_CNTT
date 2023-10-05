import 'package:apparch/src/firebase/services/database_truyen.dart';
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

// ignore: must_be_immutable
class ChuongNoiDungScreen extends StatefulWidget {
  String idtruyen;
  String iduser;
  bool edit;
  // ignore: prefer_typing_uninitialized_variables
  var vtChuong;

  ChuongNoiDungScreen(
      {super.key,
      required this.idtruyen,
      required this.vtChuong,
      required this.iduser,
      required this.edit});

  @override
  State<ChuongNoiDungScreen> createState() => _ChuongNoiDungScreenState();
}

class _ChuongNoiDungScreenState extends State<ChuongNoiDungScreen> {
  bool sapxep = false;
  Stream<QuerySnapshot>? chuongStream;
  var truyenData;
  var tapbarbool = true;
  var binhchon = false;
  int _currentIndex = 3;
  List<String> noidung = [];
  Stream<QuerySnapshot>? DsDocStream;
  @override
  void initState() {
    super.initState();
    getData();
    getIndex();
  }

  getIndex() {
    if (widget.vtChuong > 0) {
      _currentIndex = 0;
    } else {
      _currentIndex = 3;
    }
  }

  getData() async {
    // lay noi dung truyen
    await DatabaseTruyen().getTruyenId(widget.idtruyen).then((value) {
      setState(() {
        truyenData = value;
      });
    });
    // lay ds tat ca chuong // noi dung 1 truyen;
    await DatabaseChuong()
        .getALLChuongSnapshots(widget.idtruyen, sapxep)
        .then((vale) {
      chuongStream = vale;
    });
    DsDocStream = await DatabaseDSDoc().getALLDanhSachDoc(widget.iduser);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: chuongStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            noidung = splitString(
                snapshot.data!.docs[widget.vtChuong]['noidung'] as String);
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
                        child: widget.edit
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
                                    '(Bản xem trước)',
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
                          // softWrap: true,
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
                                  context, DsDocStream!, widget.idtruyen);
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
                body: InkWell(
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
                  child: (SingleChildScrollView(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 30, right: 30, top: 20, bottom: 20),
                        child: Column(
                          children: <Widget>[
                            for (var doan in noidung)
                              Column(
                                children: [
                                  Text(doan),
                                  SizedBox(height: 10),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  )),
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
                              const Color.fromARGB(181, 255, 255, 255),
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
                                  }
                                  // _currentIndex = 1;
                                });
                                break;
                              case 1:
                                setState(() {
                                  // them so luong binh chon cho chuong
                                  binhchon = !binhchon;
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
                              label: 'Bình chọn',
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

  //tac chuoi
  splitString(String chuoi) {
    // ignore: unused_local_variable
    List<String> cacDoan = chuoi.split('.');
    return cacDoan;
  }
}
