import 'dart:convert';

import 'package:apparch/src/bloc/bloc_thongbao.dart';
import 'package:apparch/src/bloc/bloc_userlogin.dart';
import 'package:apparch/src/firebase/services/database_chuong.dart';
import 'package:apparch/src/firebase/services/database_truyen.dart';
import 'package:apparch/src/helper/date_time_function.dart';
import 'package:apparch/src/helper/temple/app_theme.dart';
import 'package:apparch/src/helper/temple/color.dart';
import 'package:apparch/src/model/chuong_model.dart';
import 'package:apparch/src/model/thongbao_model.dart';
import 'package:apparch/src/screen/chuong/xem_truoc_chuong.dart';
import 'package:apparch/src/screen/share/loadingDialog.dart';
import 'package:apparch/src/screen/share/mgsDiaLog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class InsertChuong extends StatefulWidget {
  String idtruyen;
  InsertChuong({super.key, required this.idtruyen});

  @override
  State<InsertChuong> createState() => _InsertChuongState();
}

class _InsertChuongState extends State<InsertChuong> {
  final _nameController = TextEditingController();
  final _quillEditorcontroller = quill.QuillController.basic();
  final _formKey = new GlobalKey<FormState>();
  String idchuong = '';
  String tenchuong = '';
  dynamic noidung;
  @override
  void initState() {
    super.initState();
  }

  Future<dynamic> saveChuong(
    BuildContext context,
    bool tam,
  ) async {
    String idchuong = '';
    // ignore: unused_local_variable
    List<dynamic>? listdocgia;

    print('gọi hàm lưu');
    if (_formKey.currentState!.validate()) {
      if (_quillEditorcontroller.document.isEmpty() == false) {
        // lay du lieu tieu de
        LoadingDialog.showLoadingDialog(context, 'Loading...');
        try {
          // tác gia
          String idtacgia = context.read<BlocUserLogin>().id;
          // lấy đọc giả
          listdocgia = await DatabaseTruyen().getDocGiaList(widget.idtruyen);
          // lay du lieu noi dung
          tenchuong = _nameController.text;
          noidung =
              jsonEncode(_quillEditorcontroller.document.toDelta().toJson());
          // goi ham tao lay ra idchuong
          String tinhtrang;
          if (tam == false) {
            tinhtrang = 'Đã đăng';
          } else {
            tinhtrang = 'Bản thảo';
          }
          ChuongModel chuongModel = ChuongModel(
              tenchuong: tenchuong,
              noidung: noidung,
              ngaycapnhat: DateTime.now(),
              tinhtrang: tinhtrang);
          idchuong =
              await DatabaseChuong().createChuong(chuongModel, widget.idtruyen);
          if (tinhtrang == 'Đã đăng') {
            ThongBaoModel thongBaoModel = ThongBaoModel(
                tenchuong: tenchuong,
                idchuong: idchuong,
                idtacgia: idtacgia,
                danhsachiduser: listdocgia ?? [],
                idtruyen: widget.idtruyen,
                ngaycapnhat:
                    DatetimeFunction.getGioFormDateTime(DateTime.now()));
            // nếu đăng thì mới có thông báo
            // tạo thông báo
            await context.read<BlocThongBao>().addThongBao(thongBaoModel);
          }
          if (tam == false) {
            print('update truyện');
            await DatabaseTruyen()
                .updateTinhTrangTruyen(widget.idtruyen, 'Trường thành');
          }
          // ignore: use_build_context_synchronously
          LoadingDialog.hideLoadingDialog(context);
          return idchuong;
        } catch (e) {
          // ignore: prefer_interpolation_to_compose_strings
          print('Lỗi dữ liệu ' + e.toString());
          // ignore: use_build_context_synchronously
          LoadingDialog.hideLoadingDialog(context);
          // ignore: use_build_context_synchronously
          MsgDialog.showLoadingDialog(context, 'Lỗi vui lòng thử lại!!');
        }
      } else {
        MsgDialog.showLoadingDialog(
            context, 'Vui lòng nhập vào nội dung chương');
        return idchuong;
      }
    }
    return idchuong;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: ColorClass.xanh3Color,
          title: Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Viết',
              style: AppTheme.lightTextTheme.titleMedium,
            ),
          ),
          actions: [
            PopupMenuButton(
                onSelected: (value) async {
                  if (value == 'Xem trước') {
                    print(value);
                    if (_formKey.currentState!.validate()) {
                      if (_quillEditorcontroller.document.isEmpty() == false) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ChuongXemTruoc(
                                    tieude: _nameController.text,
                                    noidung: jsonEncode(_quillEditorcontroller
                                        .document
                                        .toDelta()
                                        .toJson()),
                                    edit: true)));
                      }

                      // lay du lieu tieu de
                    }
                  } else if (value == 'Đăng') {
                    print(value);
                    // goi ham luu
                    if (idchuong == '') {
                      idchuong = await saveChuong(context, false);
                    } else {
                      //update
                      await DatabaseChuong(idchuong: idchuong)
                          .updateTinhTrangChuong(widget.idtruyen, "Đã đăng");
                      await DatabaseTruyen().updateTinhTrangTruyen(
                          widget.idtruyen, 'Trưởng thành');
                    }
                    if (idchuong != '') {
                      // ignore: use_build_context_synchronously
                      MsgDialog.showSnackbar(context, ColorClass.fiveColor,
                          'Đã đăng một chương mới!!');
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    }
                    // ignore: use_build_context_synchronously
                  } else if (value == 'Lưu') {
                    print(value);
                    // goi ham luu
                    if (idchuong == '') {
                      idchuong = await saveChuong(context, true);
                    }
                    if (idchuong != '') {
                      // ignore: use_build_context_synchronously
                      MsgDialog.showSnackbar(
                          context, ColorClass.fiveColor, 'Đã lưu');
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      // ignore: use_build_context_synchronously

                      // ignore: use_build_context_synchronously
                    }
                  } else if (value == 'Xoá') {
                    print(value);
                    //kiem tu trang them moi hay trang chinh sua
                    // hoi xac nhan xoa
                    MsgDialog.showXacNhanThongTin(
                        context,
                        'Bạn có chắc chắn muốn xoá chương này?',
                        ColorClass.fiveColor, () async {
                      // goi ham xoa dau vao idchuogn idtruyen
                      try {
                        if (idchuong != '') {
                          LoadingDialog.showLoadingDialog(
                              context, 'Loading...');
                          //xoa
                          await context
                              .read<BlocThongBao>()
                              .deleteAllThongBaoIdChuong(idchuong);
                          await DatabaseChuong(idchuong: idchuong)
                              .deleteOneChuong(widget.idtruyen);
                          // ignore: use_build_context_synchronously
                          LoadingDialog.hideLoadingDialog(context);
                          MsgDialog.showSnackbar(
                              context, ColorClass.fiveColor, 'Đã xoá');
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        } else {
                          _nameController.text = '';
                          final quill.Document emptyDocument = quill.Document();
                          // Sử dụng quill.QuillController để thiết lập nội dung của QuillEditor thành đối tượng rỗng
                          _quillEditorcontroller.document = emptyDocument;
                          Navigator.pop(context);
                        }
                        // Xóa thành công, thực hiện các thao tác tiếp theo nếu cần
                      } catch (e) {
                        // Xử lý lỗi nếu có bất kỳ lỗi nào xảy ra trong quá trình xóa
                        print('Lỗi xóa chương: $e');
                      }
                    });
                  }
                },
                color: const Color.fromARGB(255, 237, 236, 236),
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.black,
                ),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'Xem trước',
                        child: Text(
                          'Xem trước',
                          style: AppTheme.lightTextTheme.bodySmall,
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'Lưu',
                        child: Text(
                          'Lưu',
                          style: AppTheme.lightTextTheme.bodySmall,
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'Đăng',
                        child: Text(
                          'Đăng',
                          style: AppTheme.lightTextTheme.bodySmall,
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'Xoá',
                        child: Text('Xoá',
                            style: AppTheme.lightTextTheme.bodySmall),
                      ),
                    ]),
          ]),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Form(
            key: _formKey,
            child: TextFormField(
              autofocus: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập tiêu đề chương';
                }
                return null;
              },
              controller: _nameController,
              style: AppTheme.lightTextTheme.headlineMedium,
              decoration: InputDecoration(
                errorStyle: const TextStyle(fontSize: 12),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorClass.fiveColor),
                ),
                // Để chỉnh màu gạch ngang khi focus
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorClass.fiveColor),
                ),
                label: const Text('Tiêu đề chương'),
                labelStyle: AppTheme.lightTextTheme.headlineLarge,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          quill.QuillToolbar.basic(
            controller: _quillEditorcontroller,
            showCodeBlock: false,
            showSearchButton: false,
            //  showFontSize: false,
            // showFontFamily: false,
            showInlineCode: false,
            showListBullets: false,
            showListCheck: false,
            showDirection: false,
            showBackgroundColorButton: false,
            showSmallButton: false,
            showStrikeThrough: false,
            showSuperscript: false,
            showSubscript: false,
            showLink: false,
            // showIndent: false,
            // showQuote: false,
            //  showListNumbers: false,
          ),
          Expanded(
            child: Container(
              color: ColorClass.fouthColor,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: quill.QuillEditor.basic(
                    controller: _quillEditorcontroller, readOnly: false),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}



/* Text(jsonEncode(
                      _quillEditorcontroller.document.toDelta().toJson())),

                  // hiem thi ra
                  quill.QuillEditor.basic(
                      controller: quill.QuillController(
                        selection: const TextSelection.collapsed(offset: 0),
                        document: quill.Document.fromJson(jsonDecode(
                          jsonEncode(_quillEditorcontroller.document
                              .toDelta()
                              .toJson()), //// thong tin insert vào databas
                        ) // thong tin hien thi ra
                            ),
                      ),
                      readOnly: true),
                  Container(
                    height: 500,
                    child: Column(
                      children: [
                        quill.QuillToolbar.basic(
                          embedButtons: FlutterQuillEmbeds.buttons(),

                          /*  quill.QuillCustomButton(
                                icon: Icons.camera_alt,
                                onTap: () {
                                  pickImage();
                                }), */

                          controller: _quillEditorcontroller,
                          // multiRowsDisplay: false,
                        ),
                        const Align(
                            alignment: Alignment.topLeft, child: Text('Mô tả')),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                            child: Container(
                          color: Color.fromARGB(255, 224, 224, 224),
                          padding: EdgeInsets.all(12),
                          child: quill.QuillEditor.basic(
                              controller: _quillEditorcontroller,
                              embedBuilders: FlutterQuillEmbeds.builders(),
                              readOnly: false),
                        )),*/