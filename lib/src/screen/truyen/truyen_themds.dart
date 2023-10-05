import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../bloc/bloc_userlogin.dart';
import '../../firebase/services/database_danhsachdoc.dart';
import '../../helper/temple/Color.dart';
import '../../helper/temple/app_theme.dart';

class ModelInser {
  // ignore: non_constant_identifier_names
  static Future<dynamic> ShowModal(
      BuildContext context,
      // ignore: non_constant_identifier_names
      Stream<QuerySnapshot> DsDocStream,
      String idtruyen) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          final blocUserLogin =
              Provider.of<BlocUserLogin>(context, listen: true);
          // ignore: unused_local_variable
          return StreamBuilder<QuerySnapshot>(
              stream: DsDocStream,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var i = 0; i < snapshot.data.docs.length; i++)
                        ListTile(
                          leading: kiemDS(idtruyen,
                                  snapshot.data.docs[i]['danhsachtruyen'])
                              ? const Icon(Icons.check_circle)
                              : const Icon(Icons.library_books_rounded),
                          iconColor: kiemDS(idtruyen,
                                  snapshot.data.docs[i]['danhsachtruyen'])
                              ? ColorClass.selectedColor
                              : Colors.black,
                          textColor: kiemDS(idtruyen,
                                  snapshot.data.docs[i]['danhsachtruyen'])
                              ? ColorClass.selectedColor
                              : Colors.black,
                          title: Text(
                            snapshot.data.docs[i]['tendanhsachdoc'],
                            style: const TextStyle(fontSize: 16),
                          ),
                          onTap: () {
                            print(kiemDS(idtruyen,
                                snapshot.data.docs[i]['danhsachtruyen']));
                            kiemDS(idtruyen,
                                    snapshot.data.docs[i]['danhsachtruyen'])
                                ? DatabaseDSDoc().deleteTruyen(
                                    blocUserLogin.id,
                                    snapshot.data.docs[i]['iddanhsach'],
                                    idtruyen)
                                : DatabaseDSDoc().inserTruyen(
                                    blocUserLogin.id,
                                    snapshot.data.docs[i]['iddanhsach'],
                                    idtruyen);
                          },
                        ),
                      ListTile(
                        iconColor: ColorClass.fiveColor,
                        textColor: ColorClass.fiveColor,
                        leading: const Icon(Icons.library_add),
                        title: const Text('Tạo danh sách đọc',
                            style: TextStyle(fontSize: 16)),
                        onTap: () {
                          showCreateDSDiaLog(
                              context, blocUserLogin.id, idtruyen);
                        },
                      )
                    ],
                  );
                } else {
                  return SizedBox(
                    height: 100,
                    child: ListTile(
                      iconColor: ColorClass.fiveColor,
                      textColor: ColorClass.fiveColor,
                      leading: const Icon(Icons.library_add),
                      title: const Text('Tạo danh sách đọc',
                          style: TextStyle(fontSize: 16)),
                      onTap: () {
                        showCreateDSDiaLog(context, blocUserLogin.id, idtruyen);
                      },
                    ),
                  );
                }
              });
        });
  }

  static bool kiemDS(String idtruyen, List<dynamic> ds) {
    for (var i = 0; i < ds.length; i++) {
      if (idtruyen == ds[i]) {
        return true;
      }
    }
    return false;
  }

  static showCreateDSDiaLog(
      BuildContext context, String iduser, String idtruyen) async {
    String inputText = '';
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Tạo danh sách đọc',
                style: AppTheme.lightTextTheme.bodyLarge),
            content: TextField(
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
                    Navigator.of(context).pop();
                  },
                  child: const Text('Thêm',
                      style: TextStyle(color: ColorClass.fiveColor))),
            ],
          );
        });
  }
}
