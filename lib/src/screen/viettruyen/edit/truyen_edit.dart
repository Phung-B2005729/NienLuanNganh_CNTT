import 'dart:io';
import 'package:apparch/src/bloc/bloc_thongbao.dart';
import 'package:apparch/src/bloc/bloc_userlogin.dart';
import 'package:apparch/src/firebase/fire_base_storage.dart';
import 'package:apparch/src/firebase/services/database_chuong.dart';
import 'package:apparch/src/firebase/services/database_theloai.dart';
import 'package:apparch/src/firebase/services/database_truyen.dart';
import 'package:apparch/src/helper/date_time_function.dart';
import 'package:apparch/src/helper/temple/app_theme.dart';
import 'package:apparch/src/helper/temple/color.dart';

import 'package:apparch/src/screen/chuong/chuong_edit.dart';
import 'package:apparch/src/screen/chuong/chuong_them.dart';
import 'package:apparch/src/screen/share/loadingDialog.dart';
import 'package:apparch/src/screen/share/mgsDiaLog.dart';
import 'package:apparch/src/screen/share/tag.dart';
import 'package:apparch/src/screen/viettruyen/taomoi/textFormField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

//import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

// ignore: must_be_immutable
class EditTruyenScreen extends StatefulWidget {
  String idtruyen;
  String theloai;
  bool ktrbanthao;
  String mota;
  String tentruyen;
  List<dynamic>? tag;
  String linkanh;
  String tinhtrang;
  EditTruyenScreen(
      {super.key,
      required this.tinhtrang,
      required this.linkanh,
      required this.tag,
      required this.tentruyen,
      required this.idtruyen,
      required this.theloai,
      required this.mota,
      required this.ktrbanthao});

  @override
  State<EditTruyenScreen> createState() => _EditTruyenScreenState();
}

class _EditTruyenScreenState extends State<EditTruyenScreen> {
  final _formKey = new GlobalKey<FormState>();
  File? image;
  String imageName = '';
  String imageURL = '';
  bool update = false;
  // ignore: unused_field
//  final _quillEditorcontroller = quill.QuillController.basic();
  final _nameController = TextEditingController();
  final _tinhtrangController = TextEditingController();

  final _theloaiController = TextEditingController();

  final _tagController = TextEditingController();
  final _motaController = TextEditingController();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode tinhtrangFocusNode = FocusNode();
  final FocusNode theloaiFocusNode = FocusNode();
  final FocusNode tagFocusNode = FocusNode();
  final FocusNode motaFocusNode = FocusNode();
  String idtruyen = '';
  dynamic temControl = '';
  String dropdownValue = '';
  List<dynamic> hashtags = [];
  var charter = null;
  var chartinhtrang = null;
  var dropvalue = '';
  Stream<QuerySnapshot>? allChuongStream;
  Stream<QuerySnapshot>? dsTheLoai;
  @override
  void initState() {
    super.initState();
    getTheLoai();
    setUpData();
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

  setUpData() async {
    try {
      chartinhtrang = widget.tinhtrang;
      idtruyen = widget.idtruyen;
      _motaController.text = widget.mota;
      _tinhtrangController.text = widget.tinhtrang;
      print("tinh trang +++++++          " + _tinhtrangController.text);
      _nameController.text = widget.tentruyen;
      hashtags = widget.tag ?? [];
      if (hashtags.isNotEmpty) {
        for (var i = 0; i < hashtags.length; i++) {
          // ignore: prefer_interpolation_to_compose_strings
          _tagController.text = _tagController.text + " #" + hashtags[i];
        }
        _tagController.text =
            _tagController.text.substring(1, _tagController.text.length);
      }
      await DatabaseTheLoai().getNameTheLoai(widget.theloai).then((value) {
        _theloaiController.text = value;
      });

      await DatabaseChuong()
          .getALLChuongSnapshots(widget.idtruyen, false, false)
          .then((vale) {
        setState(() {
          allChuongStream = vale;
        });
      });
    } catch (e) {
      // ignore: avoid_print
      print('Loi set up' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorClass.xanh3Color,
          actions: [
            IconButton(
                onPressed: () async {
                  await saveTruyen(context);
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => InsertChuong(idtruyen: idtruyen)));
                },
                icon: const Icon(Icons.add)),
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
                      widget.tinhtrang == 'Bản thảo'
                          ? PopupMenuItem<String>(
                              value: 'Đăng',
                              child: Text(
                                'Đăng',
                                style: AppTheme.lightTextTheme.bodySmall,
                              ),
                            )
                          : PopupMenuItem<String>(
                              value: 'Dừng đăng tải',
                              child: Text(
                                'Dừng đăng tải',
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
                    ]),
          ],
          title: Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Thông tin truyện',
              style: AppTheme.lightTextTheme.titleMedium,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Column(mainAxisSize: MainAxisSize.max, children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 238, 238, 238)),
                        height: 150,
                        child: Row(children: [
                          Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.black)),
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Container(
                                height: 150,
                                width: 100,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.black)),
                                child: TextButton(
                                    onPressed: () {
                                      // mo them anh
                                      pickImage();
                                    },
                                    child: (image == null)
                                        ? Image.network(widget.linkanh)
                                        : Image.file(
                                            image!,
                                            fit: BoxFit.fill,
                                          )),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text('Cập nhật bìa truyện')
                        ]),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      textFormField(
                          nameFocusNode: nameFocusNode,
                          nameController: _nameController,
                          label: 'Tên truyện',
                          style: AppTheme.lightTextTheme.headlineLarge,
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
                            borderSide:
                                const BorderSide(color: ColorClass.fiveColor),
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
                        maxLines: null,
                        onChanged: (v) {
                          dynamic tem;
                          if (!_tagController.text.startsWith(' ') &&
                              !_tagController.text.startsWith('#') &&
                              _tagController.text.isNotEmpty) {
                            // Nếu không có khoảng trắng ở đầu, thêm nó vào
                            _tagController.text = '#' + _tagController.text;
                          }

                          if (_tagController.text.isNotEmpty) {
                            for (var i = 1;
                                i < _tagController.text.length;
                                i++) {
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
                        height: 10,
                      ),
                      if (widget.ktrbanthao == false)
                        TextFormField(
                          focusNode: tinhtrangFocusNode,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng chọn thể loại truyện';
                            }
                            return null;
                          },
                          onTap: () {
                            ShowSimpleDialogTinhTrang(context);
                          },
                          controller: _tinhtrangController,
                          style: AppTheme.lightTextTheme.bodyMedium,
                          decoration: InputDecoration(
                            // ignore: prefer_const_constructors
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  const BorderSide(color: ColorClass.fiveColor),
                            ),
                            // Để chỉnh màu gạch ngang khi focus
                            focusedBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorClass.fiveColor),
                            ),

                            label: const Text('Tình trạng'),
                            labelStyle: AppTheme.lightTextTheme.headlineLarge,
                          ),
                        ),
                      if (widget.ktrbanthao == false)
                        const SizedBox(
                          height: 2,
                        ),
                    ],
                  ),
                ),
              ),
              // form
              const Divider(
                color: ColorClass.fiveColor, // Màu sắc của đường kẻ
                thickness: 2.0, // Độ dày của đường kẻ
              ),
              const Divider(
                color: ColorClass.fiveColor, // Màu sắc của đường kẻ
                thickness: 2.0, // Độ dày của đường kẻ
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: allChuongStream,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      // for(var i=0; i<snapshot.data.length; i++)
                      // ignore: curly_braces_in_flow_control_structures
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child:
                            Column(mainAxisSize: MainAxisSize.max, children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              'Danh sách chương',
                              style: AppTheme.lightTextTheme.headlineLarge,
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          for (var i = 0; i < snapshot.data.docs.length; i++)
                            Dismissible(
                              // loai bo bang cach luot
                              key: ValueKey(snapshot.data.docs[i]
                                  ['idchuong']), // dinh danh widget
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
                                  "Bạn chắc chăn muốn xoá chương này ?",
                                );
                              },
                              onDismissed: (direction) async {
                                try {
                                  await context
                                      .read<BlocThongBao>()
                                      .deleteAllThongBaoIdChuong(
                                          snapshot.data.docs[i]['idchuong']);
                                  await DatabaseChuong(
                                          idchuong: snapshot.data.docs[i]
                                              ['idchuong'])
                                      .deleteOneChuong(widget.idtruyen);
                                  // ignore: avoid_print
                                  print('Đã xoá');
                                } catch (e) {
                                  // ignore: use_build_context_synchronously
                                  MsgDialog.showSnackbar(context, Colors.red,
                                      "Lỗi vui lòng thử lại!!");
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 3),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.black)),
                                  child: ListTile(
                                    // ignore: prefer_interpolation_to_compose_strings
                                    title: Text(
                                      // ignore: prefer_interpolation_to_compose_strings
                                      '${i}. ' +
                                          snapshot.data.docs[i]['tenchuong'],
                                      style: AppTheme.lightTextTheme.bodyMedium,
                                    ),

                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, top: 2, bottom: 2),
                                      child: Row(
                                        children: [
                                          Text(
                                              snapshot.data.docs[i]
                                                  ['tinhtrang'],
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.grey)),
                                          const SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            DatetimeFunction
                                                .getTimeFormatDatabase(snapshot
                                                    .data
                                                    .docs[i]['ngaycapnhat']),
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w300,
                                                color: Colors.grey),
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          const Icon(
                                            Icons.visibility,
                                            size: 12,
                                            color: Colors.grey,
                                          ),
                                          Text(
                                              snapshot.data.docs[i]['luotxem']
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.grey)),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          const Icon(
                                            Icons.star,
                                            size: 12,
                                            color: Colors.grey,
                                          ),
                                          Text(
                                              snapshot.data.docs[i]['binhchon']
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.grey))
                                        ],
                                      ),
                                    ),
                                    onTap: () async {
                                      // chinh sua chuong
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => EditChuong(
                                                  idtruyen: widget.idtruyen,
                                                  idchuong: snapshot
                                                      .data.docs[i]['idchuong'],
                                                  tchuong: snapshot.data.docs[i]
                                                      ['tenchuong'],
                                                  nd: snapshot.data.docs[i]
                                                      ['noidung'],
                                                  tinhtrang: snapshot.data
                                                      .docs[i]['tinhtrang'],
                                                  edit: true)));
                                    },
                                  ),
                                ),
                              ),
                            ),
                          InkWell(
                            onTap: () async {
                              await saveTruyen(context);
                              // them chuong
                              // ignore: use_build_context_synchronously
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          InsertChuong(idtruyen: idtruyen)));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 10, right: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.black)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1, color: Colors.black)),
                                    child: ListTile(
                                      title: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.add,
                                              color: Colors.black,
                                              size: 25,
                                            ),
                                            Text(
                                              'Thêm chương mới',
                                              style: AppTheme
                                                  .lightTextTheme.bodyMedium,
                                            )
                                          ]),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ]),
                      );
                    } else {
                      return InkWell(
                        onTap: () {
                          // them chuong
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      InsertChuong(idtruyen: idtruyen)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.black)),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.black)),
                                child: ListTile(
                                  title: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.add,
                                          color: Colors.black,
                                          size: 25,
                                        ),
                                        Text(
                                          'Thêm chương mới',
                                          style: AppTheme
                                              .lightTextTheme.bodyMedium,
                                        )
                                      ]),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  })
            ]),
          ),
        ));
  }

  // ignore: non_constant_identifier_names
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

  // ignore: non_constant_identifier_names
  ShowSimpleDialogTinhTrang(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
              title: Text(
                'Danh sách tình trạng',
                style: AppTheme.lightTextTheme.headlineLarge,
              ),
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () {},
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Trưởng thành',
                            style: AppTheme.lightTextTheme.bodyMedium),
                        Radio(
                          value: 'Trưởng thành',
                          groupValue: chartinhtrang,
                          onChanged: (value) {
                            setState(() {
                              chartinhtrang = value;
                              _tinhtrangController.text = 'Trưởng thành';
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            });
                          },
                        ),
                      ]),
                ),
                SimpleDialogOption(
                    onPressed: () {},
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Hoàn thành',
                              style: AppTheme.lightTextTheme.bodyMedium),
                          Radio(
                            value: 'Hoàn thành',
                            groupValue: chartinhtrang,
                            onChanged: (value) {
                              setState(() {
                                chartinhtrang = value;
                                _tinhtrangController.text = 'Hoàn thành';
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                              });
                            },
                          ),
                        ])),
              ]);
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

  Future<dynamic> dropTruyen(BuildContext context) async {
    try {
      LoadingDialog.showLoadingDialog(context, 'Loading...');
      // update tinh trang cac chuong
      await DatabaseChuong()
          .updateAllTinhTrangChuong(widget.idtruyen, 'Bản thảo');

      // updat tinh trang truyen
      await DatabaseTruyen().updateTinhTrangTruyen(widget.idtruyen, 'Bản thảo');
      // ignore: use_build_context_synchronously
      await context.read<BlocThongBao>().deleteAllThongBaoIdTruyen(idtruyen);
      return true;
    } catch (e) {
      LoadingDialog.hideLoadingDialog(context);
      // MsgDialog.showSnackbar(context, Colors.red, 'Lỗi vui lòng thử lại');
      return false;
    }
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
      // ignore: use_build_context_synchronously
      LoadingDialog.hideLoadingDialog(context);
      // ignore: use_build_context_synchronously
      print('Lỗi ' + e.toString());
      return false;
    }
  }

  Future<void> saveTruyen(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        LoadingDialog.showLoadingDialog(context, 'Loading....');
        // ignore: unused_local_variable
        final blocUserLogin =
            Provider.of<BlocUserLogin>(context, listen: false);
        if (image != null) {
          // lay anh
          imageURL = await FireStorage().uploadImage(image!);
        } else {
          imageURL = widget.linkanh;
        }
        // lay du lieu
        String name = _nameController.text;
        String mota = _motaController.text;
        String theloai = '';
        String tinhtrang = _tinhtrangController.text;
        // lay id the loai;
        await DatabaseTheLoai()
            .getIdTheLoai(_theloaiController.text)
            .then((value) => theloai = value);
        // tinh trang
        var truyen = <String, dynamic>{
          'tentruyen': name,
          'mota': mota,
          'linkanh': imageURL,
          'theloai': theloai,
          'tinhtrang': tinhtrang,
          'ngaycapnhat': DatetimeFunction.getTimeToInt(DateTime.now()),
          'tags': hashtags
        };
        await DatabaseTruyen().updateOneTruyen(idtruyen, truyen);
        // ignore: use_build_context_synchronously
        LoadingDialog.hideLoadingDialog(context);

        update = true;
      } catch (e) {
        // ignore: use_build_context_synchronously
        LoadingDialog.hideLoadingDialog(context);
        // ignore: avoid_print, prefer_interpolation_to_compose_strings
        print("Lỗi save " + e.toString());
        update = false;
      }
    }
  }

  checkValue(BuildContext context, String value) async {
    if (value == 'Dừng đăng tải') {
      // ignore: use_build_context_synchronously
      bool ktr = await dropTruyen(context);
      if (ktr == true) {
        // ignore: use_build_context_synchronously
        MsgDialog.showSnackbar(context, ColorClass.fiveColor, 'Thành công!!');
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        // ignore: use_build_context_synchronously
        MsgDialog.showSnackbar(context, Colors.red, 'Lỗi! Vui lòng thử lại');
      }
    } else if (value == 'Lưu') {
      //updtae
      await saveTruyen(context);
      if (update == true) {
        // ignore: use_build_context_synchronously
        MsgDialog.showSnackbar(context, ColorClass.fiveColor, 'Đã lưu!!');
      } else {
        // ignore: use_build_context_synchronously
        MsgDialog.showSnackbar(context, Colors.red, 'Lỗi! Vui lòng thử lại');
      }
    } else if (value == 'Đăng') {
      //upate
      await saveTruyen(context);
      bool ktr = await dangTruyen(context, widget.idtruyen);
      if (ktr == true && update == true) {
        // ignore: use_build_context_synchronously
        MsgDialog.showSnackbar(
            context, ColorClass.fiveColor, 'Đăng truyện thành công!!');
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        // ignore: use_build_context_synchronously
        MsgDialog.showSnackbar(context, Colors.red, 'Lỗi! Vui lòng thử lại');
      }
    }
  }
}
