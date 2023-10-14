import 'package:apparch/src/firebase/services/database_chuong.dart';
import 'package:apparch/src/firebase/services/database_truyen.dart';
import 'package:apparch/src/helper/temple/app_theme.dart';
import 'package:apparch/src/helper/temple/color.dart';
import 'package:apparch/src/screen/share/loadingDialog.dart';
import 'package:apparch/src/screen/share/mgsDiaLog.dart';
import 'package:apparch/src/screen/truyen/truyen_chi_tiet_amition.dart';
import 'package:apparch/src/screen/viettruyen/edit/truyen_edit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../helper/date_time_function.dart';

// ignore: must_be_immutable
class VietTruyenList extends StatelessWidget {
  Stream<QuerySnapshot>? truyenStream;
  bool ktrbanthao;
  Color tcolor;
  VietTruyenList(this.truyenStream, this.ktrbanthao, this.tcolor, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: truyenStream,
      builder: (context, AsyncSnapshot snapshot) {
        return (snapshot.hasData && snapshot.data.docs.length != 0)
            ? ListView.separated(
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 2);
                },
                scrollDirection:
                    Axis.vertical, // true cuon doc, false cuon ngang
                itemCount: snapshot.data.docs.length, // Số lượng phần tử ngang
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TruyenChiTietAmition(
                                    lisTruyen: snapshot.data.docs,
                                    vttruyen: index,
                                    edit: true,
                                  )));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8, bottom: 8, left: 8, right: 0),
                      child: Container(
                        height: 150,
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
                        child: Dismissible(
                          // loai bo bang cach luot
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
                            return MsgDialog.showConfirmDialogDismissible(
                              context,
                              "Bạn chắc chăn muốn xoá truyện này ?",
                            );
                          },
                          onDismissed: (direction) async {
                            try {
                              LoadingDialog.showLoadingDialog(
                                  context, 'Loading...');
                              await DatabaseTruyen().deleleOneTruyen(
                                  snapshot.data.docs[index]['idtruyen']);
                              // ignore: use_build_context_synchronously
                              LoadingDialog.hideLoadingDialog(context);
                            } catch (e) {
                              // ignore: use_build_context_synchronously
                              LoadingDialog.hideLoadingDialog(context);
                              // ignore: use_build_context_synchronously
                              MsgDialog.showSnackbar(context, Colors.red,
                                  "Lỗi vui lòng thử lại!!");
                              print("loi xoa image " + e.toString());
                            }
                            // ignore: avoid_print
                            print('Đã xoá');
                          },
                          child: Card(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                snapshot.data.docs[index]['linkanh'] != null
                                    ? Container(
                                        height: 150,
                                        width: 110,
                                        child: Image.network(
                                          snapshot.data.docs[index]['linkanh'],
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Container(
                                        height: 150,
                                        width: 110,
                                        child: Image.asset(
                                          "assets/images/avatarmacdinh.png",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                SizedBox(
                                  width: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Column(
                                    children: [
                                      Text(
                                          snapshot.data.docs[index]
                                              ['tentruyen'],
                                          style: GoogleFonts.arizonia(
                                            //roboto
                                            // arizonia
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          softWrap: true),
                                      Column(
                                        children: [
                                          Text(
                                            // ignore: prefer_interpolation_to_compose_strings
                                            "Ngày cập nhật ",
                                            style: AppTheme
                                                .lightTextTheme.bodySmall,
                                          ),
                                          Text(
                                            DatetimeFunction
                                                .getTimeFormatDatabase(
                                                    snapshot.data.docs[index]
                                                        ['ngaycapnhat']),
                                            style: AppTheme
                                                .lightTextTheme.bodySmall,
                                            softWrap: true,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: PopupMenuButton(
                                    onSelected: (value) async {
                                      if (value == 'xem trước') {
                                        print(value);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    TruyenChiTietAmition(
                                                      lisTruyen:
                                                          snapshot.data.docs,
                                                      vttruyen: index,
                                                      edit: true,
                                                    )));
                                      } else if (value == 'Dừng đăng tải') {
                                        bool ktr = await dropTruyen(
                                            context,
                                            snapshot.data.docs[index]
                                                ['idtruyen']);
                                        if (ktr == true) {
                                          // ignore: use_build_context_synchronously

                                          // ignore: use_build_context_synchronously
                                        } else {
                                          // ignore: use_build_context_synchronously
                                          MsgDialog.showSnackbar(
                                              context,
                                              Colors.red,
                                              'Lỗi! Vui lòng thử lại');
                                        }
                                      } else if (value == 'Đăng') {
                                        //update tinh trang
                                        print(value);
                                        bool ktr = await dangTruyen(
                                            context,
                                            snapshot.data.docs[index]
                                                ['idtruyen']);
                                        if (ktr == true) {
                                          // ignore: use_build_context_synchronously
                                          MsgDialog.showSnackbar(
                                              context,
                                              ColorClass.fiveColor,
                                              'Đăng truyện thành công!!');
                                          // ignore: use_build_context_synchronously
                                        } else {
                                          // ignore: use_build_context_synchronously
                                          MsgDialog.showSnackbar(
                                              context,
                                              Colors.red,
                                              'Lỗi! Vui lòng thử lại');
                                        }
                                      } else if (value == 'chỉnh sửa') {
                                        print(value);
                                        // Xử lý khi chọn "Chỉnh sửa"
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => EditTruyenScreen(
                                                    tentruyen: snapshot
                                                        .data
                                                        .docs[index]
                                                            ['tentruyen']
                                                        .toString(),
                                                    tag: snapshot.data.docs[index]
                                                        ['tags'],
                                                    tinhtrang: snapshot.data.docs[index]
                                                        ['tinhtrang'],
                                                    linkanh: snapshot.data.docs[index]
                                                        ['linkanh'],
                                                    mota: snapshot.data.docs[index]['mota']
                                                        .toString(),
                                                    theloai: snapshot.data
                                                        .docs[index]['theloai']
                                                        .toString(),
                                                    idtruyen: snapshot.data.docs[index]['idtruyen'].toString(),
                                                    ktrbanthao: ktrbanthao)));
                                      } else if (value == 'xoá') {
                                        print(value);
                                        // Xử lý khi chọn "Xóa"
                                        xoatruyen(
                                            context,
                                            snapshot
                                                .data.docs[index]['idtruyen']
                                                .toString());
                                        // Đặt mã xử lý ở đây
                                      }
                                    },
                                    color: const Color.fromARGB(
                                        255, 237, 236, 236),
                                    icon: const Icon(
                                      Icons.more_vert,
                                      color: Colors.black,
                                    ),
                                    itemBuilder: (context) {
                                      return <PopupMenuEntry<String>>[
                                        ktrbanthao == true
                                            ? PopupMenuItem<String>(
                                                value: 'Đăng',
                                                child: Text(
                                                  'Đăng',
                                                  style: AppTheme
                                                      .lightTextTheme.bodySmall,
                                                ),
                                              )
                                            : PopupMenuItem<String>(
                                                value: 'Dừng đăng tải',
                                                child: Text(
                                                  'Dừng đăng tải',
                                                  style: AppTheme
                                                      .lightTextTheme.bodySmall,
                                                ),
                                              ),
                                        PopupMenuItem<String>(
                                          value: 'xem trước',
                                          child: Text(
                                            'xem trước',
                                            style: AppTheme
                                                .lightTextTheme.bodySmall,
                                          ),
                                        ),
                                        PopupMenuItem<String>(
                                          value: 'chỉnh sửa',
                                          child: Text('chỉnh sửa',
                                              style: AppTheme
                                                  .lightTextTheme.bodySmall),
                                        ),
                                        PopupMenuItem<String>(
                                          value: 'xoá',
                                          child: Text('xoá',
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
                    ),
                  );
                },
              )
            : Padding(
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
                      Text('Không có truyện',
                          style: AppTheme.lightTextTheme.headlineLarge),
                      const SizedBox(height: 20),
                      const Text(
                        'Viết tryện mới?\n'
                        'Nhấn + bên dưới để tạo ngay!',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }

  Future dangTruyen(BuildContext context, String idtruyen) async {
    LoadingDialog.showLoadingDialog(context, 'Loading...');
    try {
      await DatabaseChuong().updateAllTinhTrangChuong(idtruyen, 'Đã đăng');
      await DatabaseTruyen().updateTinhTrangTruyen(idtruyen, "Trưởng thành");
      // ignore: use_build_context_synchronously
      LoadingDialog.hideLoadingDialog(context);
      // ignore: use_build_context_synchronously
      return true;
    } catch (e) {
      LoadingDialog.hideLoadingDialog(context);
      // ignore: use_build_context_synchronously
      print('Lỗi ' + e.toString());
      return false;
    }
  }

  Future xoatruyen(BuildContext context, String idtruyen) async {
    MsgDialog.showXacNhanThongTin(
        context, 'Bạn có chắc chắn muốn xoá truyện này ?', ColorClass.fiveColor,
        () async {
      try {
        LoadingDialog.showLoadingDialog(context, 'Loading...');
        await DatabaseTruyen().deleleOneTruyen(idtruyen);
        // ignore: use_build_context_synchronously
        LoadingDialog.hideLoadingDialog(context);
        // ignore: use_build_context_synchronously
        MsgDialog.showSnackbar(
            context, ColorClass.fiveColor, "Đã xoá thành công!!");
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } catch (e) {
        // ignore: use_build_context_synchronously
        LoadingDialog.hideLoadingDialog(context);
        // ignore: use_build_context_synchronously
        MsgDialog.showSnackbar(context, Colors.red, "Lỗi vui lòng thử lại!!");
        print("loi xoa image " + e.toString());
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    });
  }

  Future<dynamic> dropTruyen(BuildContext context, String idtruyen) async {
    LoadingDialog.showLoadingDialog(context, 'Loading...');
    try {
      // update tinh trang cac chuong
      await DatabaseChuong().updateAllTinhTrangChuong(idtruyen, 'Bản thảo');

      // updat tinh trang truyen
      await DatabaseTruyen().updateTinhTrangTruyen(idtruyen, 'Bản thảo');
      // ignore: use_build_context_synchronously
      LoadingDialog.hideLoadingDialog(context);
      return true;
    } catch (e) {
      // ignore: use_build_context_synchronously
      LoadingDialog.hideLoadingDialog(context);
      // MsgDialog.showSnackbar(context, Colors.red, 'Lỗi vui lòng thử lại');
      return false;
    }
  }
}
