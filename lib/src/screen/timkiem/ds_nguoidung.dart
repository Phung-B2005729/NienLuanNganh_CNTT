import 'package:apparch/src/firebase/services/database_user.dart';
import 'package:apparch/src/helper/temple/app_theme.dart';
import 'package:apparch/src/helper/temple/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DsNguoiDung extends StatefulWidget {
  String value;
  DsNguoiDung({super.key, required this.value});

  @override
  State<DsNguoiDung> createState() => _DsNguoiDungState();
}

class _DsNguoiDungState extends State<DsNguoiDung> {
  Stream<QuerySnapshot>? uStream;
  bool folower = true;
  @override
  void initState() {
    super.initState();
    getAllUser();
  }

  getAllUser() {
    DatabaseUser().getALLUser().then((vale) {
      setState(() {
        uStream = vale;
      });
    });
  }

  bool ktrUser(dynamic us) {
    if (us.toLowerCase().contains(widget.value.toLowerCase())) {
      return true;
    } else {
      return false;
    }
  }

  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: uStream,
        builder: (context, AsyncSnapshot snapshot) {
          return (snapshot.hasData && snapshot.data.docs.length != 0)
              ? ListView(
                  scrollDirection:
                      Axis.vertical, // true cuon doc, false cuon ngang
                  children: [
                      for (var index = 0;
                          index < snapshot.data.docs.length;
                          index++)
                        if (ktrUser(snapshot.data.docs[index]['username']) ==
                            true)
                          BuildNguoiDungTilte(snapshot, index)
                    ])
              // ignore: avoid_unnecessary_containers
              : Container(
                  child: Center(
                    child: Text(
                      'Không tìm thấy người dùng',
                      style: AppTheme.lightTextTheme.bodyMedium,
                    ),
                  ),
                );
        });
  }

  Widget BuildNguoiDungTilte(AsyncSnapshot<dynamic> snapshot, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        onTap: () {
          //chuyen ve trang thông tin cua nguoi dung
        },
        selectedColor: ColorClass.xanh1Color,
        leading: CircleAvatar(
          // ignore: unnecessary_null_comparison

          backgroundImage: NetworkImage(snapshot.data.docs[index]['avata']),
          radius: 20,
        ),
        trailing: IconButton(
            color: Colors.black,
            onPressed: () {
              setState(() {
                folower = !folower;
              });
            },
            icon: (folower == true)
                ? Icon(Icons.group)
                : Icon(Icons.person_add_alt_1_rounded)),
        title: Text(
          snapshot.data.docs[index]['username'],
          style: AppTheme.lightTextTheme.bodyMedium,
        ),
      ),
    );
  }
}
