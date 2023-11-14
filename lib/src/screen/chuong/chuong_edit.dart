import 'dart:convert';
import 'package:apparch/src/firebase/services/database_chuong.dart';
import 'package:apparch/src/firebase/services/database_truyen.dart';
import 'package:apparch/src/helper/date_time_function.dart';
import 'package:apparch/src/helper/temple/app_theme.dart';
import 'package:apparch/src/helper/temple/color.dart';
import 'package:apparch/src/model/chuong_model.dart';
import 'package:apparch/src/screen/chuong/xem_truoc_chuong.dart';
import 'package:apparch/src/screen/share/loadingDialog.dart';
import 'package:apparch/src/screen/share/mgsDiaLog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

// ignore: must_be_immutable
class EditChuong extends StatefulWidget {
  String idtruyen;
  String idchuong;
  String tchuong;
  dynamic nd;
  String tinhtrang;
  bool edit;
  EditChuong(
      {super.key,
      required this.idtruyen,
      required this.idchuong,
      required this.tchuong,
      required this.nd,
      required this.tinhtrang,
      required this.edit});

  @override
  State<EditChuong> createState() => _EditChuongState();
}

class _EditChuongState extends State<EditChuong> {
  final _nameController = TextEditingController();
  final _quillEditorcontroller = quill.QuillController.basic();
  final _formKey = GlobalKey<FormState>();
  String tenchuong = '';
  dynamic noidung;
  String tt = '';
  bool update = false;
  bool saveCreate = false;
  @override
  void initState() {
    super.initState();
    setupData();
  }

  setupData() {
    tt = widget.tinhtrang;
    _nameController.text = widget.tchuong;

    _quillEditorcontroller.document =
        quill.Document.fromJson(jsonDecode(widget.nd));

    print("setup  ==========  ");
    print(_quillEditorcontroller.document);
  }

  Future<dynamic> dropChuong(BuildContext context) async {
    LoadingDialog.showLoadingDialog(context, 'Loading...');
    try {
      // update tinh trang cac chuong
      await DatabaseChuong(idchuong: widget.idchuong)
          .updateTinhTrangChuong(widget.idtruyen, 'Bản thảo');
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

  Future dangChuong(BuildContext context) async {
    LoadingDialog.showLoadingDialog(context, 'Loading...');
    try {
      await DatabaseChuong(idchuong: widget.idchuong)
          .updateTinhTrangChuong(widget.idtruyen, 'Đã đăng');
      await DatabaseTruyen()
          .updateTinhTrangTruyen(widget.idtruyen, "Trưởng thành");
      // ignore: use_build_context_synchronously
      LoadingDialog.hideLoadingDialog(context);
      // ignore: use_build_context_synchronously
      return true;
    } catch (e) {
      // ignore: use_build_context_synchronously
      LoadingDialog.hideLoadingDialog(context);
      // ignore: use_build_context_synchronously
      print('Lỗi ' + e.toString());
      return false;
    }
  }

  Future<bool> updateChuong(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      LoadingDialog.showLoadingDialog(context, 'Loading...');
      // du đủ ht
      if (_quillEditorcontroller.document.isEmpty() == false) {
        // noi dung không trống
        //lây dữ liệu
        try {
          String tenchuong = _nameController.text;
          // lay du lieu noi dung
          String noidung =
              jsonEncode(_quillEditorcontroller.document.toDelta().toJson());
          // goi ham tao lay ra idchuong
          var chuong = <String, dynamic>{
            'idchuong': widget.idchuong,
            'tenchuong': tenchuong,
            'noidung': noidung,
            'ngaycapnhat': DatetimeFunction.getTimeToInt(DateTime.now()),
            'tinhtrang': widget.tinhtrang
          };
          await DatabaseChuong()
              .updateOneChuong(widget.idtruyen, widget.idchuong, chuong);
          LoadingDialog.hideLoadingDialog(context);
          return true;
        } catch (e) {
          print('Lỗi ' + e.toString());
          LoadingDialog.hideLoadingDialog(context);
          return false;
        }
        //update chương
      } else {
        LoadingDialog.hideLoadingDialog(context);
        MsgDialog.showLoadingDialog(
            context, 'Vui lòng nhập vào nội dung chương');
        return false;
      }
    }
    return false;
  }

  Future<dynamic> saveChuong(
    BuildContext context,
  ) async {
    if (_formKey.currentState!.validate()) {
      if (_quillEditorcontroller.document.isEmpty() == false) {
        // lay du lieu tieu de
        LoadingDialog.showLoadingDialog(context, 'Loading...');
        try {
          tenchuong = _nameController.text;
          // lay du lieu noi dung
          noidung =
              jsonEncode(_quillEditorcontroller.document.toDelta().toJson());
          // goi ham tao lay ra idchuong

          widget.tinhtrang = 'Bản thảo';
          ChuongModel chuongModel = ChuongModel(
              tenchuong: tenchuong,
              noidung: noidung,
              ngaycapnhat: DateTime.now(),
              tinhtrang: widget.tinhtrang);
          widget.idchuong =
              await DatabaseChuong().createChuong(chuongModel, widget.idtruyen);
          // ignore: use_build_context_synchronously
          LoadingDialog.hideLoadingDialog(context);
          widget.edit = true;
          return true;
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
        return false;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BuildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          BuildFormTieuDe(),
          const SizedBox(
            height: 5,
          ),
          quill.QuillToolbar.basic(
            controller: _quillEditorcontroller,
            showCodeBlock: false,
            showSearchButton: false,
            showInlineCode: false,
            showListBullets: false,
            showListCheck: false,
            showDirection: false,
            showSmallButton: false,
            showStrikeThrough: false,
            showSuperscript: false,
            showSubscript: false,
            showLink: false,
          ),
          BuildNoiDungChuong(),
        ]),
      ),
    );
  }

  Expanded BuildNoiDungChuong() {
    return Expanded(
      child: Container(
        color: const Color.fromARGB(255, 237, 237, 237),
        child: quill.QuillEditor.basic(
          controller: _quillEditorcontroller,
          readOnly: false,
        ),
      ),
    );
  }

  Form BuildFormTieuDe() {
    return Form(
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
    );
  }

  AppBar BuildAppBar(BuildContext context) {
    return AppBar(
        backgroundColor: ColorClass.xanh3Color,
        title: Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Viết',
            style: AppTheme.lightTextTheme.titleMedium,
          ),
        ),
        actions: [
          BuildPopMenuBotton(context),
        ]);
  }

  PopupMenuButton<String> BuildPopMenuBotton(BuildContext context) {
    return PopupMenuButton(
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
                            noidung: jsonEncode(_quillEditorcontroller.document
                                .toDelta()
                                .toJson()),
                            edit: true)));
              }

              // lay du lieu tieu de
            }
          } else if (value == 'Đăng') {
            print(value);
            bool ktrdang = false;
            // goi ham luu
            if (widget.idchuong == '') {
              saveCreate = await saveChuong(context);
              //goi dang chuong
              ktrdang = await dangChuong(context);
            } else {
              //update
              update = await updateChuong(context);
              // ham dang
              ktrdang = await dangChuong(context);
            }
            if ((saveCreate == true && ktrdang == true) ||
                (update == true && ktrdang == true)) {
              // ignore: use_build_context_synchronously
              MsgDialog.showSnackbar(
                  context, ColorClass.fiveColor, 'Đã đăng một chương mới!!');
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            }
            // ignore: use_build_context_synchronously
          } else if (value == 'Lưu') {
            print(value);

            // goi ham luu
            if (widget.idchuong == '') {
              saveCreate = await saveChuong(context);
            } else {
              update = await updateChuong(context);
              // goi ham update;
            }
            if (saveCreate == true || update == true) {
              // ignore: use_build_context_synchronously
              MsgDialog.showSnackbar(context, ColorClass.fiveColor, 'Đã lưu');
              // ignore: use_build_context_synchronously

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
                if (widget.idchuong != '') {
                  LoadingDialog.showLoadingDialog(context, 'Loading...');
                  //xoa
                  await DatabaseChuong(idchuong: widget.idchuong)
                      .deleteOneChuong(widget.idtruyen);
                  // ignore: use_build_context_synchronously
                  LoadingDialog.hideLoadingDialog(context);
                  // ignore: use_build_context_synchronously
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
          } else if (value == 'Dừng đăng tải') {
            // gọi dropChuong;
            bool ktr = await dropChuong(context);
            if (ktr == true) {
              // ignore: use_build_context_synchronously
              MsgDialog.showSnackbar(
                  context, ColorClass.fiveColor, 'Thành công!!');
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            } else {
              // ignore: use_build_context_synchronously
              MsgDialog.showSnackbar(
                  context, Colors.red, 'Lỗi! Vui lòng thử lại');
            }
          } else if (value == 'Thoát') {
            if (widget.idchuong == '') {
              MsgDialog.showXacNhanThongTin(
                  context,
                  'Lưu ý! Thông tin sẽ không được lưu nếu như bạn thoát',
                  ColorClass.fiveColor, () async {
                Navigator.pop(context);
                Navigator.pop(context);
              });
            } else {
              Navigator.pop(context);
            }
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
              if ((widget.edit == true && widget.tinhtrang == 'Bản thảo') ||
                  widget.edit == false)
                PopupMenuItem<String>(
                  value: 'Đăng',
                  child: Text(
                    'Đăng',
                    style: AppTheme.lightTextTheme.bodySmall,
                  ),
                ),
              if ((widget.edit == true &&
                  widget.tinhtrang == 'Đã đăng' &&
                  widget.idchuong != ''))
                PopupMenuItem<String>(
                  value: 'Dừng đăng tải',
                  child: Text(
                    'Dừng đăng tải',
                    style: AppTheme.lightTextTheme.bodySmall,
                  ),
                ),
              PopupMenuItem<String>(
                value: 'Xoá',
                child: Text('Xoá', style: AppTheme.lightTextTheme.bodySmall),
              ),
              PopupMenuItem<String>(
                value: 'Thoát',
                child: Text('Thoát', style: AppTheme.lightTextTheme.bodySmall),
              ),
            ]);
  }
}
