import 'package:apparch/src/bloc/bloc_timkiem.dart';
import 'package:apparch/src/helper/temple/app_theme.dart';
import 'package:apparch/src/helper/temple/color.dart';
import 'package:apparch/src/screen/share/mgsDiaLog.dart';
import 'package:apparch/src/screen/timkiem/ds_nguoidung.dart';
import 'package:apparch/src/screen/timkiem/ds_tags.dart';
import 'package:apparch/src/screen/timkiem/ds_theloai.dart';
import 'package:apparch/src/screen/timkiem/ds_truyen_timkiem.dart';
import 'package:apparch/src/screen/timkiem/lich_su_timkiem_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class TimKiemScreen extends StatefulWidget {
  TimKiemScreen({super.key});

  @override
  State<TimKiemScreen> createState() => _TimKiemScreenState();
}

class _TimKiemScreenState extends State<TimKiemScreen>
    with SingleTickerProviderStateMixin {
  //final _Controller = TextEditingController();
  final _nameController = TextEditingController();
  final _nameFouces = FocusNode();
  bool ontap = false;
  bool onchange = false;
  bool onsubmit = false;
  late TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<BlocTimKiem>().getData();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  forceElevated: innerBoxIsScrolled,
                  //  toolbarHeight: 80,
                  backgroundColor: ColorClass.xanh3Color,
                  shadowColor: ColorClass.xanh1Color,
                  title: Text(
                    'Tìm Kiếm',
                    style: AppTheme.lightTextTheme.titleSmall,
                    textAlign: TextAlign.left,
                  ),
                  pinned: false,
                  floating: false,
                  snap: false,

                  expandedHeight: 20.0,
                ),
                SliverAppBar(
                    toolbarHeight: 80,
                    //    expandedHeight: 350.0,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(
                            10), // Điều này sẽ bo tròn góc dưới của SliverAppBar
                      ),
                    ),
                    snap: false,
                    floating: false,
                    // expandedHeight: 150.0,
                    pinned: true,
                    //  floating: false,
                    //  snap: false,
                    title: Container(
                      color: Colors.white,
                      height: 55,
                      child: TextField(
                        onTap: () {
                          // ignore: curly_braces_in_flow_control_structures
                          setState(() {
                            // mở danh sách lịch sử tìm kiếm
                            ontap = true;
                            onsubmit = false;
                            onchange = false;
                            // ignore: avoid_print, prefer_interpolation_to_compose_strings
                            print('Gọi ontap : ontap= ' +
                                ontap.toString() +
                                "onchang = " +
                                onchange.toString());
                          });
                          // ignore: prefer_is_empty
                          if (_nameController.text.length > 0) {
                            _nameFouces.nextFocus();
                            setState(() {
                              onchange = true;
                              onsubmit = false;
                              context
                                  .read<BlocTimKiem>()
                                  .updateDSTruyen(_nameController.text);
                            });
                            // ignore: avoid_print, prefer_interpolation_to_compose_strings
                            print('Gọi ontap : ontap= ' +
                                ontap.toString() +
                                "onchang = " +
                                onchange.toString() +
                                "onsubmit " +
                                onsubmit.toString());
                          }
                          // ignore: prefer_interpolation_to_compose_strings
                          print('Độ dài của textflie' +
                              _nameController.text.length.toString());
                        },
                        onSubmitted: (value) {
                          // ignore: unnecessary_null_comparison
                          if (value == null || value == '') {
                            MsgDialog.showSnackbar(context, Colors.black,
                                'Nhập vào nội dung tìm kiếm');
                            _nameFouces.requestFocus();
                          } else {
                            // lay gia tri tim hiem hien thi ra

                            // luu gia tri vao lich su tim kiem
                            context.read<BlocTimKiem>().updataList(value);
                            context.read<BlocTimKiem>().updateDStags(value);
                            setState(() {
                              onsubmit = true;
                              onchange = false;
                              ontap = false;
                              // ignore: avoid_print, prefer_interpolation_to_compose_strings
                              print('Gọi submit : ontap= ' +
                                  ontap.toString() +
                                  "onchang = " +
                                  onchange.toString());
                            });
                          }
                        },
                        onChanged: (value) {
                          if (value != '')
                            // ignore: curly_braces_in_flow_control_structures
                            context.read<BlocTimKiem>().updateDSTruyen(value);
                          // ignore: curly_braces_in_flow_control_structures
                          setState(() {
                            onchange = true;
                            onsubmit = false;
                            // ignore: prefer_interpolation_to_compose_strings
                            print('Gọi onchang : ontap= ' +
                                ontap.toString() +
                                "onchang = " +
                                onchange.toString());
                          });
                          if (value == '') {
                            setState(() {
                              ontap = true;
                              onchange = false;
                              onsubmit = false;
                              // ignore: prefer_interpolation_to_compose_strings
                              print('Gọi onchang : ontap= ' +
                                  ontap.toString() +
                                  "onchang = " +
                                  onchange.toString());
                            });
                          }
                          // mở danh sách gợi ý
                          // settast chay lai danh sach goi y
                        },
                        focusNode: _nameFouces,
                        controller: _nameController,
                        textAlign: TextAlign.left,
                        cursorColor: ColorClass.primaryColor,
                        maxLines: 1,
                        style: AppTheme.lightTextTheme.bodyMedium,
                        decoration: InputDecoration(
                            errorStyle: const TextStyle(fontSize: 12),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 71, 71, 71)),
                            ),
                            // Để chỉnh màu gạch ngang khi focus
                            hintText: 'Tìm kiếm....',
                            hintStyle: AppTheme.lightTextTheme.bodySmall,
                            suffixIcon: (ontap == true ||
                                    onsubmit == true ||
                                    onchange == true)
                                ? GestureDetector(
                                    onTap: () {
                                      _nameFouces.unfocus();
                                      setState(() {
                                        _nameController
                                            .clear(); // Xóa nội dung của trường tìm kiếm

                                        // Loại bỏ focus
                                        onsubmit = false;
                                        ontap = false;
                                        onchange = false;
                                      });
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      color: Color.fromARGB(255, 234, 38, 12),
                                      size: 25,
                                    ))
                                : null,
                            prefixIcon: (ontap == false)
                                ? const Icon(Icons.search,
                                    color: Color.fromARGB(255, 79, 79, 79))
                                : const Icon(Icons.search, color: Colors.black),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(color: Colors.black),
                            )),
                      ),
                    ),
                    bottom: (onsubmit == true)
                        ? PreferredSize(
                            preferredSize: const Size.fromHeight(40),
                            child: TabBar(
                              indicator: const UnderlineTabIndicator(
                                borderSide: BorderSide(
                                  width: 2,
                                  color: ColorClass.fiveColor,
                                ),
                                //   insets: EdgeInsets.symmetric(
                                //       horizontal: 20.0)
                              ),

                              labelStyle: AppTheme.lightTextTheme.bodyMedium,
                              labelColor: ColorClass.fiveColor,
                              unselectedLabelColor: Colors.black,
                              controller:
                                  _tabController, // Kết nối TabController với TabBar
                              tabs: const [
                                Tab(
                                  text: 'Truyện',
                                ),
                                Tab(
                                  text: 'Mọi người',
                                ),
                                Tab(
                                  text: 'tags',
                                ),
                              ],
                            ),
                          )
                        : null),
              ];
            },
            body: (onsubmit == true)
                ? TabBarView(
                    controller:
                        _tabController, // Kết nối TabController với TabBarView
                    children: <Widget>[
                      DsTruyenTimKiem(value: _nameController.text.toString()),
                      DsNguoiDung(value: _nameController.text.toString()),
                      const DsTags()
                      // Nội dung của Tab 2
                    ],
                  )
                : (onchange == true && _nameController.text != '')
                    ? truyenGoiY(context)
                    : (ontap == true)
                        ? LichSu(context)
                        : const DSTheLoai()));
  }

  // ignore: override_on_non_overriding_member
  Widget truyenGoiY(BuildContext context) {
    return Consumer<BlocTimKiem>(builder: (context, blocTimKiem, child) {
      return ListView(children: [
        if (blocTimKiem.dstentruyen != [] && blocTimKiem.dstentruyen.isNotEmpty)
          for (var i = 0; i < blocTimKiem.dstentruyen.length; i++)
            ListTile(
              onTap: () {
                setState(() {
                  _nameController.text = blocTimKiem.dstentruyen[i];
                  onsubmit = true;
                  onchange = false;
                  ontap = false;
                });
                context.read<BlocTimKiem>().updateDStags(_nameController.text);
                print('gọi tile');
              },
              leading: const Icon(Icons.search),
              title: Text(
                blocTimKiem.dstentruyen[i],
                style: AppTheme.lightTextTheme.bodyMedium,
              ),
            )
      ]);
    });
  }

  Widget LichSu(BuildContext context) {
    return Consumer<BlocTimKiem>(builder: (context, blocTimKiem, child) {
      return ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tìm kiếm gần đây',
                  style: AppTheme.lightTextTheme.bodyMedium,
                ),
                TextButton(
                    onPressed: () {
                      // qua hien thị tat va tim kiem
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => LichSuTimKiemSreen()))
                          .then((result) {
                        if (result != null) {
                          // Xử lý giá trị trả về ở đây
                          print('Giá trị trả về: $result');
                          context.read<BlocTimKiem>().updataList(result);
                          context.read<BlocTimKiem>().updateDStags(result);
                          _nameController.text = result;
                          setState(() {
                            onsubmit = true;
                          });
                        }
                      });
                    },
                    child: const Text(
                      'Xem tất cả',
                      style: TextStyle(
                          color: Color.fromARGB(255, 16, 73, 217),
                          fontSize: 16),
                    ))
              ],
            ),
          ),
          if (blocTimKiem.lichSuTimKiem != [] &&
              // ignore: prefer_is_empty
              blocTimKiem.lichSuTimKiem.length != 0)
            for (var i = 0; i < blocTimKiem.lichSuTimKiem.length; i++)
              ListTile(
                onTap: () {
                  setState(() {
                    _nameController.text = blocTimKiem.lichSuTimKiem[i];
                    onsubmit = true;
                    onchange = false;
                    ontap = false;
                  });
                  context
                      .read<BlocTimKiem>()
                      .updateDStags(_nameController.text);
                  print('gọi tile');
                },
                leading: const Icon(Icons.search),
                trailing: GestureDetector(
                  onTap: () {
                    print('goi x');
                    blocTimKiem.deleteOneList(blocTimKiem.lichSuTimKiem[i]);
                  },
                  child: const Icon(Icons.close),
                ),
                title: Text(
                  blocTimKiem.lichSuTimKiem[i],
                  style: AppTheme.lightTextTheme.bodyMedium,
                ),
              )
        ],
      );
    });
  }
}
