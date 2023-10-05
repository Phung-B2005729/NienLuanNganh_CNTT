// ignore: file_names
// ignore: camel_case_types
import '../helper/date_time_function.dart';

class ChuongModel {
  // ignore: non_constant_identifier_names
  String? idchuong;
  String? tenchuong;
  String? noidung;
  DateTime? ngaycapnhat = DateTime.now();
  int? luotxem;
  int? binhchon;
  ChuongModel(
      {this.idchuong,
      this.tenchuong,
      this.noidung,
      this.binhchon,
      this.luotxem,
      this.ngaycapnhat});

  ChuongModel.fromMap(Map<String, dynamic> map) {
    idchuong = map['id_chuong'];
    tenchuong = map['tenchuong'];
    noidung = map['noidung'];
    ngaycapnhat = DatetimeFunction.getTimeToDateTime(map['ngaycapnhat']);
    luotxem = map['luotxem'];
    binhchon = map['binhchon'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'idchuong': idchuong,
      'tenchuong': tenchuong,
      'noidung': noidung,
      'ngaycapnhat': DatetimeFunction.getTimeToInt(ngaycapnhat!),
      'binhchon': binhchon,
      'luotxem': luotxem
    };
    return map;
  }
}
