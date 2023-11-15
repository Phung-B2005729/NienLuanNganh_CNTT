// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:apparch/src/bloc/bloc_thongbao.dart';
import 'package:apparch/src/bloc/bloc_truyen.dart';
import 'package:apparch/src/bloc/bloc_user.dart';
import 'package:apparch/src/bloc/bloc_userlogin.dart';
import 'package:apparch/src/firebase/services/database_chuong.dart';
import 'package:apparch/src/helper/temple/app_theme.dart';
import 'package:apparch/src/model/thongbao_model.dart';
import 'package:apparch/src/screen/chuong/chuong_amition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThongBaoTilte extends StatefulWidget {
  const ThongBaoTilte(this.thongBaoModel, {super.key});
  // ignore: non_constant_identifier_names
  final ThongBaoModel thongBaoModel;

  @override
  State<ThongBaoTilte> createState() => _ThongBaoTilteState();
}

class _ThongBaoTilteState extends State<ThongBaoTilte> {
  QuerySnapshot? allChuongStream;
  late int vt; // vị trương
  // Stream<QuerySnapshot>? truyenStream;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    // ignore: unnecessary_null_comparison
    if (widget.thongBaoModel != null) {
      await DatabaseChuong()
          .getALLChuongSX(widget.thongBaoModel.idtruyen, false)
          .then((vale) {
        if (mounted) {
          setState(() {
            allChuongStream = vale; // lấy danh chương
            for (int i = 0; i < vale.docs.length; i++) {
              if (vale.docs[i].id == widget.thongBaoModel.idchuong) {
                print('idchuong' + widget.thongBaoModel.idchuong);
                vt = i;
              }
            }
          });
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final thongbao = Provider.of<BlocThongBao>(context);
    final user = Provider.of<BlocUserLogin>(context);
    // ignore: unused_local_variable
    final userAll = Provider.of<BlocUser>(context);
    final tacgia = userAll.findById(widget.thongBaoModel.idtacgia);
    // ignore: unused_local_variable
    final truyen = Provider.of<BlocTruyen>(context);
    print(widget.thongBaoModel.idtruyen);
    print('lengt' + truyen.allTruyenCount.toString());
    final tentruyen =
        truyen?.findById(widget.thongBaoModel.idtruyen)?.tentruyen ?? '';
    final linkanh =
        truyen?.findById(widget.thongBaoModel.idtruyen)?.linkanh ?? '';
    print('linh anh' + linkanh);
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
          //   margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color:
                kiemTraIdUser(widget.thongBaoModel.danhsachiduserdadoc, user.id)
                    ? Colors.white
                    : const Color.fromARGB(255, 239, 198, 156),
            border: Border(
              bottom: BorderSide(
                color: kiemTraIdUser(
                        widget.thongBaoModel.danhsachiduserdadoc, user.id)
                    ? Colors.grey
                    : const Color.fromARGB(255, 216, 162,
                        108), // Choose the color of the underline
                width: kiemTraIdUser(
                        widget.thongBaoModel.danhsachiduserdadoc, user.id)
                    ? 1.0
                    : 5.0, // Choose the thickness of the underline
              ),
            ),
          ),
          child: ListTile(
            onTap: () {
              //cập nhật lại userdadoc
              context.read<BlocThongBao>().addIduserDanhSachUserDaDoc(
                  widget.thongBaoModel.id!, user.id);
              // chuyển chuongamition
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ChuongAmition(
                          listchuong: allChuongStream!.docs,
                          vt: vt,
                          idtruyen: widget.thongBaoModel.idtruyen,
                          iduser: user.id,
                          edit: false)));
            },
            leading: CircleAvatar(
              // ignore: unnecessary_null_comparison
              backgroundImage: NetworkImage(tacgia!.avata),
              radius: 20,
            ),
            title: Text(
              tacgia!.userName +
                  " đã cập nhật " +
                  tentruyen +
                  "-" +
                  widget.thongBaoModel.tenchuong,
              style: AppTheme.lightTextTheme.bodySmall,
            ),
            subtitle: Text("Cập nhật " + widget.thongBaoModel.ngaycapnhat,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.normal)),
            // ignore: sized_box_for_whitespace
            trailing: Container(
                height: 50,
                color: Colors.white,
                child: (linkanh != '') ? Image.network(linkanh) : Text('')),
          )),
    );
  }

  bool kiemTraIdUser(List<dynamic> danhsachiduserdadoc, String iduser) {
    if (danhsachiduserdadoc.contains(iduser)) {
      return true;
    } else {
      return false;
    }
  }
}
/*ListTile(
      onTap: () {
        // chuyển chuongamition
      },
      title: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Text(widget.ThongBaoModel.name,
            style: AppTheme.lightTextTheme.headlineMedium),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Text(
          // ignore: prefer_interpolation_to_compose_strings
          "Mở đề: " +
              widget.ThongBaoModel.thoigianmode +
              "\nĐóng đề: " +
              widget.ThongBaoModel.thoigiandongde,
          style: AppTheme.lightTextTheme.bodySmall,
        ),
      ),
    );*/