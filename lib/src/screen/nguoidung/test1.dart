//import 'package:archapp/comp/temple/color.dart';
import 'package:apparch/src/firebase/fire_base_auth.dart';
import 'package:flutter/material.dart';
import '../../helper/helper_function.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CaNhan extends StatefulWidget {
  @override
  State<CaNhan> createState() => _CaNhanState();
}

class _CaNhanState extends State<CaNhan> {
  String userName = "";
  String avata = "";
  FirAuth firAuth = FirAuth();
  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    await HelperFunctions.getAvata().then((value) {
      setState(() {
        avata = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((val) {
      setState(() {
        userName = val!;
      });
    });
    // getting the list of snapshots in our stream
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () {
                // trang thay đổi thông tin
              },
              icon: const Icon(Icons.brightness_7_outlined))
        ],
      ),
      body: const Center(child: Text("trang ca nhan")),
    );
  }
}
