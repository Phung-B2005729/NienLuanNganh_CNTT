import 'package:apparch/src/bloc/bloc_thongbao.dart';
import 'package:apparch/src/bloc/bloc_userlogin.dart';
import 'package:apparch/src/model/thongbao_model.dart';
import 'package:apparch/src/screen/thongbao/thongbao_tilte.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ThongBaoList extends StatelessWidget {
  ThongBaoList({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<BlocUserLogin>(context, listen: true);
    // ignore: unused_local_variable
    return Consumer<BlocThongBao>(
      builder: (context, blocThongBao, child) {
        List<ThongBaoModel> listthongbao =
            blocThongBao.getDSThongBaoIdUser(user.id);

        return ListView.separated(
          separatorBuilder: (context, index) {
            return const SizedBox(width: 5);
          },
          scrollDirection: Axis.vertical,
          itemCount: listthongbao.length,
          itemBuilder: (context, index) {
            return ThongBaoTilte(listthongbao[index]);
          },
        );
      },
    );
  }
}
