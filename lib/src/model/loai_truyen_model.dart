// ignore: file_names
// ignore: camel_case_types
class loaitruyenModel {
  // ignore: non_constant_identifier_names
  late int id_loai;
  // ignore: non_constant_identifier_names
  late String tenloai;
  // khoi tao
  loaitruyenModel(
      // ignore: non_constant_identifier_names
      {required this.id_loai,
      // ignore: non_constant_identifier_names
      required this.tenloai});

  loaitruyenModel.fromMap(Map<String, dynamic> map) {
    id_loai = map['id_loai'];
    tenloai = map['tenloai'];
  }
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      // 'id_loai': id_loai,
      'tenloai': tenloai,
    };
    return map;
  }
}
