import 'dart:convert';

import 'package:apparch/src/helper/temple/app_theme.dart';
import 'package:apparch/src/helper/temple/color.dart';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

// ignore: must_be_immutable
class ChuongXemTruoc extends StatefulWidget {
  dynamic noidung;
  String tieude;
  bool edit;
  ChuongXemTruoc(
      {super.key,
      required this.noidung,
      required this.tieude,
      required this.edit});

  @override
  State<ChuongXemTruoc> createState() => _ChuongXemTruocState();
}

class _ChuongXemTruocState extends State<ChuongXemTruoc> {
  var tapbarbool = true;
  var binhchon = false;
  int _currentIndex = 1;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: widget.edit == true
            ? Visibility(
                visible: tapbarbool,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.edit,
                  ),
                ),
              )
            : null,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(
              kToolbarHeight), // Đặt chiều cao của AppBar bằng kToolbarHeight
          child: Visibility(
            visible:
                tapbarbool, // Ẩn hoặc hiển thị AppBar dựa trên giá trị của biến tapbarbool
            child: AppBar(
              backgroundColor: ColorClass.xanh2Color,
              title: Align(
                alignment: Alignment.topLeft,
                child: widget.edit
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.tieude,
                            style: AppTheme.lightTextTheme.displayMedium,
                            softWrap: true,
                          ),
                          Text(
                            '(Bản xem trước)',
                            style: AppTheme.lightTextTheme.bodySmall,
                          )
                        ],
                      )
                    : Text(
                        widget.tieude,
                        style: AppTheme.lightTextTheme.displayMedium,
                        softWrap: true,
                      ),
              ),
            ),
          ),
        ),
        body: InkWell(
          onTap: () {
            setState(() {
              tapbarbool = !tapbarbool;
            });
          },
          onLongPress: () {
            setState(() {
              tapbarbool = false;
            });
          },
          child: Expanded(
            child: Padding(
                padding:
                    EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
                child: quill.QuillEditor.basic(
                  controller: quill.QuillController(
                    document:
                        quill.Document.fromJson(jsonDecode(widget.noidung)),
                    selection: const TextSelection.collapsed(offset: 0),
                  ),
                  readOnly: true,
                )),
          ),
        ),
        bottomNavigationBar: PreferredSize(
            preferredSize: const Size.fromHeight(
                kBottomNavigationBarHeight), // Đặt chiều cao của AppBar bằng kToolbarHeight
            child: Visibility(
                visible:
                    tapbarbool, // Ẩn hoặc hiển thị AppBar dựa trên giá trị của biến tapbarbool
                child: BottomNavigationBar(
                  selectedItemColor: ColorClass.xanh3Color,
                  unselectedItemColor: ColorClass.xanh3Color,

                  unselectedLabelStyle:
                      const TextStyle(color: ColorClass.xanh3Color),
                  selectedLabelStyle:
                      const TextStyle(color: ColorClass.xanh3Color),
                  backgroundColor: const Color.fromARGB(181, 255, 255, 255),
                  //fixedColor: Colors.grey,
                  currentIndex:
                      _currentIndex, // Chỉ định mục được chọn bằng currentIndex
                  onTap: (int index) {
                    setState(() {
                      _currentIndex =
                          index; // Cập nhật currentIndex khi người dùng chọn một mục khác
                    });

                    // Xử lý sự kiện tương ứng với mục được chọn
                    switch (index) {
                      case 0:
                      case 1:
                        break;
                      case 2:
                        // chuyen den binh luan
                        break;
                      case 3:
                        break;
                    }
                  },
                  items: [
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.arrow_back),
                      label: 'Trở lại',
                    ),
                    BottomNavigationBarItem(
                      icon: (binhchon)
                          ? const Icon(
                              Icons.star,
                              color: ColorClass.xanh3Color,
                            )
                          : const Icon(
                              Icons.star_border_outlined,
                              color: ColorClass.xanh3Color,
                            ),
                      label: 'Bình chọn',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.chat_bubble_outline),
                      label: 'Bình luận',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.arrow_forward),
                      label: 'Tiếp theo',
                    ),
                  ],
                ))),
      ),
    );
  }
}
