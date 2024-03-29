// ignore: file_names
// ignore: camel_case_types
import '../helper/date_time_function.dart';

class ChuongModel {
  String? idchuong;
  String? tenchuong;
  dynamic noidung;
  DateTime? ngaycapnhat;
  int? luotxem;
  int? binhchon;
  String? tinhtrang;
  ChuongModel(
      {this.idchuong = '0',
      required this.tenchuong,
      required this.noidung,
      this.binhchon = 0,
      this.luotxem = 0,
      required this.ngaycapnhat,
      required this.tinhtrang});

  static ChuongModel fromJson(Map<String, dynamic> map) {
    return ChuongModel(
      idchuong: map['idchuong'],
      tenchuong: map['tenchuong'],
      noidung: map['noidung'],
      ngaycapnhat: DatetimeFunction.getTimeToDateTime(map['ngaycapnhat']),
      luotxem: map['luotxem'],
      binhchon: map['binhchon'],
      tinhtrang: map['tinhtrang'],
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'idchuong': idchuong,
      'tenchuong': tenchuong,
      'noidung': noidung,
      'ngaycapnhat': DatetimeFunction.getTimeToInt(ngaycapnhat!),
      'binhchon': binhchon,
      'luotxem': luotxem,
      'tinhtrang': tinhtrang
    };
    return map;
  }
}
