import 'package:apparch/src/bloc/bloc_timkiem.dart';
import 'package:apparch/src/firebase/services/database_chuong.dart';
import 'package:apparch/src/firebase/services/database_truyen.dart';
import 'package:apparch/src/helper/temple/app_theme.dart';
import 'package:apparch/src/helper/temple/color.dart';
import 'package:apparch/src/screen/timkiem/tim_kiem_screen.dart';
import 'package:apparch/src/screen/truyen/truyen_chi_tiet_amition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LichSuTimKiemSreen extends StatefulWidget {
  LichSuTimKiemSreen({super.key});

  @override
  State<LichSuTimKiemSreen> createState() => _LichSuTimKiemSreenState();
}

class _LichSuTimKiemSreenState extends State<LichSuTimKiemSreen> {
  Stream<QuerySnapshot>? truyenStream;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BlocTimKiem>(builder: (context, blocTimKiem, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorClass.xanh3Color,
          title: Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Lịch sử tìm kiếm',
              style: GoogleFonts.roboto(
                //roboto
                // arizonia
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        body: ListView(
          children: [
            if (blocTimKiem.lichSuTimKiem != [] &&
                // ignore: prefer_is_empty
                blocTimKiem.lichSuTimKiem.length != 0)
              for (var i = 0; i < blocTimKiem.lichSuTimKiem.length; i++)
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => TimKiemScreen(
                                  travevalue: blocTimKiem.lichSuTimKiem[i],
                                )));
                  },
                  leading: const Icon(Icons.search),
                  trailing: GestureDetector(
                    onTap: () {
                      print('goi x');
                      blocTimKiem.deleteOneList(blocTimKiem.lichSuTimKiem[i]);
                    },
                    child: const Icon(Icons.close),
                  ),
                  title: Text(
                    blocTimKiem.lichSuTimKiem[i],
                    style: AppTheme.lightTextTheme.bodyMedium,
                  ),
                )
          ],
        ),
      );
    });
  }
}
