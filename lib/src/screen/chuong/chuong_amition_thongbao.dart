/*import 'package:apparch/src/screen/chuong/chuong_noi_dung_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ChuongAmitionThongBao extends StatefulWidget {
  List<QueryDocumentSnapshot> listchuong;
  String idtruyen;
  String iduser;
  String idchuong;
  bool edit;

  ChuongAmitionThongBao({
    super.key,
    required this.listchuong,
    required this.idtruyen,
    required this.idchuong,
    required this.iduser,
    required this.edit,
  });

  @override
  State<ChuongAmitionThongBao> createState() => _TruyenChiTietAmitionState();
}

class _TruyenChiTietAmitionState extends State<ChuongAmitionThongBao> {
  late final PageController _pageController;
  int currentPage = 0;
  @override
  void initState() {
    super.initState();
    // ignore: prefer_interpolation_to_compose_strings
    int vt;
    for (int i = 0; i < widget.listchuong.length; i++) {
      if (widget.listchuong[i].id == widget.idchuong) {
        
      }
      _pageController = PageController(initialPage: widget.vt);
      // Lắng nghe sự thay đổi của trang được chọn

      _pageController.addListener(() {
        setState(() {
          currentPage = _pageController.page!.toInt();
        });
      });
    }
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
}*/
