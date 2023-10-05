// ignore: file_names
// ignore: file_names, camel_case_types
class hinhanhModel {
  // ignore: non_constant_identifier_names
  late int id_anh;
  // ignore: non_constant_identifier_names
  late String linkanh;
  // khoi tao
  hinhanhModel(
      // ignore: non_constant_identifier_names
      {required this.id_anh,
      // ignore: non_constant_identifier_names
      required this.linkanh});

  hinhanhModel.fromMap(Map<String, dynamic> map) {
    id_anh = map['id_anh'];
    linkanh = map['linkanh'];
  }
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      //  'id_anh': id_anh,
      'linkanh': linkanh,
    };
    return map;
  }
}
