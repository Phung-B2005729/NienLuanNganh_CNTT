import 'package:apparch/src/firebase/services/database_binhluan.dart';
import 'package:apparch/src/model/binhluan_model.dart';
import 'package:flutter/foundation.dart';

class BlocBinhLuan with ChangeNotifier {
  List<BinhLuanModel> _allBinhLuan = [];
  // ignore: unused_field

  Future<void> getAllBinhLuan() async {
    _allBinhLuan = (await DatabaseBinhLuan().getALLBinhLuan());
    notifyListeners();
  }

  Future<void> addBinhLuan(BinhLuanModel binhLuanModel) async {
    final newBinhLuan = await DatabaseBinhLuan().createBinhLuan(binhLuanModel);
    // ignore: unnecessary_null_comparison
    if (newBinhLuan != null) {
      _allBinhLuan.add(newBinhLuan);
      notifyListeners();
    }
  }

  int get allBinhLuanCount {
    return _allBinhLuan.length;
  }

  List<BinhLuanModel> get allBinhLuan {
    return [
      ..._allBinhLuan
    ]; // tạo danh sách mới sao chép các phần tử của item vào
  }

  BinhLuanModel? findById(String id) {
    // tìm kiếm  theo id
    try {
      return _allBinhLuan.firstWhere((element) => element.id == id);
    } catch (e) {
      return null;
    }
  }

  List<BinhLuanModel> getDSBinhLuanIdUser(String iduser) {
    return _allBinhLuan.where((binhLuan) => binhLuan.iduser == iduser).toList();
  }

  List<BinhLuanModel> getDSBinhLuanIdChuong(String idchuong) {
    return _allBinhLuan
        .where((binhLuan) =>
            binhLuan.idchuong == idchuong && binhLuan.idreply == '0')
        .toList();
  }

  List<BinhLuanModel> getDSBinhLuanIdReply(String idreply) {
    return _allBinhLuan
        .where((binhLuan) => binhLuan.idreply == idreply)
        .toList();
  }

  Future<void> updateBinhLuan(BinhLuanModel binhLuanModel) async {
    final index = _allBinhLuan.indexWhere((item) =>
        item.id ==
        binhLuanModel.id); // tìm  có trong danh sách list<BinhLuan> hay không ?
    if (index >= 0) {
      try {
        await DatabaseBinhLuan()
            .updateOneBinhLuan(binhLuanModel.id!, binhLuanModel);
        _allBinhLuan[index] = binhLuanModel; // update trong danh sách
        notifyListeners();
      } catch (e) {
        print('Lỗi ' + e.toString());
      }
    }
  }

  Future<void> deleteBinhLuan(String id) async {
    print("id " + id);
    final index = _allBinhLuan.indexWhere((item) => item.id == id);
    // ignore: unused_local_variable
    if (index >= 0) {
      print('gọi xoá ' + index.toString());
      try {
        await DatabaseBinhLuan().deleteOneBinhLuan(id);
        print('Đã xoá trong database');
        _allBinhLuan.removeAt(index);
        notifyListeners();
      } catch (e) {
        // ignore: prefer_interpolation_to_compose_strings
        print('Lỗi ' + e.toString());
      }
    }
  }

  Future<void> deleteBinhLuanidreply(String idreply) async {
    List<BinhLuanModel> listbinhluan = getDSBinhLuanIdReply(idreply);

    for (var i = 0; i < listbinhluan.length; i++) {
      deleteBinhLuan(listbinhluan[i].id!);
    }
  }

  Future<void> deleteAllBinhLuanIdTruyen(String idtruyen) async {
    // ignore: unused_local_variable
    List<BinhLuanModel> list =
        _allBinhLuan.where((item) => item.idtruyen == idtruyen).toList();
    // ignore: unused_local_variable
    if (list != [] && list.isNotEmpty) {
      for (var i = 0; i < list.length; i++) {
        try {
          await DatabaseBinhLuan().deleteOneBinhLuan(list[i].id!);
          print('Đã xoá trong database');
          _allBinhLuan.remove(list[i]);
          notifyListeners();
        } catch (e) {
          // ignore: prefer_interpolation_to_compose_strings
          print('Lỗi ' + e.toString());
        }
      }
    }
  }

  Future<void> deleteAllBinhLuanIdChuong(String idchuong) async {
    // ignore: unused_local_variable
    List<BinhLuanModel> list =
        _allBinhLuan.where((item) => item.idchuong == idchuong).toList();
    // ignore: unused_local_variable
    if (list != [] && list.isNotEmpty) {
      for (var i = 0; i < list.length; i++) {
        try {
          await DatabaseBinhLuan().deleteOneBinhLuan(list[i].id!);
          print('Đã xoá trong database');
          _allBinhLuan.remove(list[i]);
          notifyListeners();
        } catch (e) {
          // ignore: prefer_interpolation_to_compose_strings
          print('Lỗi ' + e.toString());
        }
      }
    }
  }
}
