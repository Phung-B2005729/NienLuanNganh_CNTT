import 'dart:convert';
import 'dart:io';
import 'package:apparch/src/firebase/fire_base_storage.dart';
import 'package:apparch/src/firebase/services/database_theloai.dart';

import 'package:apparch/src/firebase/services/database_user.dart';
import 'package:apparch/src/helper/temple/app_theme.dart';
import 'package:apparch/src/helper/temple/color.dart';
import 'package:apparch/src/screen/chuong/them_chuong.dart';
import 'package:apparch/src/screen/share/mgsDiaLog.dart';
import 'package:apparch/src/screen/share/tag.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:path/path.dart';

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
//  final _quillEditorcontroller = quill.QuillController.basic();
  final _nameController = TextEditingController();

  final _theloaiController = TextEditingController();

  final _tagController = TextEditingController();
  final _motaController = TextEditingController();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode theloaiFocusNode = FocusNode();
  final FocusNode tagFocusNode = FocusNode();
  final FocusNode motaFocusNode = FocusNode();
  dynamic temControl = '';
  List<String> hashtags = [];
  var charter = null;
  var dropvalue = '';
  Stream<QuerySnapshot>? dsTheLoai;
  @override
  void initState() {
    super.initState();
    getTheLoai();
  }

  getTheLoai() {
    try {
      DatabaseTheLoai().getALLTheLoai().then((va) {
        setState(() {
          print(va);
          dsTheLoai = va;
        });
      });
      print(dsTheLoai == null);
    } catch (e) {
      print('Loi ' + e.toString());
    }
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

  saveTruyen(BuildContext context, String action) {
    if (_formKey.currentState!.validate()) {
      if (image != null) {
        //lay anh
        // luu anh
        /* try {
                      imageURL = await FireStorage().uploadImage(image!); // lay linkanh
                        
                    } catch (e) {
                      print('Lỗi upload' + e.toString());
                    } */

        // kiem tra hanh dong là gì? lưu => tình trạng == bản thảo, hay đăng => trường thành
        // luu truyen
        // hien thi thong bao
        if (action == 'Lưu')
          // ignore: curly_braces_in_flow_control_structures
          MsgDialog.showSnackbar(context, ColorClass.fiveColor, "Đã lưu!");
        if (action == 'Đăng')
          // ignore: curly_braces_in_flow_control_structures
          MsgDialog.showSnackbar(
              context, ColorClass.fiveColor, "Đã đăng một truyện!");
      } else {
        MsgDialog.showLoadingDialog(
            context, "Bạn chưa thêm ảnh bìa của truyện");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorClass.xanh3Color,
          actions: [
            PopupMenuButton(
                onSelected: (value) {
                  if (value == 'Xem trước') {
                    print(value);

                    // goi ham luu => kiem tra du lieu
                    saveTruyen(context, 'Lưu');
                    // lay idtruyen
                    // chuyen trang chi tiet truyen
                  } else if (value == 'Lưu') {
                    print(value);
                    // goi ham luu => kiem tra du lieu
                    saveTruyen(context, 'Lưu');
                    // chuyen về trang viettruyen
                  } else if (value == 'Đăng') {
                    print(value);
                    // goi ham luu => kiem tra du lieu
                    saveTruyen(context, 'Đăng');
                    // chuyen về trang viettruyen
                  } else if (value == 'Thoát') {
                    print(value);
                    Navigator.pop(context);
                  } else if (value == 'Thêm chương') {
                    print(value);
                    // goi ham luu
                    // lay idtruyen
                    // chuyen trang them chuong moi
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                InsertChuong(idtruyen: '1'))); // doi id truyen
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
                        value: 'Lưu',
                        child: Text(
                          'Lưu',
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
                        value: 'Thêm chương',
                        child: Text(
                          'Thêm chương',
                          style: AppTheme.lightTextTheme.bodySmall,
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'Thoát',
                        child: Text('Thoát',
                            style: AppTheme.lightTextTheme.bodySmall),
                      ),
                    ]),
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
              child: Column(mainAxisSize: MainAxisSize.min, children: [
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
                    const Text('Thêm ảnh bìa truyện')
                  ]),
                ),
                const SizedBox(
                  height: 50,
                ),
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
                    label: const Text('Tên truyện'),
                    labelStyle: AppTheme.lightTextTheme.headlineLarge,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                TextFormField(
                  focusNode: motaFocusNode,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mô tả';
                    }
                    return null;
                  },
                  style: AppTheme.lightTextTheme.bodyMedium,
                  maxLines: null,
                  controller: _motaController,
                  decoration: InputDecoration(
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorClass.fiveColor),
                    ),
                    // Để chỉnh màu gạch ngang khi focus
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorClass.fiveColor),
                    ),

                    label: const Text('Mô tả'),
                    labelStyle: AppTheme.lightTextTheme.headlineLarge,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                TextFormField(
                  focusNode: theloaiFocusNode,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng chọn thể loại truyện';
                    }
                    return null;
                  },
                  onTap: () {
                    ShowSimpleDialog(context);
                  },
                  controller: _theloaiController,
                  style: AppTheme.lightTextTheme.bodyMedium,
                  decoration: InputDecoration(
                    // ignore: prefer_const_constructors
                    enabledBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: ColorClass.fiveColor),
                    ),
                    // Để chỉnh màu gạch ngang khi focus
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorClass.fiveColor),
                    ),

                    label: const Text('Thể loại'),
                    labelStyle: AppTheme.lightTextTheme.headlineLarge,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                TextFormField(
                  style: AppTheme.lightTextTheme.bodyMedium,
                  onChanged: (v) {
                    dynamic tem;
                    if (!_tagController.text.startsWith(' ') &&
                        !_tagController.text.startsWith('#') &&
                        _tagController.text.isNotEmpty) {
                      // Nếu không có khoảng trắng ở đầu, thêm nó vào
                      _tagController.text = '#' + _tagController.text;
                    }

                    if (_tagController.text.isNotEmpty) {
                      for (var i = 1; i < _tagController.text.length; i++) {
                        if (_tagController.text[i - 1] == ' ' &&
                            _tagController.text[i] != '#' &&
                            _tagController.text[i] != '') {
                          // ignore: prefer_interpolation_to_compose_strings
                          tem = _tagController.text.substring(0, i) +
                              '#' +
                              _tagController.text.substring(i);
                        }
                      }
                      if (tem != null) {
                        _tagController.text = tem;
                      }
                      setState(() {
                        String tem1;

                        tem1 = _tagController.text.replaceAll(" #", " ");
                        if (tem1[0] == '#')
                          // ignore: curly_braces_in_flow_control_structures
                          tem1 = tem1.substring(1, tem1.length);
                        tem1 = tem1.trim(); // xoa khoang trang dau cuoi
                        hashtags = tem1.split(" ");
                      });

                      // Update the UI
                    } else {
                      setState(() {
                        hashtags = [];
                      });
                    }
                  },
                  controller: _tagController,
                  decoration: InputDecoration(
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorClass.fiveColor),
                    ),
                    // Để chỉnh màu gạch ngang khi focus
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorClass.fiveColor),
                    ),
                    label: const Text('Tag'),
                    labelStyle: AppTheme.lightTextTheme.headlineLarge,
                  ),
                ),
                const SizedBox(height: 10),
                if (hashtags.isNotEmpty && hashtags.length > 0)
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    height: hashtags.isNotEmpty ? 50 : 20,
                    child: TagTruyen(tag: hashtags),
                  ),
                const SizedBox(
                  height: 40,
                ),
              ]),
            ),
          ),
        ));
  }

  ShowSimpleDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return StreamBuilder<QuerySnapshot>(
              stream: dsTheLoai,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return SimpleDialog(
                      title: Text(
                        'Danh sách thể loại',
                        style: AppTheme.lightTextTheme.headlineLarge,
                      ),
                      children: <Widget>[
                        for (var i = 0; i < snapshot.data.docs.length; i++)
                          SimpleDialogOption(
                            onPressed: () {
                              //
                              /*   _theloaiController.text =
                                  snapshot.data?.docs[i]['tenloai'];
                              Navigator.pop(context); */
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(snapshot.data?.docs[i]['tenloai'],
                                    style: AppTheme.lightTextTheme.bodyMedium),
                                Radio(
                                  value: snapshot.data.docs[i]['idloai'],
                                  groupValue: charter,
                                  onChanged: (value) {
                                    setState(() async {
                                      charter = await value;
                                      _theloaiController.text =
                                          snapshot.data?.docs[i]['tenloai'];
                                      // ignore: use_build_context_synchronously
                                      Navigator.pop(context);
                                    });
                                  },
                                ),
                              ],
                            ),
                          )
                      ]);
                } else if (snapshot.hasError) {
                  return AlertDialog(
                    title: const Text('Lỗi'),
                    content: Text('Đã xảy ra lỗi: ${snapshot.error}'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Đóng'),
                      ),
                    ],
                  );
                } else {
                  return Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                        const CircularProgressIndicator(
                          color: Colors.black,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Loading...',
                            style: AppTheme.lightTextTheme.bodyMedium,
                          ),
                        )
                      ]));
                }
              });
        });
  }
}
