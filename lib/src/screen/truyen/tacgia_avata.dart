// ignore: unused_import
import 'package:apparch/src/helper/temple/app_theme.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../firebase/services/database_user.dart';

class TacGiaAvata extends StatefulWidget {
  final String? idtacgia;
  const TacGiaAvata(this.idtacgia, {super.key});

  @override
  State<TacGiaAvata> createState() => _TacGiaAvataState();
}

class _TacGiaAvataState extends State<TacGiaAvata> {
  String? username;
  String? avata;
  @override
  void initState() {
    super.initState();
    gettingTacGia();
  }

  gettingTacGia() async {
    DatabaseUser(uid: widget.idtacgia).gettingUserIDData().then((value) {
      setState(() {
        username = value.docs[0]['username'];
        print(username);
        avata = value.docs[0]['avata'];
        print(avata);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // chuyen sang thong tin tac gia
        /*  Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CaNhan(),
          ), //final arguments = ModalRoute.of(context)!.settings.arguments;
        ); */
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              // ignore: unnecessary_null_comparison
              backgroundImage: avata != null && avata!.isNotEmpty
                  // ignore: prefer_interpolation_to_compose_strings
                  ? AssetImage("assets/images/" + avata!)
                  : const AssetImage('assets/images/avatarmacdinh.png'),
              radius: 20,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              username != null ? username! : '',
              style: AppTheme.lightTextTheme.bodyMedium,
            ) // ten tac gia
          ],
        ),
      ),
    );
  }
}
