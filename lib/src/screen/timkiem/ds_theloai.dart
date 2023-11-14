import 'package:apparch/src/firebase/services/database_theloai.dart';
import 'package:apparch/src/helper/temple/app_theme.dart';
import 'package:apparch/src/helper/temple/color.dart';
import 'package:apparch/src/screen/timkiem/tim_kiem_theloai_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DSTheLoai extends StatefulWidget {
  const DSTheLoai({super.key});

  @override
  State<DSTheLoai> createState() => _DSTheLoaiState();
}

class _DSTheLoaiState extends State<DSTheLoai> {
  Stream<QuerySnapshot>? theloai;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    await DatabaseTheLoai().getALLTheLoai().then((va) {
      setState(() {
        theloai = va;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: theloai,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: GridView.custom(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 5 // Đặt số lượng cột ở đây
                            ),
                    childrenDelegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return BuildTheLoai(context, snapshot, index);
                      },
                      childCount: snapshot.data!.docs.length,
                    ),
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(
                  color: ColorClass.fiveColor,
                ));
        });
  }

  GestureDetector BuildTheLoai(BuildContext context,
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot, int index) {
    return GestureDetector(
      onTap: () {
        // chuyen gia tri tìm kiếm
        // hoặc hiển thị trang chứa nội dung cái thế loại này??
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => TimKiemTheLoaiSreen(
                      value: snapshot.data!.docs[index]['idloai'],
                      tenloai: snapshot.data!.docs[index]['tenloai'],
                    )));
      },
      child: Container(
        height: 10,
        width: 20,
        padding: const EdgeInsets.all(5),
        // margin: const EdgeInsets.all(20),
        color: const Color.fromARGB(255, 182, 211, 230),
        child: Center(
            child: Text(
          snapshot.data!.docs[index]['tenloai'],
          style: AppTheme.lightTextTheme.bodyLarge,
          softWrap: true,
        )),
      ),
    );
  }
}
