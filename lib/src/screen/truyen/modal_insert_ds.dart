import 'package:apparch/src/firebase/services/database_truyen.dart';
import 'package:apparch/src/firebase/services/database_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../bloc/bloc_userlogin.dart';
import '../../firebase/services/database_danhsachdoc.dart';
import '../../helper/temple/Color.dart';
import '../../helper/temple/app_theme.dart';

class ModelInser {
  // ignore: non_constant_identifier_names
  Future<dynamic> ShowModal(
      BuildContext context,
      // ignore: non_constant_identifier_names
      Stream<QuerySnapshot>? DsDocStream,
      Stream<QuerySnapshot>? ThuVienStream,
      String idtruyen) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          final blocUserLogin =
              Provider.of<BlocUserLogin>(context, listen: true);
          // ignore: unused_local_variable, unnecessary_null_comparison
          if (DsDocStream != null) {
            return StreamBuilder<QuerySnapshot>(
                stream: DsDocStream,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData && snapshot.data.docs.isNotEmpty) {
                    print(kiemDS(
                        idtruyen, snapshot.data.docs[0]['danhsachtruyen']));
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TileThuVien(ThuVienStream, idtruyen, blocUserLogin),
                        for (var i = 0; i < snapshot.data.docs.length; i++)
                          tiltDsDoc(idtruyen, snapshot, i, blocUserLogin),
                        tiltThem(context, blocUserLogin, idtruyen)
                      ],
                    );
                  } else {
                    return ThemDsMoi(
                        ThuVienStream, idtruyen, blocUserLogin, context);
                  }
                });
          } else {
            return ThemDsMoi(ThuVienStream, idtruyen, blocUserLogin, context);
          }
        });
  }

  ListTile tiltThem(
      BuildContext context, BlocUserLogin blocUserLogin, String idtruyen) {
    return ListTile(
      iconColor: ColorClass.fiveColor,
      textColor: ColorClass.fiveColor,
      leading: const Icon(Icons.library_add),
      title: const Text('Tạo danh sách đọc', style: TextStyle(fontSize: 18)),
      onTap: () {
        showCreateDSDiaLog(context, blocUserLogin.id, idtruyen);
      },
    );
  }

  ListTile tiltDsDoc(String idtruyen, AsyncSnapshot<dynamic> snapshot, int i,
      BlocUserLogin blocUserLogin) {
    return ListTile(
      leading: kiemDS(idtruyen, snapshot.data.docs[i]['danhsachtruyen'])
          ? const Icon(Icons.check_circle)
          : const Icon(Icons.library_books_rounded),
      iconColor: kiemDS(idtruyen, snapshot.data.docs[i]['danhsachtruyen'])
          ? ColorClass.selectedColor
          : Colors.black,
      textColor: kiemDS(idtruyen, snapshot.data.docs[i]['danhsachtruyen'])
          ? ColorClass.selectedColor
          : Colors.black,
      title: Text(
        snapshot.data.docs[i]['tendanhsachdoc'],
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onTap: () {
        print(kiemDS(idtruyen, snapshot.data.docs[i]['danhsachtruyen']));
        if (kiemDS(idtruyen, snapshot.data.docs[i]['danhsachtruyen'])) {
          DatabaseDSDoc()
              .deleteTruyen(snapshot.data.docs[i]['iddanhsach'], idtruyen);
          DatabaseTruyen().deleteDSDocGia(blocUserLogin.id, idtruyen);
        } else {
          DatabaseDSDoc()
              .inserTruyen(snapshot.data.docs[i]['iddanhsach'], idtruyen);
          DatabaseTruyen().insertDSDocGia(blocUserLogin.id, idtruyen);
        }
      },
    );
  }

  Column ThemDsMoi(Stream<QuerySnapshot<Object?>>? ThuVienStream,
      String idtruyen, BlocUserLogin blocUserLogin, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TileThuVien(ThuVienStream, idtruyen, blocUserLogin),
        tiltThem(context, blocUserLogin, idtruyen)
      ],
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> TileThuVien(
      Stream<QuerySnapshot<Object?>>? ThuVienStream,
      String idtruyen,
      BlocUserLogin blocUserLogin) {
    return StreamBuilder<QuerySnapshot>(
        stream: ThuVienStream,
        builder: (context, AsyncSnapshot snapshot) {
          // ignore: unnecessary_null_comparison
          if (snapshot.hasData && snapshot != null) {
            return ListTile(
              // ignore: unrelated_type_equality_checks
              leading: ktrThuVien(snapshot.data.docs, idtruyen)
                  ? const Icon(Icons.check_circle)
                  : const Icon(Icons.library_books_rounded),
              // ignore: unrelated_type_equality_checks
              iconColor: ktrThuVien(snapshot.data.docs, idtruyen)
                  ? ColorClass.selectedColor
                  : Colors.black,
              // ignore: unrelated_type_equality_checks
              textColor: ktrThuVien(snapshot.data.docs, idtruyen)
                  ? ColorClass.selectedColor
                  : Colors.black,
              title: const Text(
                'Thư viện',
                style: TextStyle(fontSize: 16),
              ),
              onTap: () {
                print(ktrThuVien(snapshot.data.docs, idtruyen));
                ktrThuVien(snapshot.data.docs, idtruyen) == true
                    ? DatabaseUser()
                        .deleteOneTruyenOnThuVien(blocUserLogin.id, idtruyen)
                    : DatabaseUser().createThuVien(blocUserLogin.id, idtruyen);
              },
            );
          } else {
            return ListTile(
              // ignore: unrelated_type_equality_checks
              leading: ktrThuVien([], idtruyen)
                  ? const Icon(Icons.check_circle)
                  : const Icon(Icons.library_books_rounded),
              // ignore: unrelated_type_equality_checks
              iconColor: ktrThuVien([], idtruyen)
                  ? ColorClass.selectedColor
                  : Colors.black,
              // ignore: unrelated_type_equality_checks
              textColor: ktrThuVien([], idtruyen)
                  ? ColorClass.selectedColor
                  : Colors.black,
              title: const Text(
                'Thư viện',
                style: TextStyle(fontSize: 16),
              ),
              onTap: () {
                print(ktrThuVien([], idtruyen));
                ktrThuVien([], idtruyen)
                    ? DatabaseUser()
                        .deleteOneTruyenOnThuVien(blocUserLogin.id, idtruyen)
                    : DatabaseUser().createThuVien(blocUserLogin.id, idtruyen);
              },
            );
          }
        });
  }

  bool kiemDS(String idtruyen, List<dynamic> ds) {
    for (var i = 0; i < ds.length; i++) {
      if (idtruyen == ds[i]) {
        return true;
      }
    }
    return false;
  }

  bool ktrThuVien(List<QueryDocumentSnapshot> truyen, String idtruyen) {
    if (truyen.isNotEmpty) {
      for (var i = 0; i < truyen.length; i++) {
        if (idtruyen == truyen[i]['idtruyen']) {
          return true;
        }
      }
      return false;
    } else {
      return false;
    }
  }

  showCreateDSDiaLog(
      BuildContext context, String iduser, String idtruyen) async {
    String inputText = '';
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Tạo danh sách đọc',
                style: AppTheme.lightTextTheme.bodyLarge),
            content: TextFormField(
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
                    await DatabaseDSDoc()
                        .createNewInsert(iduser, idtruyen, inputText);
                    await DatabaseTruyen().insertDSDocGia(iduser, idtruyen);
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  },
                  child: const Text('Thêm',
                      style: TextStyle(color: ColorClass.fiveColor))),
            ],
          );
        });
  }
}
