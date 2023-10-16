import 'package:apparch/src/helper/temple/app_theme.dart';
import 'package:apparch/src/screen/home/home_page.dart';
import 'package:apparch/src/screen/luutru/luu_tru_screen.dart';
import 'package:apparch/src/screen/thongbao/thong_bao_screen.dart';
import 'package:apparch/src/screen/timkiem/tim_kiem_screen.dart';
import 'package:apparch/src/screen/viettruyen/viet_truyen_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore: camel_case_types
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// ignore: camel_case_types
class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = [
    const HomePages(),
    TimKiemScreen(),
    const LuuTruScreen(),
    const VietTruyenScreen(),
    const ThongBaoScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: false,
        selectedLabelStyle: AppTheme.lightTextTheme.headlineSmall,
        backgroundColor: const Color.fromARGB(255, 129, 127, 127),
        // iconSize: 22,
        type: BottomNavigationBarType.shifting,
        //  selectedFontSize: 14.0,
        //selectedIconTheme: const IconThemeData(size: 24.0),
        unselectedItemColor: const Color.fromARGB(255, 63, 63, 63),
        //   selectedItemColor: ColorClass.fiveColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Tìm kiếm'),
          BottomNavigationBarItem(
              icon: Icon(Icons.library_books_rounded), label: 'Lưu trữ'),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.pencil), label: 'Viết truyện'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Thông báo'),
        ],
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      ),
    );
  }
}
