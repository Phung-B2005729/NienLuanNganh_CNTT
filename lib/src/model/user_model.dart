// ignore_for_file: file_names

class UserModel {
  // ignore: non_constant_identifier_names
  late String id_user;
  // ignore: non_constant_identifier_names
  late String user_name;
  late DateTime? ngaysinh;
  late String trangthai;
  late String email;
  UserModel(
      // ignore: non_constant_identifier_names
      {required this.id_user,
      // ignore: non_constant_identifier_names
      required this.user_name,
      required this.email,
      // ignore: avoid_init_to_null
      this.ngaysinh = null,
      this.trangthai = '0'
      // ignore: avoid_init_to_null
      });

  Map<String, dynamic> toMap() {
    String? tamngaysinh;
    if (ngaysinh != null) {
      tamngaysinh = ngaysinh!.toIso8601String();
    } else {
      tamngaysinh = null;
    }
    var map = <String, dynamic>{
      'id_user': id_user,
      'user_name': user_name,
      'email': email,
      'ngaysinh': tamngaysinh,
      'trangthai': trangthai
      // chuyen datatime về chuỗi
    };
    return map;
  }

  UserModel.fromMap(Map<String, dynamic> map) {
    id_user = map['id_user'];
    user_name = map['user_name'];
    email = map['email'];
    ngaysinh =
        map['ngaysinh'] != null ? DateTime.tryParse(map['ngaysinh']) : null;
    // Chuyển đổi ngày từ chuỗi sang DateTime

    trangthai = map['trangthai'];
  }
}
