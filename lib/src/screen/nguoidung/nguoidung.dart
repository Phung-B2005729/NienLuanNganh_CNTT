import 'package:apparch/src/helper/temple/app_theme.dart';
import 'package:apparch/src/helper/temple/color.dart';
import 'package:apparch/src/screen/luutru/danhsachdoc_screen.dart';
import 'package:apparch/src/screen/nguoidung/truyennguoidung.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NguoiDung extends StatelessWidget {
  String iduser;
  String name;
  NguoiDung({super.key, required this.iduser, required this.name});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorClass.xanh3Color,
          shadowColor: ColorClass.xanh1Color,
          title: Align(
            alignment: Alignment.topLeft,
            child: Text(
              // ignore: prefer_interpolation_to_compose_strings
              "Truyện của " + name,
              style: AppTheme.lightTextTheme.titleMedium,
            ),
          ),
          notificationPredicate: (ScrollNotification notification) {
            return notification.depth == 1;
          },
          scrolledUnderElevation: 4.0,
          bottom: TabBar(
              indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide(
                    width: 2,
                  ),
                  insets: EdgeInsets.symmetric(horizontal: 20.0)),
              labelStyle: AppTheme.lightTextTheme.headlineLarge,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black,
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
              tabs: const [
                Text(
                  'Truyện đã đăng',
                ),
                Text('Danh sách đọc')
              ]),
        ),
        body: TabBarView(children: [
          TruyenNguoiDung(iduser: iduser),
          DanhSachDocScreen(iduser: iduser, nguoidung: false)
        ]),
      ),
    );
  }
}
