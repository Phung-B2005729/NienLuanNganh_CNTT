// ignore: file_names
// ignore: file_names, camel_case_types
class chitiettheloaiModel {
  // ignore: non_constant_identifier_names
  late int id_loai;
  // ignore: non_constant_identifier_names
  late int id_truyen;
  // ignore: non_constant_identifier_names
  chitiettheloaiModel({required this.id_loai, required this.id_truyen});
  //
  chitiettheloaiModel.fromMap(Map<String, dynamic> map) {
    id_loai = map['id_loai'];
    id_truyen = map['id_truyen'];
  }
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id_loai': id_loai,
      'id_truyen': id_truyen,
    };
    return map;
  }
}
