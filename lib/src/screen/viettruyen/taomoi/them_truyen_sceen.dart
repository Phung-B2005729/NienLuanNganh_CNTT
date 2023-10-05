import 'dart:io';
import 'package:apparch/src/firebase/fire_base_storage.dart';

import 'package:apparch/src/firebase/services/database_user.dart';
import 'package:apparch/src/helper/temple/app_theme.dart';
import 'package:apparch/src/helper/temple/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

//import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

class InsertTruyenScreen extends StatefulWidget {
  const InsertTruyenScreen({super.key});

  @override
  State<InsertTruyenScreen> createState() => _InsertTruyenScreenState();
}

class _InsertTruyenScreenState extends State<InsertTruyenScreen> {
  final _formKey = new GlobalKey<FormState>();
  File? image;
  String imageName = '';
  String imageURL = '';
  // ignore: unused_field
  final _quillEditorcontroller = quill.QuillController.basic();
  final _nameController = TextEditingController();

  final _theloaiController = TextEditingController();

  final _tagController = TextEditingController();

  final FocusNode confirmPasswordFocusNode = FocusNode();
  final FocusNode emailPasswordFocusNode = FocusNode();
  final FocusNode PasswordFocusNode = FocusNode();
  final FocusNode usernameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  Future pickImage() async {
    print('goi ham imgae');
    try {
      final picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          image = File(pickedFile.path);
          imageName = pickedFile.name.toString();
          print(pickedFile.path);
          print(imageName);
          print(image);
        } else {
          print('No image selected.');
        }
      });
    } catch (e) {
      // ignore: avoid_print
      print('loi image  ' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorClass.xanh3Color,
          actions: [
            TextButton(
                onPressed: () async {
                  if (image != null) {
                    try {
                      imageURL = await FireStorage().uploadImage(image!);
                      print("URL " + imageURL);
                      DatabaseUser()
                          .updateUser("tAvEtV3ftRYZYDE1uyO3j9O4Iok2", imageURL);
                    } catch (e) {
                      print('Lỗi upload' + e.toString());
                    }
                  }
                  // kiem tra nhap lieu
                  // chuyen trang tiep theo thêm thông tin chương mới
                },
                child: Text('Tiếp theo',
                    style: AppTheme.lightTextTheme.bodyMedium))
          ],
          title: Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Tạo truyện mới',
              style: AppTheme.lightTextTheme.titleMedium,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 238, 238, 238)),
                    height: 150,
                    child: Row(children: [
                      Container(
                        height: 150,
                        width: 100,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.black)),
                        child: TextButton(
                            onPressed: () {
                              // mo them anh
                              pickImage();
                            },
                            child: (image == null)
                                ? const Icon(
                                    Icons.add,
                                    size: 25,
                                    color: Colors.black,
                                  )
                                : Image.file(
                                    image!,
                                    fit: BoxFit.cover,
                                  )),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      // Text('Thêm ảnh bìa truyện')
                    ]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _nameController,
                    style: AppTheme.lightTextTheme.headlineMedium,
                    decoration: InputDecoration(
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorClass.fiveColor),
                        ),
                        // Để chỉnh màu gạch ngang khi focus
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorClass.fiveColor),
                        ),
                        hintText: 'Tên truyện',
                        hintStyle: AppTheme.lightTextTheme.bodyMedium),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _theloaiController,
                    style: AppTheme.lightTextTheme.headlineMedium,
                    decoration: InputDecoration(
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorClass.fiveColor),
                        ),
                        // Để chỉnh màu gạch ngang khi focus
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorClass.fiveColor),
                        ),
                        hintText: 'Thể loại',
                        hintStyle: AppTheme.lightTextTheme.bodyMedium),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    maxLines: null,
                    controller: _tagController,
                    style: AppTheme.lightTextTheme.headlineMedium,
                    decoration: InputDecoration(
                        labelStyle: AppTheme.lightTextTheme.bodyMedium,
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorClass.fiveColor),
                        ),
                        // Để chỉnh màu gạch ngang khi focus
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorClass.fiveColor),
                        ),
                        hintText: 'Tag',
                        hintStyle: AppTheme.lightTextTheme.bodyMedium),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
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
                        ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
