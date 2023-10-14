import 'package:apparch/src/screen/truyen/truyen_chi_tiet_detail1.dart';
import 'package:apparch/src/screen/truyen/truyen_chi_tiet_detail2.dart';
import 'package:apparch/src/screen/viettruyen/edit/truyen_edit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../bloc/bloc_userlogin.dart';
import '../../firebase/services/database_chuong.dart';
import '../../firebase/services/database_truyen.dart';
import '../../helper/temple/Color.dart';

// ignore: must_be_immutable
class TruyenChiTietScreen extends StatefulWidget {
  final String idtruyen;
  bool edit;
  TruyenChiTietScreen({super.key, required this.idtruyen, required this.edit});

  @override
  State<TruyenChiTietScreen> createState() => _TruyenChiTietScreenState();
}

class _TruyenChiTietScreenState extends State<TruyenChiTietScreen>
    with SingleTickerProviderStateMixin {
  // ignore: prefer_typing_uninitialized_variables
  var countChuong;
  // ignore: prefer_typing_uninitialized_variables
  var truyenData;
  late TabController _tabController;
  @override
  void initState() {
    super.initState();

    getCountChuong();
    _tabController = TabController(length: 2, vsync: this);
  }

  getCountChuong() async {
    try {
      await DatabaseTruyen().getTruyenId(widget.idtruyen).then((value) {
        setState(() {
          truyenData = value;
        });
      });
      await DatabaseChuong()
          .getALLChuongSX(widget.idtruyen, false)
          .then((value) {
        setState(() {
          countChuong = value.size;
          // ignore: avoid_print
          print(value.size);
        });
      });
    } catch (e) {
      print('Lỗi khi lấy dữ liệu: $e');
    }
  }

//
  // ignore: empty_constructor_bodies
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    if (truyenData != null && countChuong != null) {
      return Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  forceElevated: innerBoxIsScrolled,
                  toolbarHeight: 80,
                  pinned: true,
                  actions: [
                    if (widget.edit == true)
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => EditTruyenScreen(
                                      tinhtrang: truyenData['tinhtrang'],
                                      linkanh: truyenData['linkanh'],
                                      tag: truyenData['tags'],
                                      tentruyen: truyenData['tentruyen'],
                                      idtruyen: truyenData['idtruyen'],
                                      theloai: truyenData['theloai'],
                                      mota: truyenData['mota'],
                                      ktrbanthao:
                                          truyenData['tinhtrang'] == 'Bản thảo'
                                              ? true
                                              : false)));

                          // chuyen qua trang edit
                        },
                        // ignore: prefer_const_constructors
                        icon: Icon(Icons.edit),
                      )
                  ],
                  title: Text(
                    truyenData['tentruyen'],
                    style: GoogleFonts.arizonia(
                      //roboto
                      // arizonia
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    softWrap: true,
                  ),
                  snap: false,
                  floating: false,
                  backgroundColor: const Color.fromARGB(246, 103, 161, 200),
                  expandedHeight: 350.0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(
                          10), // Điều này sẽ bo tròn góc dưới của SliverAppBar
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                      // ignore: prefer_interpolation_to_compose_strings
                      truyenData['linkanh'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(40),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.white),
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25))),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                          top: 5,
                        ),
                        child: TabBar(
                          indicator: const UnderlineTabIndicator(
                              borderSide: BorderSide(
                                width: 2,
                                color: ColorClass.fiveColor,
                              ),
                              insets: EdgeInsets.symmetric(horizontal: 20.0)),

                          labelStyle: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          labelColor: ColorClass.fiveColor,
                          unselectedLabelColor: Colors.black,
                          controller:
                              _tabController, // Kết nối TabController với TabBar
                          tabs: const [
                            Tab(
                              text: 'Chi Tiết',
                            ),
                            Tab(
                              text: 'Chương',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController, // Kết nối TabController với TabBarView
            children: <Widget>[
              Builder(builder: (BuildContext context) {
                final blocUserLogin =
                    Provider.of<BlocUserLogin>(context, listen: true);
                return TruyenChiTietDetail1(
                  idtruyen: widget.idtruyen,
                  iduser: blocUserLogin.id,
                  edit: widget.edit,
                );
              }),
              Builder(builder: (BuildContext context) {
                // ignore: unused_local_variable
                final blocUserLogin =
                    Provider.of<BlocUserLogin>(context, listen: true);
                // ignore: unused_local_variable

                return TruyenChiTietDetail2(
                  idtruyen: widget.idtruyen,
                  iduser: blocUserLogin.id,
                  edit: widget.edit,
                );
              }),

              // Nội dung của Tab 2
            ],
          ),
        ),
      );
    } else {
      return const Center(
          child: CircularProgressIndicator(
        color: ColorClass.fiveColor,
      ));
    }
  }
}
