import 'package:apparch/src/screen/chuong/chuong_noi_dung_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ChuongAmition extends StatefulWidget {
  List<QueryDocumentSnapshot> listchuong;
  late int vt;
  String idtruyen;
  String iduser;
  bool edit;

  ChuongAmition({
    super.key,
    required this.listchuong,
    required this.vt,
    required this.idtruyen,
    required this.iduser,
    required this.edit,
  });

  @override
  State<ChuongAmition> createState() => _TruyenChiTietAmitionState();
}

class _TruyenChiTietAmitionState extends State<ChuongAmition> {
  late final PageController _pageController;
  int currentPage = 0;
  @override
  void initState() {
    super.initState();
    // ignore: prefer_interpolation_to_compose_strings
    print('vitri ' + widget.vt.toString());
    _pageController = PageController(initialPage: widget.vt);
    // Lắng nghe sự thay đổi của trang được chọn

    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page!.toInt();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.horizontal,
      itemCount: widget.listchuong.length,
      itemBuilder: (BuildContext context, int index) {
        return ChuongNoiDungScreen(
          idtruyen: widget.idtruyen,
          iduser: widget.iduser,
          vtChuong: index,
          edit: widget.edit,
        );
      },
    );
  }
}
