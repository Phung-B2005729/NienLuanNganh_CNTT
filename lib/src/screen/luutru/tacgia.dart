import 'package:apparch/src/firebase/services/database_user.dart';
import 'package:apparch/src/helper/temple/app_theme.dart';
import 'package:flutter/material.dart';

class TacGia extends StatefulWidget {
  final String? idtacgia;
  const TacGia(this.idtacgia, {super.key});

  @override
  State<TacGia> createState() => _TacGiaState();
}

class _TacGiaState extends State<TacGia> {
  String? username;
  String? avata = null;
  @override
  void initState() {
    super.initState();
    gettingTacGia();
  }

  gettingTacGia() async {
    await DatabaseUser(uid: widget.idtacgia).gettingUserIDData().then((value) {
      if (mounted) {
        setState(() {
          username = value.docs[0]['username'];

          avata = value.docs[0]['avata'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            // ignore: unnecessary_null_comparison

            backgroundImage: (avata != null && avata!.isNotEmpty)
                ? NetworkImage(avata!)
                : null,
            radius: 13,
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
    );
  }
}
