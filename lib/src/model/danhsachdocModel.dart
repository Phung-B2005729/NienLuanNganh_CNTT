// ignore: file_names
// ignore: camel_case_types
class danhsachdocModel {
  // ignore: non_constant_identifier_names
  late int id_danhsach;
  // ignore: non_constant_identifier_names
  late int id_user;
  late String tendanhsach;
  late int sotruyen;
  danhsachdocModel(
      // ignore: non_constant_identifier_names
      {required this.id_danhsach,
      // ignore: non_constant_identifier_names
      required this.id_user,
      required this.tendanhsach,
      this.sotruyen = 0});
  danhsachdocModel.fromMap(Map<String, dynamic> map) {
    id_danhsach = map['id_danhsach'];
    id_user = map['id_user'];
    tendanhsach = map['tendanhsach'];
    sotruyen = map['sotruyen'];
  }
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      //'id_danhsach': id_danhsach,
      'id_user': id_user,
      'tendanhsach': tendanhsach,
      'sotruyen': sotruyen
    };
    return map;
  }
}
