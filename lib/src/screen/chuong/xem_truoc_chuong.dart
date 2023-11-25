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
        child: Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
            child: quill.QuillEditor.basic(
              controller: quill.QuillController(
                onSelectionChanged: (textSelection) {
                  // không copy được
                  setState(() {
                    tapbarbool = !tapbarbool;
                  });
                },
                document: quill.Document.fromJson(jsonDecode(widget.noidung)),
                selection: const TextSelection.collapsed(offset: 0),
              ),
              readOnly: true,
              focusNode: null,
              autoFocus: false,
            )),
      ),
    ));
  }
}
