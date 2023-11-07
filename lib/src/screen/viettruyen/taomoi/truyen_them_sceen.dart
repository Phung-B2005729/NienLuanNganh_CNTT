import 'dart:io';
import 'package:apparch/src/bloc/bloc_userlogin.dart';
import 'package:apparch/src/firebase/fire_base_storage.dart';
import 'package:apparch/src/firebase/services/database_theloai.dart';
import 'package:apparch/src/firebase/services/database_truyen.dart';
import 'package:apparch/src/helper/temple/app_theme.dart';
import 'package:apparch/src/helper/temple/color.dart';
import 'package:apparch/src/model/truyen_model.dart';
import 'package:apparch/src/screen/chuong/chuong_them.dart';
import 'package:apparch/src/screen/share/loadingDialog.dart';
import 'package:apparch/src/screen/share/mgsDiaLog.dart';
import 'package:apparch/src/screen/share/tag.dart';
import 'package:apparch/src/screen/truyen/truyen_chi_tiet_screen.dart';
import 'package:apparch/src/screen/viettruyen/taomoi/textFormField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

//import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

class InsertTruyenScreen extends StatefulWidget {
  InsertTruyenScreen({super.key});

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
  String idtruyen = '';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorClass.xanh3Color,
          actions: [
            PopupMenuButton(
                onSelected: (value) {
                  checkValue(context, value);
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
                      PopupMenuItem<
                      String>(
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
                textFormField(
                    nameFocusNode: nameFocusNode,
                    nameController: _nameController,
                    label: 'Tên truyện',
                    style: AppTheme.lightTextTheme.headlineMedium,
                    labelstyle: AppTheme.lightTextTheme.headlineLarge),
                const SizedBox(
                  height: 40,
                ),
                textFormField(
                    nameFocusNode: motaFocusNode,
                    nameController: _motaController,
                    label: 'Mô tả',
                    style: AppTheme.lightTextTheme.bodyMedium,
                    labelstyle: AppTheme.lightTextTheme.headlineLarge),
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

  Future<dynamic> saveTruyen(BuildContext context, String action) async {
    if (_formKey.currentState!.validate()) {
      if (image != null) {
        print('gọi hàm save');
        try {
          LoadingDialog.showLoadingDialog(context, 'Loading....');
          // ignore: unused_local_variable
          final blocUserLogin =
              Provider.of<BlocUserLogin>(context, listen: false);
          // luu anh
          // lay linkanh
          imageURL = await FireStorage().uploadImage(image!);
          // lay du lieu;
          String name = _nameController.text;
          String mota = _motaController.text;
          String theloai = '';
          // lay id the loai;
          await DatabaseTheLoai()
              .getIdTheLoai(_theloaiController.text)
              .then((value) => theloai = value);

          // kiem tra hanh dong là gì? lưu => tình trạng == bản thảo, hay đăng => trường thành
          TruyenModel truyen = TruyenModel(
              tacgia: blocUserLogin.id,
              tentruyen: name,
              mota: mota,
              linkanh: imageURL,
              theloai: theloai,
              tinhtrang: 'Trưởng thành',
              ngaycapnhat: DateTime.now(),
              danhsachdocgia: [],
              tags: hashtags);

          String id = '';
          if (action == 'Lưu') {
            // ignore: unused_local_variable
            TruyenModel truyenUpdate =
                await truyen.copyWith(tinhtrang: 'Bản thảo');
            // ignore: unused_local_variable
            id = await DatabaseTruyen().createTruyen(truyenUpdate);
            // ignore: curly_braces_in_flow_control_structures, use_build_context_synchronously
            print("id " + id);
            if (id != '') {
              LoadingDialog.hideLoadingDialog(context);
              MsgDialog.showSnackbar(context, ColorClass.fiveColor, "Đã lưu!");
              return id;
            } else {
              LoadingDialog.hideLoadingDialog(context);
              MsgDialog.showLoadingDialog(context, "Lỗi vui lòng thử lại!");
              return '';
            }
          }

          if (action == 'Đăng') {
            // ignore: unused_local_variable
            id = await DatabaseTruyen().createTruyen(truyen);
            // ignore: curly_braces_in_flow_control_structures, use_build_context_synchronously
            if (id != '') {
              LoadingDialog.hideLoadingDialog(context);
              MsgDialog.showSnackbar(
                  context, ColorClass.fiveColor, "Đã đăng một truyện!");
              return id;
            } else {
              LoadingDialog.hideLoadingDialog(context);
              MsgDialog.showLoadingDialog(context, "Lỗi vui lòng thử lại!");
              return '';
            }
          }
        } catch (e) {
          print('Lỗi ' + e.toString());
        }
      } else {
        LoadingDialog.hideLoadingDialog(context);
        MsgDialog.showLoadingDialog(
            context, "Bạn chưa thêm ảnh bìa của truyện");
        return '';
      }
    }
  }

  checkValue(BuildContext context, String value) async {
    if (value == 'Xem trước') {
      print(value);
      if (idtruyen == '')
      // goi ham luu => kiem tra du lieu => // lay idtruyen
      {
        idtruyen = await saveTruyen(context, 'Lưu');
      }
      if (idtruyen != '') {
        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    TruyenChiTietScreen(idtruyen: idtruyen, edit: true)));
      }
    } else if (value == 'Lưu') {
      print(value);
      // goi ham luu => kiem tra du lieu
      if (idtruyen == '')
      // goi ham luu => kiem tra du lieu => // lay idtruyen
      {
        idtruyen = await saveTruyen(context, 'Lưu');
      } else {
        MsgDialog.showSnackbar(context, ColorClass.fiveColor, "Đã lưu!");
      }
      // ignore: prefer_interpolation_to_compose_strings
      print('idtruyen thu duoc ' + idtruyen);
      // chuyen về trang viettruyen
      if (idtruyen != '') {
        // ignore: use_build_context_synchronously

        Navigator.pop(context);
      }
    } else if (value == 'Đăng') {
      print(value);
      // goi ham luu => kiem tra du lieu
      if (idtruyen == '')
      // goi ham luu => kiem tra du lieu => // lay idtruyen
      {
        idtruyen = await saveTruyen(context, 'Đăng');
      } else {
        MsgDialog.showSnackbar(
            context, ColorClass.fiveColor, "Đã đăng một truyện!");
      }
      print('idtruyen thu duoc ' + idtruyen);
      if (idtruyen != '') {
        Navigator.pop(context);
      }
      // chuyen về trang viettruyen
      // ignore: use_build_context_synchronously
    } else if (value == 'Thoát') {
      if (idtruyen == '')
      // chua luu
      {
        MsgDialog.showXacNhanThongTin(
            context,
            'Lưu ý sau khi thoát nội dung của truyện sẽ không được lưu!',
            ColorClass.fiveColor, () async {
          // xoa truyne
          if (idtruyen != '') {
            // xoa truyen
            await DatabaseTruyen().deleleOneTruyen(idtruyen);
          }
          Navigator.pop(context);
          Navigator.pop(context);
        });

        print(value);
      } else {
        // da luu
        Navigator.pop(context);
      }
    } else if (value == 'Thêm chương') {
      print(value);
      // goi ham luu //    // lay idtruyen
      if (idtruyen == '')
      // goi ham luu => kiem tra du lieu => // lay idtruyen
      {
        idtruyen = await saveTruyen(context, 'Lưu');
      }
      if (idtruyen != '') {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => InsertChuong(
                      idtruyen: idtruyen,
                    )));
      }
    }
  }
}
