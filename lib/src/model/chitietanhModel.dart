// ignore: file_names
// ignore: file_names
// ignore: file_names
// ignore: file_names
// ignore: file_names
// ignore: file_names
// ignore: file_names
// ignore: file_names
// ignore: camel_case_types
class chitietanhModel {
  // ignore: non_constant_identifier_names
  late int id_user;
  // ignore: non_constant_identifier_names
  late int id_anh;
  late String vaitro;
  chitietanhModel(
      // ignore: non_constant_identifier_names
      {required this.id_anh,
      // ignore: non_constant_identifier_names
      required this.id_user,
      required this.vaitro});
  //
  chitietanhModel.fromMap(Map<String, dynamic> map) {
    id_anh = map['id_anh'];
    id_user = map['id_user'];
    vaitro = map['vaitro'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id_anh': id_anh,
      'id_user': id_user,
      'vaitro': vaitro,
    };
    return map;
  }
}
