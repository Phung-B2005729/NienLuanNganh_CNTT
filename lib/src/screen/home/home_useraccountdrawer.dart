import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../bloc/bloc_userlogin.dart';
import '../../helper/temple/Color.dart';
import '../nguoidung/ca_nhan.dart';

class HomeUserAccountsDrawerHeader extends StatelessWidget {
  const HomeUserAccountsDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    //  final blocUserLogin = Provider.of<BlocUserLogin>(context);
    return UserAccountsDrawerHeader(
      accountName: Builder(builder: (BuildContext context) {
        final blocUserLogin = Provider.of<BlocUserLogin>(context, listen: true);
        return Text(blocUserLogin.userName,
            style: const TextStyle(fontSize: 20.0, color: Colors.black));
      }),
      currentAccountPictureSize: const Size(60, 60),
      currentAccountPicture: Builder(builder: (BuildContext context) {
        final blocUserLogin = Provider.of<BlocUserLogin>(context);
        return InkWell(
          child: CircleAvatar(
            // backgroundColor: color.fiveColor,
            // ignore: unnecessary_null_comparison
            backgroundImage:
                // ignore: unnecessary_null_comparison
                NetworkImage(blocUserLogin.avata),
            radius: 20,
          ),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => CaNhan()));
          },
        );
      }),
      decoration: const BoxDecoration(color: ColorClass.xanh3Color),
      accountEmail: null,
    );
  }
}
