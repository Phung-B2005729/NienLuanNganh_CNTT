import 'package:apparch/src/bloc/bloc_binhluan.dart';
import 'package:apparch/src/helper/temple/app_theme.dart';
import 'package:apparch/src/helper/temple/color.dart';
import 'package:apparch/src/screen/binhluan/binhluan_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BinhLuanScreen extends StatefulWidget {
  final String idtruyen;
  final String idchuong;
  final String idtacgia;
  const BinhLuanScreen({
    Key? key,
    required this.idtruyen,
    required this.idchuong,
    required this.idtacgia,
  }) : super(key: key);

  @override
  State<BinhLuanScreen> createState() => _BinhLuanScreenState();
}

class _BinhLuanScreenState extends State<BinhLuanScreen> {
  late Future<void> allBinhLuan;

  @override
  void initState() {
    super.initState();
    allBinhLuan = getData();
  }

  Future<void> getData() async {
    return await context.read<BlocBinhLuan>().getAllBinhLuan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: ColorClass.xanh3Color,
          shadowColor: ColorClass.xanh1Color,
          title: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Bình luận',
                style: AppTheme.lightTextTheme.bodyLarge,
              )),
        ),
        body: FutureBuilder(
            future: allBinhLuan,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return BinhLuanList(
                  idchuong: widget.idchuong,
                  idtruyen: widget.idtruyen,
                  idtacgia: widget.idtacgia,
                );
              }
              return const Center(
                child: CircularProgressIndicator(
                  color: ColorClass.xanh2Color,
                ),
              );
            }));
  }
}
