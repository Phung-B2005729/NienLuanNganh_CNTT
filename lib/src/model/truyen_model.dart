import '../helper/date_time_function.dart';

class TruyenModel {
  String? idtruyen;
  String? tacgia;
  String? tentruyen;
  String? mota;
  DateTime? ngaycapnhat = DateTime.now();
  int? tongluotxem;
  int? tongbinhchon;
  String? tinhtrang;
  String? linkanh;
  List<String>? danhsachdocgia;
  List<String>? tags;
  List<String>? theloai;
  TruyenModel(
      {this.idtruyen,
      this.tacgia,
      this.tentruyen,
      this.mota,
      this.ngaycapnhat,
      this.tongbinhchon = 0,
      this.tongluotxem = 0,
      this.linkanh,
      this.tinhtrang = 'Trưởng thành',
      this.danhsachdocgia,
      this.tags = const [],
      this.theloai});

  TruyenModel.fromMap(Map<String, dynamic> map) {
    idtruyen = map['idtruyen'];
    tacgia = map['tacgia'];
    tentruyen = map['tentruyen'];
    mota = map['mota'];
    ngaycapnhat = DatetimeFunction.getTimeToDateTime(map['ngaycapnhat']);
    tongbinhchon = map['tongbinhchon'];
    tongluotxem = map['tongluotxem'];
    linkanh = map['linkanh'];
    tinhtrang = map['tinhtrang'];
    danhsachdocgia = map['danhsachdoc'];
    tags = map['tags']; //.cast<String>();
    theloai = map['theloai'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'idtruyen': idtruyen,
      'tacgia': tacgia,
      'tentruyen': tentruyen,
      'mota': mota,
      'ngaycapnhat': DatetimeFunction.getTimeToInt(ngaycapnhat!),
      'tongbinhchon': tongbinhchon,
      'tongluotxem': tongluotxem,
      'linkanh': linkanh,
      'tinhtrang': tinhtrang,
      'danhsachdoc': danhsachdocgia,
      'tags': tags,
      'theloai': theloai
    };
    return map;
  }
}
