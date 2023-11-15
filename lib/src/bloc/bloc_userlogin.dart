// ignore_for_file: unnecessary_null_comparison

import 'package:apparch/src/firebase/services/database_user.dart';
import 'package:apparch/src/model/user_model.dart';
import 'package:flutter/material.dart';
import '../helper/helper_function.dart';

class BlocUserLogin with ChangeNotifier {
  late String avata;
  late String id;
  late String userName;
  late bool isLogged = false;
  late UserModel? userlogin;
 // late List<dynamic> danhsachthongbao = [];
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
      // ignore:
      if (id != null) {
        userlogin = (await DatabaseUser().getOneUser(id));
      }

      notifyListeners();
    }
    notifyListeners();
  }

  Future<void> getUserLogin() async {
    await HelperFunctions.getUserID().then((value) {
      if (value != null) {
        id = value;
        print(id);
      }
    });
    // da dang nhap
    if (id != null) {
      print('gọi userLogin $id');
      userlogin = await DatabaseUser().getOneUser(id);

      if (userlogin != null) {
        userName = userlogin!.userName; // lay fullname
        avata = userlogin!.avata; // lay phan quyen
       // danhsachthongbao = userlogin!.danhsachthongbao;
        print(userName);
        notifyListeners();
      }
      notifyListeners();
    }
  }

  Future<void> updateUser(UserModel userModel) async {
    try {
      if (userModel.id == id) {
        // update
        await DatabaseUser().updateOneUser(userModel.id!, userModel);
        userlogin = userModel;
        userName = userlogin!.userName; // lay fullname
      //  danhsachthongbao = userlogin!.danhsachthongbao;
        avata = userlogin!.avata; // lay phan quyen
        await HelperFunctions.saveEmailSF(userlogin!.email);
        await HelperFunctions.saveUserID(id);
        await HelperFunctions.saveUserNameSF(userlogin!.userName);
        await HelperFunctions.saveAvataSF(userlogin!.avata);

        notifyListeners();
      }
    } catch (e) {
      print("Lỗi $e");
    }
  }

 /* // thêm lớp mới vào danh sách lớp của user
  Future<void> addDSThongBaoLop(String idthongbao, String iduser) async {
    if (kiemTraLop(danhsachthongbao, idthongbao) == false) {
      // lớp chưa tham gia;
      // user chưa tham gia lớp này
      await DatabaseUser().insertDSThongBao(idthongbao, iduser);
      danhsachthongbao.add(idthongbao);
      userlogin!.copyWith(danhsachthongbao: danhsachthongbao);
      notifyListeners();
    }
  }

  Future<void> deleteDSThongBaoIdThongBao(
      String idthongbao, String iduser) async {
    if (kiemTraLop(danhsachthongbao, idthongbao) == true) {
      // có thông báo
      try {
        await DatabaseUser().deleteDSThongBao(idthongbao, iduser);
        danhsachthongbao.remove(idthongbao);
        userlogin!.copyWith(danhsachthongbao: danhsachthongbao);
        notifyListeners();
      } catch (e) {
        print('Lỗi $e');
      }
    }
  }

  bool kiemTraLop(List danhsachthongbao, String idthongbao) {
    if (danhsachthongbao.contains(idthongbao)) {
      return true;
    } else {
      return false;
    }
  } */
}
