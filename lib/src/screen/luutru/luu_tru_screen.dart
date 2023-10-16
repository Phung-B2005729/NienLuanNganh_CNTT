import 'package:apparch/src/bloc/bloc_userlogin.dart';
import 'package:apparch/src/helper/temple/app_theme.dart';
import 'package:apparch/src/helper/temple/color.dart';
import 'package:apparch/src/screen/share/user_appbar_action.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LuuTruScreen extends StatelessWidget {
  const LuuTruScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
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
                  Text("Thư viện", style: AppTheme.lightTextTheme.titleSmall)),
          actions: <Widget>[UserAppbarAction()],
          notificationPredicate: (ScrollNotification notification) {
            return notification.depth == 1;
          },
          // The elevation value of the app bar when scroll view has
          // scrolled underneath the app bar.
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
                  text: 'Riêng tư',
                ),
                Tab(
                  text: 'Danh sách đọc',
                ),
              ]),
        ),
        body: const TabBarView(children: <Widget>[
          Text('Danh sách truyện trong thư viện'),
          Text('Danh sách đọc'),
        ]),
      ),
    );
  }
}
