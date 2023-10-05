import 'package:apparch/src/helper/temple/app_theme.dart';
import 'package:apparch/src/screen/truyen/truyen_chi_tiet_amition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../helper/date_time_function.dart';

// ignore: must_be_immutable
class VietTruyenList extends StatelessWidget {
  Stream<QuerySnapshot>? truyenStream;
  bool ktrCuon;
  Color tcolor;
  VietTruyenList(this.truyenStream, this.ktrCuon, this.tcolor, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: truyenStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.separated(
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 2);
                },
                scrollDirection:
                    Axis.vertical, // true cuon doc, false cuon ngang
                itemCount: snapshot.data.docs.length, // Số lượng phần tử ngang
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TruyenChiTietAmition(
                                    lisTruyen: snapshot.data.docs,
                                    vttruyen: index,
                                    edit: true,
                                  )));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 150,
                        width: 325,
                        decoration: BoxDecoration(
                          //   color: Color.fromARGB(255, 231, 237, 242),
                          color: const Color.fromARGB(255, 239, 236, 236),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(255, 191, 188, 188),
                              offset: Offset(10, 15),
                              blurRadius: 8.0,
                            )
                          ],
                        ),
                        child: Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image(
                                // ignore: prefer_interpolation_to_compose_strings
                                image: snapshot.data.docs[index]['linkanh'] !=
                                        null
                                    // ignore: prefer_interpolation_to_compose_strings
                                    ? AssetImage("assets/images/" +
                                        snapshot.data.docs[index]['linkanh'])
                                    : const AssetImage(
                                        "assets/images/avatarmacdinh.png"),
                                width: 120,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Text(
                                            snapshot.data.docs[index]
                                                ['tentruyen'],
                                            style: GoogleFonts.arizonia(
                                              //roboto
                                              // arizonia
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                            softWrap: true),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: PopupMenuButton(
                                            onSelected: (value) {
                                              if (value == 'xem trước') {
                                                print(value);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            TruyenChiTietAmition(
                                                              lisTruyen:
                                                                  snapshot.data
                                                                      .docs,
                                                              vttruyen: index,
                                                              edit: true,
                                                            )));
                                              } else if (value == 'chỉnh sửa') {
                                                print(value);
                                                // Xử lý khi chọn "Chỉnh sửa"
                                                // Đặt mã xử lý ở đây
                                              } else if (value == 'xoá') {
                                                print(value);
                                                // Xử lý khi chọn "Xóa"
                                                // Đặt mã xử lý ở đây
                                              }
                                            },
                                            color: const Color.fromARGB(
                                                255, 237, 236, 236),
                                            icon: const Icon(
                                              Icons.more_vert,
                                              color: Colors.black,
                                            ),
                                            itemBuilder:
                                                (BuildContext context) =>
                                                    <PopupMenuEntry<String>>[
                                                      PopupMenuItem<String>(
                                                        value: 'xem trước',
                                                        child: Text(
                                                          'xem trước',
                                                          style: AppTheme
                                                              .lightTextTheme
                                                              .bodySmall,
                                                        ),
                                                      ),
                                                      PopupMenuItem<String>(
                                                        value: 'chỉnh sửa',
                                                        child: Text('chỉnh sửa',
                                                            style: AppTheme
                                                                .lightTextTheme
                                                                .bodySmall),
                                                      ),
                                                      PopupMenuItem<String>(
                                                        value: 'xoá',
                                                        child: Text('xoá',
                                                            style: AppTheme
                                                                .lightTextTheme
                                                                .bodySmall),
                                                      ),
                                                    ]),
                                      )
                                    ],
                                  ),
                                  Text(
                                    // ignore: prefer_interpolation_to_compose_strings
                                    "Ngày cập nhật " +
                                        DatetimeFunction.getTimeFormatDatabase(
                                            snapshot.data.docs[index]
                                                ['ngaycapnhat']),
                                    style: AppTheme.lightTextTheme.bodySmall,
                                    softWrap: true,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            : Container(color: const Color.fromARGB(0, 164, 10, 10));
      },
    );
  }
}
