import 'package:apparch/src/firebase/services/database_thongbao.dart';
import 'package:apparch/src/model/thongbao_model.dart';
import 'package:flutter/foundation.dart';

class BlocThongBao with ChangeNotifier {
  List<ThongBaoModel> _allThongBao = [];
  // ignore: unused_field

  Future<void> getAllThongBao() async {
    _allThongBao = (await DatabaseThongBao().getALLthongbao());
    notifyListeners();
  }

  Future<void> addThongBao(ThongBaoModel thongBaoModel) async {
    final newThongBao = await DatabaseThongBao().createthongbao(thongBaoModel);
    // ignore: unnecessary_null_comparison
    if (newThongBao != null) {
      _allThongBao.add(newThongBao);
      notifyListeners();
    }
  }

  int get allThongBaoCount {
    return _allThongBao.length;
  }

  List<ThongBaoModel> get allThongBao {
    return [
      ..._allThongBao
    ]; // tạo danh sách mới sao chép các phần tử của item vào
  }

  ThongBaoModel? findById(String id) {
    // tìm kiếm  theo id
    try {
      return _allThongBao.firstWhere((element) => element.id == id);
    } catch (e) {
      return null;
    }
  }

  List<ThongBaoModel> getDSThongBaoIdUser(String iduser) {
    return _allThongBao
        .where((thongBao) => kiemTraIdUser(thongBao.danhsachiduser, iduser))
        .toList();
  }

  int getConutThongBaoMoi(String iduser) {
    List<ThongBaoModel> list = _allThongBao
        .where((thongBao) =>
            kiemTraIdUser(thongBao.danhsachiduser, iduser) == true &&
            kiemTraIdUser(thongBao.danhsachiduserdadoc, iduser) == false)
        .toList();
    return list.length;
  }

  int getConutThongBaoMoiIdTruyen(String iduser, String idtruyen) {
    List<ThongBaoModel> list = _allThongBao
        .where((thongBao) =>
            kiemTraIdUser(thongBao.danhsachiduser, iduser) == true &&
            kiemTraIdUser(thongBao.danhsachiduserdadoc, iduser) == false &&
            thongBao.idtruyen == idtruyen)
        .toList();
    return list.length;
  }

  Future<void> addIduserDanhSachUser(
      // ignore: non_constant_identifier_names
      String idThongBao,
      String Iduser) async {
    // tìm lớp trong _allThongBao
    final index = _allThongBao.indexWhere(
        (item) => item.id == idThongBao); // lấy vị trí của idThongBao
    if (index >= 0) {
      // có đề thi này trong danh sách;
      List danhsachiduser = _allThongBao[index].danhsachiduser;
      ThongBaoModel thongBaoModel = _allThongBao[index];
      if (kiemTraIdUser(danhsachiduser, Iduser) == false) {
        // thêm
        try {
          await DatabaseThongBao().insertDanhSachIdUser(idThongBao, Iduser);
          danhsachiduser.add(Iduser);
          thongBaoModel.copyWith(danhsachiduser: danhsachiduser);
          _allThongBao[index] = thongBaoModel;
          notifyListeners();
        } catch (e) {
          print('Lỗi ' + e.toString());
        }
      }
    }
  }

  Future<void> deleteIduserDanhSachUser(
      String idThongBao, String Iduser) async {
    // tìm lớp trong _allThongBao
    final index = _allThongBao.indexWhere(
        (item) => item.id == idThongBao); // lấy vị trí của idThongBao
    if (index >= 0) {
      // có  trong danh sách;
      List danhsachiduser = _allThongBao[index].danhsachiduser;
      ThongBaoModel thongBaoModel = _allThongBao[index];
      if (kiemTraIdUser(danhsachiduser, Iduser) == true) {
        // gọi xoá
        try {
          await DatabaseThongBao().deleteDanhSachIdUser(idThongBao, Iduser);
          danhsachiduser.remove(Iduser);
          thongBaoModel.copyWith(danhsachiduser: danhsachiduser);
          _allThongBao[index] = thongBaoModel;
          notifyListeners();
        } catch (e) {
          print('Lỗi ' + e.toString());
        }
      }
    }
  }

  bool kiemTraIdUser(List<dynamic> danhsachiduser, String iduser) {
    if (danhsachiduser.contains(iduser)) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> updateThongBao(ThongBaoModel thongBaoModel) async {
    final index = _allThongBao.indexWhere((item) =>
        item.id ==
        thongBaoModel.id); // tìm  có trong danh sách list<ThongBao> hay không ?
    if (index >= 0) {
      try {
        await DatabaseThongBao()
            .updateOnethongbao(thongBaoModel.id!, thongBaoModel);
        _allThongBao[index] = thongBaoModel; // update trong danh sách
        notifyListeners();
      } catch (e) {
        print('Lỗi ' + e.toString());
      }
    }
  }

  Future<void> deleteThongBao(String id) async {
    print("id " + id);
    final index = _allThongBao.indexWhere((item) => item.id == id);
    // ignore: unused_local_variable
    if (index >= 0) {
      print('gọi xoá ' + index.toString());
      try {
        await DatabaseThongBao().deleteOnethongbao(id);
        print('Đã xoá trong database');
        _allThongBao.removeAt(index);
        notifyListeners();
      } catch (e) {
        // ignore: prefer_interpolation_to_compose_strings
        print('Lỗi ' + e.toString());
      }
    }
  }

  Future<void> deleteAllThongBaoIdTruyen(String idchuong) async {
    // ignore: unused_local_variable
    List<ThongBaoModel> list =
        _allThongBao.where((item) => item.idchuong == idchuong).toList();
    // ignore: unused_local_variable
    if (list != [] && list.isNotEmpty) {
      for (var i = 0; i < list.length; i++) {
        try {
          await DatabaseThongBao().deleteOnethongbao(list[i].id!);
          print('Đã xoá trong database');
          _allThongBao.remove(list[i]);
          notifyListeners();
        } catch (e) {
          // ignore: prefer_interpolation_to_compose_strings
          print('Lỗi ' + e.toString());
        }
      }
    }
  }

  Future<void> deleteAllThongBaoIdChuong(String idchuong) async {
    // ignore: unused_local_variable
    List<ThongBaoModel> list =
        _allThongBao.where((item) => item.idchuong == idchuong).toList();
    // ignore: unused_local_variable
    if (list != [] && list.isNotEmpty) {
      for (var i = 0; i < list.length; i++) {
        try {
          await DatabaseThongBao().deleteOnethongbao(list[i].id!);
          print('Đã xoá trong database');
          _allThongBao.remove(list[i]);
          notifyListeners();
        } catch (e) {
          // ignore: prefer_interpolation_to_compose_strings
          print('Lỗi ' + e.toString());
        }
      }
    }
  }

  Future<void> addIduserDanhSachUserDaDoc(
      // ignore: non_constant_identifier_names
      String idThongBao,
      String Iduser) async {
    // tìm lớp trong _allThongBao
    final index = _allThongBao.indexWhere(
        (item) => item.id == idThongBao); // lấy vị trí của idThongBao
    if (index >= 0) {
      // có đề thi này trong danh sách;
      List danhsachiduserdadoc = _allThongBao[index].danhsachiduserdadoc;
      ThongBaoModel thongBaoModel = _allThongBao[index];
      if (kiemTraIdUser(danhsachiduserdadoc, Iduser) == false) {
        // thêm
        try {
          await DatabaseThongBao()
              .insertDanhSachIdUserDaDoc(idThongBao, Iduser);
          danhsachiduserdadoc.add(Iduser);
          thongBaoModel.copyWith(danhsachiduserdadoc: danhsachiduserdadoc);
          _allThongBao[index] = thongBaoModel;
          notifyListeners();
        } catch (e) {
          // ignore: prefer_interpolation_to_compose_strings
          print('Lỗi ' + e.toString());
        }
      }
    }
  }

  Future<void> deleteIduserDanhSachUserDaDoc(
      String idThongBao, String Iduser) async {
    // tìm lớp trong _allThongBao
    final index = _allThongBao.indexWhere(
        (item) => item.id == idThongBao); // lấy vị trí của idThongBao
    if (index >= 0) {
      // có  trong danh sách;
      List danhsachiduserdadoc = _allThongBao[index].danhsachiduserdadoc;
      ThongBaoModel thongBaoModel = _allThongBao[index];
      if (kiemTraIdUser(danhsachiduserdadoc, Iduser) == true) {
        // gọi xoá
        try {
          await DatabaseThongBao()
              .deleteDanhSachIdUserDaDoc(idThongBao, Iduser);
          danhsachiduserdadoc.remove(Iduser);
          thongBaoModel.copyWith(danhsachiduserdadoc: danhsachiduserdadoc);
          _allThongBao[index] = thongBaoModel;
          notifyListeners();
        } catch (e) {
          print('Lỗi ' + e.toString());
        }
      }
    }
  }
}
