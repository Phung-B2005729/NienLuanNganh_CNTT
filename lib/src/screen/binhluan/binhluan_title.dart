import 'package:apparch/src/bloc/bloc_user.dart';
import 'package:apparch/src/bloc/bloc_userlogin.dart';
import 'package:apparch/src/model/binhluan_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class BinhLuanTilte extends StatefulWidget {
  BinhLuanModel binhLuanModel;

  BinhLuanTilte({Key? key, required this.binhLuanModel}) : super(key: key);

  @override
  State<BinhLuanTilte> createState() => _BinhLuanTilteState();
}

class _BinhLuanTilteState extends State<BinhLuanTilte> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<BlocUserLogin>(context, listen: true);
    // ignore: unused_local_variable
    final nguoigui =
        context.read<BlocUser>().findById(widget.binhLuanModel.iduser);
    return Container(
      padding: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: widget.binhLuanModel.iduser == user.id ? 0 : 24,
          right: widget.binhLuanModel.iduser == user.id ? 24 : 0),
      alignment: widget.binhLuanModel.iduser == user.id
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: widget.binhLuanModel.iduser == user.id
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        padding:
            const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: widget.binhLuanModel.iduser == user.id
                ? const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
            color: widget.binhLuanModel.iduser == user.id
                ? Theme.of(context).primaryColor
                : Colors.grey[700]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nguoigui!.userName.toUpperCase(),
              textAlign: TextAlign.start,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(widget.binhLuanModel.noidung,
                textAlign: TextAlign.start,
                style: const TextStyle(fontSize: 16, color: Colors.white))
          ],
        ),
      ),
    );
  }
}
