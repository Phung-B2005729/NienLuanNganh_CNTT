import 'package:flutter/material.dart';
import '../helper/helper_function.dart';

class BlocUserLogin with ChangeNotifier {
  late String avata;
  late String id;
  late String userName;
  late bool isLogged = false;
  void getLoggedState() async {
    await HelperFunctions.getLoggedInStatus().then((value) {
      if (value != null) {
        isLogged = value;
      }
    });
    if (isLogged == true) {
      await HelperFunctions.getAvata().then((value) {
        if (value != null) {
          avata = value;
        }
      });
      await HelperFunctions.getUserNameFromSF().then((val) {
        if (val != null) {
          userName = val;
        }
      });
      await HelperFunctions.getUserID().then((value) {
        if (value != null) {
          id = value;
          print(id);
        }
      });

      notifyListeners();
    }
    notifyListeners();
  }

  //
  void ChangUserName(String username) {
    userName = username;
    HelperFunctions.saveUserNameSF(userName);
  }
}
