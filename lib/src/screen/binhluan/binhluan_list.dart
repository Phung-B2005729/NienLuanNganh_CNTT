import 'package:apparch/src/bloc/bloc_binhluan.dart';
import 'package:apparch/src/bloc/bloc_user.dart';
import 'package:apparch/src/bloc/bloc_userlogin.dart';
import 'package:apparch/src/helper/date_time_function.dart';
import 'package:apparch/src/helper/temple/app_theme.dart';
import 'package:apparch/src/helper/temple/color.dart';
import 'package:apparch/src/model/binhluan_model.dart';
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
      mainAxisSize: MainAxisSize.min,
      children: [
        binhluantilte(binhLuanModel, context, giatri),
        if (binhLuanModel.xemthem)
          ...listphanhoi.map(
            (phanhoi) =>
                buildbinhluan(phanhoi, context, (giatri + 1).toDouble()),
          ),
      ],
    );
  }

  Widget binhluantilte(
      BinhLuanModel binhLuanModel, BuildContext context, double giatri) {
    final user = Provider.of<BlocUserLogin>(context, listen: true);
    final nguoigui = context.read<BlocUser>().findById(binhLuanModel.iduser);
    List<BinhLuanModel> listphanhoi =
        context.read<BlocBinhLuan>().getDSBinhLuanIdReply(binhLuanModel.id!);
    print('giá trị ' + giatri.toString());
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: (16 - giatri).toDouble(),
          right: (24 - giatri).toDouble()),
      alignment: Alignment.topLeft,
      child: Container(
        margin:
            EdgeInsets.only(left: (giatri == 0) ? 0 : (giatri * 25).toDouble()),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: binhLuanModel.iduser == user.id
              ? const Color.fromARGB(
                  255, 147, 171, 185) // ColorClass.xanh3Color
              : ColorClass.fouthColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: (listphanhoi.isEmpty)
                  ? const EdgeInsets.only(left: 8, top: 8)
                  : const EdgeInsets.only(left: 0, top: 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: (listphanhoi.length > 0)
                    ? MainAxisAlignment.spaceAround
                    : MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(nguoigui!.avata),
                    radius: 13,
                  ),
                  if (listphanhoi.isEmpty) const SizedBox(width: 15),
                  // if (listphanhoi.isNotEmpty) const SizedBox(width: 0),
                  Text(
                    (widget.idtacgia == nguoigui.id)
                        ? 'Tác giả - ${nguoigui.userName}'
                        : nguoigui.userName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: (widget.idtacgia == nguoigui.id)
                          ? const Color.fromARGB(255, 215, 113, 58)
                          : Colors.black,
                      letterSpacing: -0.5,
                    ),
                  ),
                  if (listphanhoi.length > 0)
                    const SizedBox(
                      width: 90,
                    ),
                  if (listphanhoi.length > 0)
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            binhLuanModel = binhLuanModel.copyWith(
                                xemthem: !binhLuanModel.xemthem);
                            context
                                .read<BlocBinhLuan>()
                                .updateBinhLuan(binhLuanModel);
                          });
                        },
                        icon: Icon((binhLuanModel.xemthem == false)
                            ? Icons.expand_less
                            : Icons.expand_more),
                        // iconSize: 20,
                        color: Colors.black,
                      ),
                    ),

                  // có phản hồi
                ],
              ),
            ),

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
            Padding(
              padding: const EdgeInsets.only(top: 3, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 3,
                        horizontal: (10 - giatri).toDouble() <= 0
                            ? 0
                            : (10 - giatri).toDouble()),
                    child: Text(
                      binhLuanModel.ngaycapnhat,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // Handle reply logic
                      setState(() {
                        idreply = binhLuanModel.id!;
                        labelt = 'Đang trả lời @${nguoigui.userName}';
                        binhluanFocus.requestFocus();
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 3,
                          horizontal: (10 - giatri).toDouble() <= 0
                              ? 0
                              : (10 - giatri).toDouble()),
                      child: const Text(
                        'Trả lời',
                        style: TextStyle(
                          fontSize: 13,
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
                        context
                            .read<BlocBinhLuan>()
                            .deleteBinhLuanidreply(binhLuanModel.id!);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 3,
                            horizontal: (10 - giatri).toDouble() <= 0
                                ? 0
                                : (10 - giatri).toDouble()),
                        child: const Text(
                          'Thu hồi',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 203, 203, 203),
                borderRadius: BorderRadius.circular(25),
              ),
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
                        labelText: labelt != '' ? labelt : null,
                        hintStyle:
                            const TextStyle(color: Colors.grey, fontSize: 16),
                        labelStyle:
                            const TextStyle(color: Colors.black, fontSize: 18),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () async {
              print('gọi gửi');
              await guiBinhLuan(context, user.id);
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
