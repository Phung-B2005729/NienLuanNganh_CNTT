// ignore: file_names
// ignore: camel_case_types
class hopchatModel {
  // ignore: non_constant_identifier_names
  late int id_hopchat;
  // ignore: non_constant_identifier_names
  late int id_user1;
  // ignore: non_constant_identifier_names
  late int id_user2;
  late DateTime thoigianbatdau;
  //
  hopchatModel(
      // ignore: non_constant_identifier_names
      {required this.id_hopchat,
      // ignore: non_constant_identifier_names
      required this.id_user1,
      // ignore: non_constant_identifier_names
      required this.id_user2,
      required this.thoigianbatdau});
  //
  hopchatModel.fromMap(Map<String, dynamic> map) {
    id_hopchat = map['id_hopchat'];
    id_user1 = map['id_user1'];
    id_user2 = map['id_user2'];
    thoigianbatdau = DateTime.parse(map['thoigianbatdau']);
  }
  //
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      //  'id_hopchat': id_hopchat,
      'id_user1': id_user1,
      'id_user2': id_user2,
      'thoigianbatdau': thoigianbatdau
    };
    return map;
  }
}
