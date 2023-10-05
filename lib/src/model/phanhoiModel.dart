// ignore: file_names
// ignore: camel_case_types
class phanhoiModel {
  // ignore: non_constant_identifier_names
  late int id_phanhoi;
  // ignore: non_constant_identifier_names
  late int phanhoi_id;
  // ignore: non_constant_identifier_names
  late int id_chuong;
  // ignore: non_constant_identifier_names
  late int id_user;
  late String noidungphanhoi;
  late DateTime thoigianphanhoi;
  //
  phanhoiModel(
      // ignore: non_constant_identifier_names
      {required this.id_phanhoi,
      // ignore: non_constant_identifier_names
      required this.id_user,
      // ignore: non_constant_identifier_names
      required this.id_chuong,
      // ignore: non_constant_identifier_names
      required this.phanhoi_id,
      required this.noidungphanhoi,
      required this.thoigianphanhoi});
  phanhoiModel.fromMap(Map<String, dynamic> map) {
    id_phanhoi = map['id_phanhoi'];
    id_user = map['id_user'];
    id_chuong = map['id_chuong'];
    phanhoi_id = map['phanhoi_id'];
    noidungphanhoi = map['noidungphanhoi'];
    thoigianphanhoi = DateTime.parse(map['thoigianphanhoi']);
  }
  //
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      // 'id_phanhoi': id_phanhoi,
      'id_user': id_user,
      'id_chuong': id_chuong,
      'phanhoi_id': phanhoi_id,
      'noidungphanhoi': noidungphanhoi,
      'thoigianphanhoi': thoigianphanhoi.toIso8601String()
    };
    return map;
  }
}
