import 'package:apparch/src/screen/truyen/truyen_chi_tiet_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TruyenChiTietAmition extends StatefulWidget {
  List<QueryDocumentSnapshot> lisTruyen;
  late int vttruyen;
  bool edit;
  TruyenChiTietAmition(
      {super.key,
      required this.lisTruyen,
      required this.vttruyen,
      required this.edit});

  @override
  State<TruyenChiTietAmition> createState() => _TruyenChiTietAmitionState();
}

class _TruyenChiTietAmitionState extends State<TruyenChiTietAmition> {
  late final PageController _pageController;
  int currentPage = 0;
  late List<QueryDocumentSnapshot> lisTruyennotbanthao = [];
  @override
  void initState() {
    super.initState();

    if (widget.edit == false) getData();
    _pageController = PageController(initialPage: widget.vttruyen);
    // Lắng nghe sự thay đổi của trang được chọn

    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page!.toInt();
      });
    });
  }

  getData() {
    for (var i = 0; i < widget.lisTruyen.length; i++) {
      if (widget.lisTruyen[i]['tinhtrang'] != 'Bản thảo') {
        lisTruyennotbanthao.add(widget.lisTruyen[i]);
      }
    }
    int tam = widget.vttruyen;
    for (var i = 0; i < lisTruyennotbanthao.length; i++) {
      if (widget.lisTruyen[tam]['idtruyen'] ==
          lisTruyennotbanthao[i]['idtruyen']) {
        setState(() {
          widget.vttruyen = i;
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: (widget.edit == false)
          ? lisTruyennotbanthao.length
          : widget.lisTruyen.length,
      itemBuilder: (BuildContext context, int index) {
        return TruyenChiTietScreen(
          idtruyen: (widget.edit == false)
              ? lisTruyennotbanthao[index]['idtruyen']
              : widget.lisTruyen[index]['idtruyen'],
          edit: widget.edit,
        );
      },
    );
  }
}
