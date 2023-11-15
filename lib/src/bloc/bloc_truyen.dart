import 'package:apparch/src/firebase/services/database_truyen.dart';
import 'package:apparch/src/model/truyen_model.dart';
import 'package:flutter/foundation.dart';

class BlocTruyen with ChangeNotifier {
  List<TruyenModel> _allTruyen = [];
  // ignore: unused_field

  Future<void> getAllTruyen() async {
    _allTruyen = await DatabaseTruyen().getALLTruyenModel();
    notifyListeners();
  }

  int get allTruyenCount {
    return _allTruyen.length;
  }

  List<TruyenModel> get allTruyen {
    return [
      ..._allTruyen
    ]; // tạo danh sách mới sao chép các phần tử của item vào
  }

  TruyenModel? findById(String id) {
    // tìm kiếm  theo id
    try {
      return _allTruyen.firstWhere((element) => element.idtruyen == id);
    } catch (e) {
      return null;
    }
  }
}
