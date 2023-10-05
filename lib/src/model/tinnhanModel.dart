// ignore: camel_case_types
class tinnhanModel {
  // ignore: non_constant_identifier_names
  late int id_tinnhan;
  // ignore: non_constant_identifier_names
  late int id_hopchat;
  // ignore: non_constant_identifier_names
  late int id_user; // nguoi gui
  late String noidunggui;
  late DateTime thoigiangui;
  late String tinhtrang;
  //
  tinnhanModel(
      // ignore: non_constant_identifier_names
      {required this.id_tinnhan,
      // ignore: non_constant_identifier_names
      required this.id_hopchat,
      // ignore: non_constant_identifier_names
      required this.id_user,
      required this.noidunggui,
      required this.thoigiangui,
      this.tinhtrang = 'Đã gửi'});
  //
  tinnhanModel.fromMap(Map<String, dynamic> map) {
    id_tinnhan = map['id_tinnhan'];
    id_hopchat = map['id_hopchat'];
    id_user = map['id_user'];
    noidunggui = map['noidunggui'];
    thoigiangui = DateTime.parse(map['thoigiangui']);
    tinhtrang = map['tinhtrang'];
  }
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      //   'id_tinnhan': id_tinnhan,
      'id_hopchat': id_hopchat,
      'id_user': id_user,
      'noidunggui': noidunggui,
      'thoigiangui': thoigiangui.toIso8601String(),
      'tinhtrang': tinhtrang
    };
    return map;
  }
}
