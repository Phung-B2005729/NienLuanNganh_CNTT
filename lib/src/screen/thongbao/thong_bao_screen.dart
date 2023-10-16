import 'package:apparch/src/bloc/bloc_userlogin.dart';
import 'package:apparch/src/helper/temple/app_theme.dart';
import 'package:apparch/src/helper/temple/color.dart';
import 'package:apparch/src/screen/share/user_appbar_action.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ThongBaoScreen extends StatelessWidget {
  const ThongBaoScreen({super.key});

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
              child: Text(
                "Cập nhật gần đây",
                style: GoogleFonts.arizonia(
                  //roboto
                  // arizonia
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              )),
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
                  text: 'Thông báo',
                ),
                Tab(
                  text: 'Tin nhắn',
                ),
              ]),
        ),
        body: const TabBarView(children: <Widget>[
          Text('Chương được cập nhật'),
          Text('Tin nhắn'),
        ]),
      ),
    );
  }
}