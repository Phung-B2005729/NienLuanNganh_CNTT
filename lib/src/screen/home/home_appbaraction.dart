import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../bloc/bloc_userlogin.dart';

class HomeAppBarAction extends StatelessWidget {
  //const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      final blocUserLogin = Provider.of<BlocUserLogin>(context, listen: true);
      return Padding(
        padding: const EdgeInsets.only(right: 18),
        child: Builder(
            builder: (context) => InkWell(
                  child: CircleAvatar(
                    backgroundColor: const Color.fromARGB(255, 235, 232, 232),
                    radius: 18,
                    child: CircleAvatar(
                      // ignore: unnecessary_null_comparison
                      backgroundImage: blocUserLogin.avata != null &&
                              blocUserLogin.avata.isNotEmpty
                          // ignore: prefer_interpolation_to_compose_strings
                          ? AssetImage('assets/images/' + blocUserLogin.avata)
                          : const AssetImage('assets/images/avatarmacdinh.png'),
                      radius: 16,
                    ),
                  ),
                  onTap: () => Scaffold.of(context).openEndDrawer(),
                )),
      );
    });
  }
}
