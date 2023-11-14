import 'package:apparch/src/bloc/bloc_userlogin.dart';
import 'package:apparch/src/firebase/fire_base_auth.dart';
import 'package:apparch/src/screen/nguoidung/danhsachdoclist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CaNhanNguoiDung extends StatefulWidget {
  CaNhanNguoiDung({Key? key}) : super(key: key);

  @override
  State<CaNhanNguoiDung> createState() => _CaNhanNguoiDungState();
}

class _CaNhanNguoiDungState extends State<CaNhanNguoiDung> {
  String userName = "";

  String avata = "";

  FirAuth firAuth = FirAuth();

  @override
  Widget build(BuildContext context) {
    final user = context.read<BlocUserLogin>();
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: BuildSliverAppbar(innerBoxIsScrolled, context),
            ),
          ];
        },
        body: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: ListView(children: [
            ListTile(
              onTap: () {
                // chỉnh sửa hồ sơ
              },
              title: const Padding(
                padding: EdgeInsets.only(top: 20, bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      // ignore: unnecessary_null_comparison
                      backgroundImage: AssetImage(
                        "assets/images/avatarmacdinh.png",
                      ),
                      radius: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Tên người dùng'),
                  ],
                ),
              ),
            ),
            const Divider(
              color: Colors.black,
              height: 5,
            ),
            ListTile(
              title: Text('Truyện của người dùng'),
              subtitle: Text('Truyện đã đăng'),
              onTap: () {
                // chuyển qua lưu trữ
              },
            ),
            //  HomeTruyenList(truyenhoanthanh, false, ColorClass.xanh1Color),
            const Divider(
              color: Colors.black,
              height: 5,
            ),
            DanhSachDocList(
              iduser: user.id,
              nguoidung: true,
            )
          ]),
        ),
      ),
    );
  }

  SliverAppBar BuildSliverAppbar(
      bool innerBoxIsScrolled, BuildContext context) {
    return SliverAppBar(
        forceElevated: innerBoxIsScrolled,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.brightness_7),
          ),
        ],
        snap: false,
        floating: false,
        pinned: true,
        backgroundColor: const Color.fromARGB(255, 207, 216, 222),
        expandedHeight: 250.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
        flexibleSpace: FlexibleSpaceBar(
          background: Image.asset(
            "assets/images/avatarmacdinh.png",
            fit: BoxFit.cover,
          ),
        ));
  }
}
