// ignore: camel_case_types
import 'package:apparch/src/Screen/nguoidung/ca_nhan.dart';
import 'package:apparch/src/firebase/fire_base_auth.dart';
import 'package:apparch/src/firebase/services/database_truyen.dart';
import 'package:apparch/src/helper/temple/app_theme.dart';
import 'package:apparch/src/screen/home/home_useraccountdrawer.dart';
import 'package:apparch/src/screen/home/home_truyen_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../bloc/bloc_userlogin.dart';
import '../../helper/temple/Color.dart';
import '../log_sign/login_form.dart';
import 'home_appbaraction.dart';

class HomePages extends StatefulWidget {
  const HomePages({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<HomePages> createState() => _HomePagesState();
}

// ignore: camel_case_types
class _HomePagesState extends State<HomePages> {
  FirAuth firAuth = FirAuth();
  // String email = '';
  Stream<QuerySnapshot>? truyenhoanthanh;
  Stream<QuerySnapshot>? truyenluotxem;
  Stream<QuerySnapshot>? tatcatruyen;
  Stream<QuerySnapshot>? truyenmoi;
  bool dl = false;

  @override
  void initState() {
    super.initState();
    getAllTruyen();
    context.read<BlocUserLogin>().getLoggedState();
  }

  getAllTruyen() async {
    try {
      await DatabaseTruyen().getALLTruyenHoanThanh().then((value) {
        setState(() {
          truyenhoanthanh = value;
        });
      });

      print(truyenhoanthanh != null);
      await DatabaseTruyen().getAllTruyenSapXep("tongluotxem").then((val) {
        setState(() {
          truyenluotxem = val;
        });
      });
      await DatabaseTruyen().getAllTruyenSapXep('ngaycapnhat').then((vali) {
        setState(() {
          truyenmoi = vali;
        });
      });
      await DatabaseTruyen().getAllTruyen().then((vale) {
        setState(() {
          tatcatruyen = vale;
        });
      });
    } catch (e) {
      print('Lỗi ' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorClass.xanh3Color,
        shadowColor: ColorClass.xanh1Color,
        actions: [HomeAppBarAction()],
        title: Align(
            alignment: Alignment.topLeft,
            child: Text("Home", style: AppTheme.lightTextTheme.titleSmall)),
        flexibleSpace: Container(height: 80),
      ),
      endDrawer: UserDrawer(context),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 8),
        children: <Widget>[
          const SizedBox(
            height: 30,
          ),
          //
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              "Truyện mới",
              style: AppTheme.lightTextTheme.bodyLarge,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          HomeTruyenList(truyenmoi, false, ColorClass.xanh1Color),
          //
          const SizedBox(
            height: 30,
          ),
          //
          Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                "Truyện yêu thích nhất",
                style: AppTheme.lightTextTheme.bodyLarge,
              )),
          const SizedBox(
            height: 15,
          ),
          HomeTruyenList(truyenluotxem, false, ColorClass.fouthColor),
          //

          const SizedBox(
            height: 30,
          ),
          Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                "Tất cả truyện",
                style: AppTheme.lightTextTheme.bodyLarge,
              )),
          const SizedBox(
            height: 15,
          ),
          HomeTruyenList(tatcatruyen, false, ColorClass.fouthColor),
          const SizedBox(
            height: 30,
          ),
          //

          //    if (truyenhoanthanh != null)
          Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                "Truyện đã hoàn thành",
                style: AppTheme.lightTextTheme.bodyLarge,
              )),

          //    if (truyenhoanthanh != null)
          const SizedBox(
            height: 15,
          ),

          //  if (truyenhoanthanh != null)
          HomeTruyenList(truyenhoanthanh, false, ColorClass.xanh1Color),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Drawer UserDrawer(BuildContext context) {
    return Drawer(
      // backgroundColor: Colors.transparent,
      shadowColor: ColorClass.fiveColor,
      //  backgroundColor: Colors.transparent,
      child: ListView(padding: EdgeInsets.zero, children: [
        const HomeUserAccountsDrawerHeader(),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: ListTile(
            title: Row(
              children: [
                const Icon(Icons.person),
                const SizedBox(
                  width: 10,
                ),
                Text('Thông tin cá nhân',
                    style: AppTheme.lightTextTheme.bodyLarge),
              ],
            ),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => CaNhan()));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ListTile(
            title: Row(
              children: [
                const Icon(Icons.bookmark),
                const SizedBox(
                  width: 10,
                ),
                Text('Truyện của bạn',
                    style: AppTheme.lightTextTheme.bodyLarge),
              ],
            ),
            onTap: () {
              //
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ListTile(
            title: Row(
              children: [
                const Icon(Icons.exit_to_app),
                const SizedBox(
                  width: 10,
                ),
                Text('Đăng xuất', style: AppTheme.lightTextTheme.bodyLarge),
              ],
            ),
            onTap: () {
              firAuth.logOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginForm()),
                  (Route<dynamic> route) => false);
            },
          ),
        )
      ]),
    );
  }
}
