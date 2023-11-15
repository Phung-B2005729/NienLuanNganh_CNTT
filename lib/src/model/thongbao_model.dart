class ThongBaoModel {
  // ignore: non_constant_identifier_names
  String? id;
  String idchuong;
  String idtacgia;
  String idtruyen;
  List<dynamic> danhsachiduser;
  List<dynamic> danhsachiduserdadoc;
  String ngaycapnhat;
  ThongBaoModel(
      {this.id,
      required this.idchuong,
      required this.idtacgia,
      required this.danhsachiduser,
      required this.idtruyen,
      required this.ngaycapnhat,
      List<dynamic>? danhsachiduserdadoc})
      : danhsachiduserdadoc = danhsachiduserdadoc ?? [];
  ThongBaoModel copyWith({
    String? id,
    String? idchuong,
    String? idtacgia,
    String? idtruyen,
    String? ngaycapnhat,
    List<dynamic>? danhsachiduser,
    List<dynamic>? danhsachiduserdadoc,
    // String? lichsutimkiem
  }) {
    return ThongBaoModel(
        id: id ?? this.id,
        idchuong: idchuong ?? this.idchuong,
        idtacgia: idtacgia ?? this.idtacgia,
        idtruyen: idtruyen ?? this.idtruyen,
        ngaycapnhat: ngaycapnhat ?? this.ngaycapnhat,
        danhsachiduser: danhsachiduser ?? this.danhsachiduser,
        danhsachiduserdadoc: danhsachiduserdadoc ?? this.danhsachiduserdadoc);
  }

  static ThongBaoModel fromJson(Map<String, dynamic> map) {
    return ThongBaoModel(
      id: map['id'],
      idchuong: map['idchuong'],
      danhsachiduser: map['danhsachiduser'],
      ngaycapnhat: map['ngaycapnhat'],
      idtruyen: map['idtruyen'],
      idtacgia: map['idtacgia'],
      danhsachiduserdadoc: map['danhsachiduserdadoc'],
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'idchuong': idchuong,
      'danhsachiduser': danhsachiduser,
      'ngaycapnhat': ngaycapnhat,
      'idtruyen': idtruyen,
      'idtacgia': idtacgia,
      'danhsachiduserdadoc': danhsachiduserdadoc
    };
    return map;
  }
}
