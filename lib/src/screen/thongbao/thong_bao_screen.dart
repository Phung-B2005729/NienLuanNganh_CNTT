import 'package:apparch/src/bloc/bloc_thongbao.dart';
import 'package:apparch/src/bloc/bloc_truyen.dart';
import 'package:apparch/src/bloc/bloc_userlogin.dart';
import 'package:apparch/src/helper/temple/color.dart';
import 'package:apparch/src/screen/share/user_appbar_action.dart';
import 'package:apparch/src/screen/thongbao/thongbao_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ThongBaoScreen extends StatefulWidget {
  const ThongBaoScreen({super.key});

  @override
  State<ThongBaoScreen> createState() => _ThongBaoScreenState();
}

class _ThongBaoScreenState extends State<ThongBaoScreen> {
  late Future<void> allthongbao;
  @override
  void initState() {
    super.initState();
    allthongbao = getData();
  }

  Future<void> getData() async {
    await context.read<BlocTruyen>().getAllTruyen();
    // ignore: use_build_context_synchronously
    return await context.read<BlocThongBao>().getAllThongBao();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final blocUserLogin = Provider.of<BlocUserLogin>(context, listen: true);
    return Scaffold(
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
        ),
        body: FutureBuilder(
            future: allthongbao,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ThongBaoList();
              }
              return const Center(
                child: CircularProgressIndicator(
                  color: ColorClass.xanh2Color,
                ),
              );
            }));
  }
}
