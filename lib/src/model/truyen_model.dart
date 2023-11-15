import '../helper/date_time_function.dart';

class TruyenModel {
  String? idtruyen;
  String tacgia;
  String tentruyen;
  String mota;
  DateTime ngaycapnhat;
  int? tongluotxem;
  int? tongbinhchon;
  String? tinhtrang;
  String? linkanh;
  List<dynamic>? danhsachdocgia;
  List<dynamic>? docgia;
  List<dynamic>? tags;
  String? theloai;
  TruyenModel(
      {this.idtruyen = '0',
      required this.tacgia,
      required this.tentruyen,
      required this.mota,
      required this.ngaycapnhat,
      this.tongbinhchon = 0,
      this.tongluotxem = 0,
      required this.linkanh,
      required this.tinhtrang,
      required this.danhsachdocgia,
      required this.docgia,
      required this.tags,
      required this.theloai});
  TruyenModel copyWith({
    String? idtruyen,
    String? tacgia,
    String? tentruyen,
    String? mota,
    DateTime? ngaycapnhat,
    int? tongluotxem,
    int? tongbinhchon,
    String? tinhtrang,
    String? linkanh,
    List<dynamic>? danhsachdocgia,
    List<dynamic>? docgia,
    List<dynamic>? tags,
    String? theloai,
  }) {
    return TruyenModel(
        idtruyen: idtruyen ?? this.idtruyen,
        tacgia: tacgia ?? this.tacgia,
        tentruyen: tentruyen ?? this.tentruyen,
        mota: mota ?? this.mota,
        ngaycapnhat: ngaycapnhat ?? this.ngaycapnhat,
        tongbinhchon: tongbinhchon ?? this.tongbinhchon,
        tongluotxem: tongluotxem ?? this.tongluotxem,
        linkanh: linkanh ?? this.linkanh,
        tinhtrang: tinhtrang ?? this.tinhtrang,
        danhsachdocgia: danhsachdocgia ?? this.danhsachdocgia,
        docgia: danhsachdocgia ?? this.docgia,
        tags: tags ?? this.tags,
        theloai: theloai ?? this.theloai);
  }

  static TruyenModel fromJson(Map<String, dynamic> map) {
    return TruyenModel(
      idtruyen: map['idtruyen'],
      tacgia: map['tacgia'],
      tentruyen: map['tentruyen'],
      mota: map['mota'],
      ngaycapnhat: map['ngaycapnhat'] != null
          ? DatetimeFunction.getTimeToDateTime(map['ngaycapnhat'])
          : DateTime.now(),
      tongbinhchon: map['tongbinhchon'],
      tongluotxem: map['tongluotxem'],
      linkanh: map['linkanh'],
      tinhtrang: map['tinhtrang'],
      danhsachdocgia: map['danhsachdocgia'],
      docgia: map['docgia'],
      tags: map['tags'],
      theloai: map['theloai'],
    );
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
      'danhsachdocgia': danhsachdocgia,
      'docgia': docgia,
      'tags': tags,
      'theloai': theloai
    };
    return map;
  }
}
