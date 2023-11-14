import 'package:apparch/src/helper/temple/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../bloc/bloc_userlogin.dart';
import '../thongtincanhan.dart/ca_nhan.dart';

// ignore: use_key_in_widget_constructors
class UserAppbarAction extends StatelessWidget {
  //const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      final blocUserLogin = Provider.of<BlocUserLogin>(context, listen: true);
      return Padding(
        padding: const EdgeInsets.only(right: 18),
        child: Builder(
            builder: (context) => InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          blocUserLogin.userName,
                          style: AppTheme.lightTextTheme.bodyMedium,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        CircleAvatar(
                          backgroundColor:
                              const Color.fromARGB(255, 235, 232, 232),
                          radius: 18,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(blocUserLogin.avata),
                            radius: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CaNhan()));
                  },
                )),
      );
    });
  }
}
