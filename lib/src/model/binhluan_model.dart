class BinhLuanModel {
  // ignore: non_constant_identifier_names
  String? id;
  String idchuong;
  String iduser;
  String idtruyen;
  String noidung;
  String ngaycapnhat;
  String idreply;
  bool xemthem;

  BinhLuanModel(
      {this.id,
      required this.idchuong,
      required this.iduser,
      required this.idtruyen,
      required this.noidung,
      required this.idreply,
      required this.ngaycapnhat,
      bool? xemthem})
      : xemthem = xemthem ?? false;

  BinhLuanModel copyWith({
    String? id,
    String? idchuong,
    String? iduser,
    String? idtruyen,
    String? ngaycapnhat,
    String? noidung,
    String? idreply,
    bool? xemthem,
  }) {
    return BinhLuanModel(
        id: id ?? this.id,
        idchuong: idchuong ?? this.idchuong,
        iduser: iduser ?? this.iduser,
        idtruyen: idtruyen ?? this.idtruyen,
        noidung: noidung ?? this.noidung,
        ngaycapnhat: ngaycapnhat ?? this.ngaycapnhat,
        idreply: idreply ?? this.idreply,
        xemthem: xemthem ?? this.xemthem);
  }

  static BinhLuanModel fromJson(Map<String, dynamic> map) {
    return BinhLuanModel(
      id: map['id'],
      idchuong: map['idchuong'],
      ngaycapnhat: map['ngaycapnhat'],
      noidung: map['noidung'],
      idtruyen: map['idtruyen'],
      iduser: map['iduser'],
      idreply: map['idreply'],
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'idchuong': idchuong,
      'iduser': iduser,
      'ngaycapnhat': ngaycapnhat,
      'idtruyen': idtruyen,
      'noidung': noidung,
      'idreply': idreply,
    };
    return map;
  }
}
