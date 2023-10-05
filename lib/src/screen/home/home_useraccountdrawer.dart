import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../bloc/bloc_userlogin.dart';
import '../../helper/temple/Color.dart';
import '../pages/ca_nhan.dart';

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
      accountEmail: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            width: 10,
          ),
          InkWell(
            child: const Column(
              children: [
                Text(
                  'Đang theo dõi',
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                ),
                Center(
                    child: Text('số lượng',
                        style: TextStyle(fontSize: 14.0, color: Colors.black))),
              ],
            ),
            onTap: () {},
          ),
          const SizedBox(
            width: 20,
          ),
          InkWell(
            child: const Column(
              children: [
                Text(
                  'Người theo dõi',
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                ),
                Center(
                    child: Text('số lượng',
                        style: TextStyle(fontSize: 14.0, color: Colors.black))),
              ],
            ),
            onTap: () {},
          ),
        ],
      ),
      currentAccountPictureSize: const Size(60, 60),
      currentAccountPicture: Builder(builder: (BuildContext context) {
        final blocUserLogin = Provider.of<BlocUserLogin>(context);
        return InkWell(
          child: CircleAvatar(
            // backgroundColor: color.fiveColor,
            // ignore: unnecessary_null_comparison
            backgroundImage:
                // ignore: unnecessary_null_comparison
                blocUserLogin.avata != null && blocUserLogin.avata.isNotEmpty
                    // ignore: prefer_interpolation_to_compose_strings
                    ? AssetImage('assets/images/' + blocUserLogin.avata)
                    : const AssetImage('assets/images/avatarmacdinh.png'),
            radius: 20,
          ),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => CaNhan()));
          },
        );
      }),
      decoration: const BoxDecoration(color: ColorClass.xanh3Color),
    );
  }
}
