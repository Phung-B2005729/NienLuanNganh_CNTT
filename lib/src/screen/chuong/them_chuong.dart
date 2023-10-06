import 'package:apparch/src/helper/temple/app_theme.dart';
import 'package:apparch/src/helper/temple/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

class InsertChuong extends StatefulWidget {
  String idtruyen;
  InsertChuong({super.key, required this.idtruyen});

  @override
  State<InsertChuong> createState() => _InsertChuongState();
}

class _InsertChuongState extends State<InsertChuong> {
  final _nameController = TextEditingController();
  final FocusNode nameFocusNode = FocusNode();
  final _quillEditorcontroller = quill.QuillController.basic();
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
                onSelected: (value) {
                  if (value == 'Xem trước') {
                    print(value);
                    // goi ham luu
                    // lay idtruyen
                    // lay vtchuong
                    // hien thi  noi dung tai vtchuong nay
                  } else if (value == 'Đăng') {
                    print(value);
                    // goi ham luu
                    // chuyen về trang viettruyen
                  } else if (value == 'Xoá') {
                    print(value);
                    //kiem tu trang them moi hay trang chinh sua
                    // hoi xac nhan xoa
                    // lay idtruyen
                    // xoa truyen
                    // xoa chuong
                    // chuyen ve trang viettruyen
                  }
                },
                color: const Color.fromARGB(255, 237, 236, 236),
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.black,
                ),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'Đăng',
                        child: Text(
                          'Đăng',
                          style: AppTheme.lightTextTheme.bodySmall,
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'Xem trước',
                        child: Text(
                          'Xem trước',
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
        padding: EdgeInsets.only(left: 15, right: 15, top: 20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextFormField(
            focusNode: nameFocusNode,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập tên truyện';
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
          const SizedBox(
            height: 10,
          ),
          quill.QuillToolbar.basic(
            embedButtons: FlutterQuillEmbeds.buttons(),
            controller: _quillEditorcontroller,
            multiRowsDisplay: false,
          ),
          const SizedBox(
            height: 10,
          ),
          Flexible(
            child: quill.QuillEditor.basic(
                controller: _quillEditorcontroller,
                embedBuilders: FlutterQuillEmbeds.builders(),
                readOnly: false),
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