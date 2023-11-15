import 'package:apparch/src/firebase/services/database_user.dart';
import 'package:apparch/src/model/user_model.dart';
import 'package:flutter/foundation.dart';

class BlocUser with ChangeNotifier {
  // ignore: unused_field
  List<UserModel> _user = [];
  // ignore: unused_field
  Future<void> getAllUser() async {
    _user = await DatabaseUser().getAllUserModel();
    notifyListeners();
  }

  List<UserModel> allUser() {
    return [..._user];
  }

  UserModel? findById(String id) {
    // tìm kiếm user theo id lớp
    try {
      return _user.firstWhere((element) => element.id == id);
    } catch (e) {
      return null;
    }
  }

  String? getFullName(String id) {
    // tìm kiếm user theo id lớp
    try {
      UserModel user = _user.firstWhere((element) => element.id == id);
      return user.fullName;
    } catch (e) {
      return null;
    }
  }

 /* Future<void> deleteDanhSachThongBaoByidthongbao(String idthongbao) async {
    // liệt kê các user
    // nếu có idlớp thì xoá
    UserModel userModel;
    for (int index = 0; index < _user.length; index++) {
      if (kiemTrathongbao(_user[index].danhsachthongbao, idthongbao) == true) {
        // coa danh sách;
        // nếu có idlớp thì xoá
        try {
          await DatabaseUser().deleteDSThongBao(idthongbao, _user[index].id!);
          userModel = _user[index];
          userModel.danhsachthongbao.remove(idthongbao);
          _user[index] = userModel;
          notifyListeners();
        } catch (e) {
          print('Lỗi' + e.toString());
        }
      }
    }
  }

  // thêm lớp mới vào danh sách lớp của user
  Future<void> addDSThongBaoLop(String idthongbao, String iduser) async {
    UserModel userModel;
    for (int index = 0; index < _user.length; index++) {
      if (kiemTrathongbao(_user[index].danhsachthongbao, idthongbao) == false) {
        try {
          await DatabaseUser().insertDSThongBao(idthongbao, _user[index].id!);
          userModel = _user[index];
          userModel.danhsachthongbao.add(idthongbao);
          _user[index] = userModel;
          notifyListeners();
        } catch (e) {
          print('Lỗi' + e.toString());
        }
      }
    }
  }

  bool kiemTrathongbao(List danhsachthongbao, String idthongbao) {
    if (danhsachthongbao.contains(idthongbao)) {
      return true;
    } else {
      return false;
    }
  } */
}
