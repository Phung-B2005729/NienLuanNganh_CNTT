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
}
