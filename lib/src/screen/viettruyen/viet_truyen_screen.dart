import 'package:apparch/src/bloc/bloc_userlogin.dart';
import 'package:apparch/src/helper/temple/Color.dart';
import 'package:apparch/src/screen/viettruyen/taomoi/truyen_them_sceen.dart';
import 'package:apparch/src/screen/viettruyen/truyen_ban_thao.dart';
import 'package:apparch/src/screen/viettruyen/truyen_dang_tai.dart';
import 'package:apparch/src/screen/share/user_appbar_action.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../helper/temple/app_theme.dart';

class VietTruyenScreen extends StatelessWidget {
  const VietTruyenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final blocUserLogin = Provider.of<BlocUserLogin>(context, listen: true);
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: ColorClass.xanh3Color,
            shadowColor: ColorClass.xanh1Color,
            title: Align(
                alignment: Alignment.topLeft,
                child:
                    Text("Truyện", style: AppTheme.lightTextTheme.titleSmall)),
            actions: <Widget>[UserAppbarAction()],
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
                tabs: const <Widget>[
                  Tab(
                    text: 'Truyện đã đăng',
                  ),
                  Tab(
                    text: 'Bản thảo',
                  ),
                ]),
          ),
          body: TabBarView(children: <Widget>[
            TruyenDangTai(
              iduser: blocUserLogin.id,
            ),
            TruyenBanThao(
              iduser: blocUserLogin.id,
            )
          ]),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              print('chuyen trang');
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => InsertTruyenScreen()));
            },
            // ignore: sort_child_properties_last
            child: const Icon(Icons.add),
            backgroundColor: ColorClass.fiveColor,
          )),
    );
  }
}
