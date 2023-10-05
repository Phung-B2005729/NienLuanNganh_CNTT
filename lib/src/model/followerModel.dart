// ignore_for_file: file_names

class FollowerModel {
  // ignore: non_constant_identifier_names
  late int id_flo;
  // ignore: non_constant_identifier_names
  late DateTime ngayflo;
  // ignore: non_constant_identifier_names
  late int id_nguoitheodoi;
  // ignore: non_constant_identifier_names
  late int id_duoctheodoi;
  // khoi tao
  FollowerModel(
      {
      // ignore: non_constant_identifier_names
      required this.id_flo,
      required this.ngayflo,
      // ignore: non_constant_identifier_names
      required this.id_nguoitheodoi,
      // ignore: non_constant_identifier_names
      required this.id_duoctheodoi
      // ignore: non_constant_identifier_names
      });

  FollowerModel.fromMap(Map<String, dynamic> map) {
    id_flo = map['id_flo'];
    ngayflo = DateTime.parse(map['ngayflo']);
    id_nguoitheodoi = map['id_nguoitheodoi'];
    id_duoctheodoi = map['id_duoctheodoi'];
  }
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      // 'id_flo': id_flo,
      'ngayflo': ngayflo.toIso8601String(),
      'id_nguoitheodoi': id_nguoitheodoi,
      'id_duoctheodoi': id_duoctheodoi
    };
    return map;
  }
}
