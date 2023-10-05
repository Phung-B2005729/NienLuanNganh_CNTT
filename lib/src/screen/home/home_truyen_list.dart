import 'package:apparch/src/helper/temple/app_theme.dart';
import 'package:apparch/src/screen/truyen/truyen_chi_tiet_amition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class HomeTruyenList extends StatelessWidget {
  Stream<QuerySnapshot>? truyenStream;
  bool ktrCuon;
  Color tcolor;
  HomeTruyenList(this.truyenStream, this.ktrCuon, this.tcolor, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: truyenStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? Container(
                height: 180,
                color: Colors.transparent,
                padding: const EdgeInsets.only(right: 8, bottom: 3),
                child: ListView.separated(
                  // builder
                  //shrinkWrap: true,
                  separatorBuilder: (context, index) {
                    return const SizedBox(width: 2);
                  },
                  scrollDirection: ktrCuon
                      ? Axis.vertical
                      : Axis.horizontal, // true cuon doc, false cuon ngang
                  itemCount:
                      snapshot.data.docs.length, // Số lượng phần tử ngang
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TruyenChiTietAmition(
                                    lisTruyen: snapshot.data.docs,
                                    vttruyen: index,
                                    edit: false,
                                  )),
                        );
                      },
                      child: Container(
                        height: 200,
                        width: 325,
                        margin: const EdgeInsets.only(
                            right: 5, bottom: 5, left: 8, top: 5),
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
                            border: Border.all(width: 4, color: tcolor)),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Image(
                                // ignore: prefer_interpolation_to_compose_strings
                                image: AssetImage("assets/images/" +
                                    snapshot.data.docs[index]['linkanh']),
                              ),
                            ),
                            Positioned(
                                top: 3,
                                left: 125,
                                child:
                                    Text(snapshot.data.docs[index]['tentruyen'],
                                        style: GoogleFonts.arizonia(
                                          //roboto
                                          // arizonia
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        softWrap: true)),
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 130, top: 38, bottom: 3),
                              child: Text(
                                snapshot.data.docs[index]['mota'],
                                style: AppTheme.lightTextTheme.bodySmall,
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            : Container(color: const Color.fromARGB(0, 164, 10, 10));
      },
    );
  }
}
