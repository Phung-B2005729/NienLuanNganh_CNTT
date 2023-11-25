/*
import 'package:apparch/src/bloc/bloc_binhluan.dart';
import 'package:apparch/src/bloc/bloc_user.dart';
import 'package:apparch/src/bloc/bloc_userlogin.dart';
import 'package:apparch/src/helper/date_time_function.dart';
import 'package:apparch/src/helper/temple/app_theme.dart';
import 'package:apparch/src/helper/temple/color.dart';
import 'package:apparch/src/model/binhluan_model.dart';
import 'package:apparch/src/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class BinhLuanList extends StatefulWidget {
  String idchuong;
  String idtruyen;
  String idtacgia;
  BinhLuanList(
      {super.key,
      required this.idchuong,
      required this.idtruyen,
      required this.idtacgia});

  @override
  State<BinhLuanList> createState() => _BinhLuanListState();
}

class _BinhLuanListState extends State<BinhLuanList> {
  TextEditingController binhluanController = TextEditingController();
  FocusNode binhluanFocus = FocusNode();
  String idreply = '0';
  String labelt = '';
  String xemphanhoi = '';
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable

    // ignore: unused_local_variable
    return Column(
      children: <Widget>[
        // chat messages here
        Expanded(
          child: Consumer<BlocBinhLuan>(
            builder: (context, blocBinhLuan, child) {
              List<BinhLuanModel> listbinhluan =
                  blocBinhLuan.getDSBinhLuanIdChuong(widget.idchuong);
              return Padding(
                padding: const EdgeInsets.only(top: 5),
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return const SizedBox(width: 5);
                  },
                  scrollDirection: Axis.vertical,
                  itemCount: listbinhluan.length,
                  itemBuilder: (context, index) {
                    return buildbinhluan(listbinhluan[index], context, 0.0);
                  },
                ),
              );
            },
          ),
        ),
        BuiildSendBinhLuan(context)
      ],
    );
  }

  Widget buildbinhluan(
      BinhLuanModel binhLuanModel, BuildContext context, double giatri) {
    List<BinhLuanModel> listphanhoi =
        context.read<BlocBinhLuan>().getDSBinhLuanIdReply(binhLuanModel.id!);
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        binhluantilte(binhLuanModel, context, giatri),
        if (xemphanhoi != '' && xemphanhoi == binhLuanModel.id)
          for (var i = 0; i < listphanhoi.length; i++)
            buildbinhluan(listphanhoi[i], context, (giatri + 3).toDouble())
      ],
    );
  }

  Widget binhluantiltephanhoi(
      BinhLuanModel binhLuanModel, BuildContext context, double giatri) {
    print('gia tri' + giatri.toString());
    return buildbinhluan(binhLuanModel, context, giatri);
    /* List<BinhLuanModel> listphanhoi =
        context.read<BlocBinhLuan>().getDSBinhLuanIdReply(binhLuanModel.id!);

    final user = Provider.of<BlocUserLogin>(context, listen: true);
    final nguoigui = context.read<BlocUser>().findById(binhLuanModel.iduser);
    return Container(
      padding: EdgeInsets.only(
        top: 8,
        bottom: 8,
        left: binhLuanModel.iduser == user.id ? 28 : 20,
        right: binhLuanModel.iduser == user.id ? 20 : 28,
      ),
      alignment: binhLuanModel.iduser == user.id
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        // padding: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: binhLuanModel.iduser == user.id
              ? ColorClass.xanh1Color // ColorClass.xanh3Color
              : ColorClass.fouthColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(nguoigui!.avata),
                    radius: 15,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    (widget.idtacgia == nguoigui.id)
                        ? 'Tác giả - ' + nguoigui.userName
                        : nguoigui.userName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: (widget.idtacgia == nguoigui.id)
                          ? const Color.fromARGB(255, 215, 113, 58)
                          : Colors.black,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 35),
              child: Text(
                binhLuanModel.noidung,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            // Reply button
            Row(
              mainAxisAlignment: (binhLuanModel.iduser != user.id)
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: Text(
                    binhLuanModel.ngaycapnhat,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                if (listphanhoi.length > 0)
                  InkWell(
                    onTap: () {
                      // Handle reply logic
                      setState(() {
                        xemphanhoi = binhLuanModel.id!;
                      });
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      decoration: BoxDecoration(
                        // color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Xem thêm',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                if (binhLuanModel.iduser != user.id)
                  InkWell(
                    onTap: () {
                      // Handle reply logic
                      setState(() {
                        idreply = binhLuanModel.id!;
                        labelt = 'Đang trả lời @' + nguoigui.userName;
                        binhluanFocus.requestFocus();
                      });
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      decoration: BoxDecoration(
                        // color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Trả lời',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                if (binhLuanModel.iduser == user.id)
                  InkWell(
                    onTap: () {
                      // Handle reply logic
                      // xoá bình luận
                      context
                          .read<BlocBinhLuan>()
                          .deleteBinhLuan(binhLuanModel.id!);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      decoration: BoxDecoration(
                        // color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Thu hồi',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    ); */
  }

  Widget binhluantilte(
      BinhLuanModel binhLuanModel, BuildContext context, double giatri) {
    final user = Provider.of<BlocUserLogin>(context, listen: true);
    final nguoigui = context.read<BlocUser>().findById(binhLuanModel.iduser);
    List<BinhLuanModel> listphanhoi =
        context.read<BlocBinhLuan>().getDSBinhLuanIdReply(binhLuanModel.id!);
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: (16 - giatri).toDouble(),
          right: (24 - giatri).toDouble()),
      alignment: Alignment.topLeft,
      child: Container(
        margin:
            EdgeInsets.only(left: (giatri == 0) ? 0 : (25 + giatri).toDouble()),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: binhLuanModel.iduser == user.id
              ? Color.fromARGB(255, 147, 171, 185) // ColorClass.xanh3Color
              : ColorClass.fouthColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(nguoigui!.avata),
                    radius: 15,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    (widget.idtacgia == nguoigui.id)
                        ? 'Tác giả - ' + nguoigui.userName
                        : nguoigui.userName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: (widget.idtacgia == nguoigui.id)
                          ? const Color.fromARGB(255, 215, 113, 58)
                          : Colors.black,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 35),
              child: Text(
                binhLuanModel.noidung,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            // Reply button
            Row(
              mainAxisAlignment: (binhLuanModel.iduser != user.id)
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 5, horizontal: (10 - giatri).toDouble()),
                  child: Text(
                    binhLuanModel.ngaycapnhat,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                if (listphanhoi.length > 0) // có phản hồi
                  (xemphanhoi != binhLuanModel.id) //  chưa hiện danh sách
                      ? InkWell(
                          onTap: () {
                            // Handle reply logic
                            setState(() {
                              xemphanhoi = binhLuanModel.id!;
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: (10 - giatri).toDouble()),
                            child: const Text(
                              'xem thêm',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            // Handle reply logic
                            setState(() {
                              xemphanhoi = '';
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: (10 - giatri).toDouble()),
                            child: const Text(
                              'thu gọn',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                if (binhLuanModel.iduser != user.id)
                  InkWell(
                    onTap: () {
                      // Handle reply logic
                      setState(() {
                        idreply = binhLuanModel.id!;
                        labelt = 'Đang trả lời @' + nguoigui.userName;
                        binhluanFocus.requestFocus();
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 8, horizontal: (10 - giatri).toDouble()),
                      child: const Text(
                        'Trả lời',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                if (binhLuanModel.iduser == user.id)
                  InkWell(
                    onTap: () {
                      // Handle reply logic
                      // xoá bình luận
                      context
                          .read<BlocBinhLuan>()
                          .deleteBinhLuan(binhLuanModel.id!);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 8, horizontal: (10 - giatri).toDouble()),
                      child: const Text(
                        'Thu hồi',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget BuiildSendBinhLuan(BuildContext context) {
    final user = Provider.of<BlocUserLogin>(context, listen: true);
    return Container(
      alignment: Alignment.bottomCenter,
      width: MediaQuery.of(context).size.width,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        margin: const EdgeInsets.only(bottom: 20),
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 203, 203, 203),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Expanded(
                  child: Row(
                    children: [
                      const SizedBox(width: 15),
                      Expanded(
                        child: TextFormField(
                          focusNode: binhluanFocus,
                          maxLines: null,
                          maxLength: null,
                          controller: binhluanController,
                          cursorColor: const Color.fromARGB(255, 95, 95, 95),
                          style: AppTheme.lightTextTheme.bodyMedium,
                          decoration: InputDecoration(
                            hintText: "viết bình luận ......",
                            labelText: labelt != ''
                                ? labelt
                                : null, // Use labelText instead of label
                            hintStyle: const TextStyle(
                                color: Colors.grey, fontSize: 16),
                            labelStyle: const TextStyle(
                                color: Colors.black, fontSize: 18),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () async {
                print('gọi gửi');
                await guiBinhLuan(context, user.id);
                // Send message logic
                setState(() {
                  binhluanController.clear();
                  binhluanFocus.unfocus();
                  labelt = '';
                });
              },
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  guiBinhLuan(BuildContext context, String iduser) async {
    if (binhluanController.text.isNotEmpty) {
      // thm
      BinhLuanModel binhLuanModel = BinhLuanModel(
          idchuong: widget.idchuong,
          iduser: iduser,
          idtruyen: widget.idtruyen,
          noidung: binhluanController.text,
          idreply: idreply,
          ngaycapnhat: DatetimeFunction.getGioFormDateTime(DateTime.now()));
      // thm
      await context.read<BlocBinhLuan>().addBinhLuan(binhLuanModel);
    }
  }
}
*/