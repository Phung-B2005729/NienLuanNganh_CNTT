class UserModel {
  final String? id;
  final String? fullName;
  final String email;
  final String userName;
  final String? ngaysinh;
  final String avata;

  UserModel(
      {this.id,
      required this.avata,
      this.fullName,
      required this.email,
      required this.userName,
      this.ngaysinh});

  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? userName,
    String? avata,
    String? ngaysinh,
    // String? lichsutimkiem
  }) {
    return UserModel(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
        userName: userName ?? this.userName,
        avata: avata ?? this.avata,
        ngaysinh: ngaysinh ?? this.ngaysinh);
  }

  Map<String, dynamic> tomap() {
    return {
      "uid": id,
      "fullname": fullName,
      "username": userName,
      "email": email,
      "avata": avata,
      "ngaysinh": ngaysinh,
    };
  }

  static UserModel fromJson(Map<String, dynamic> map) {
    return UserModel(
        id: map['uid'],
        email: map['email'],
        fullName: map['fullname'],
        userName: map['username'],
        avata: map['avata'],
        ngaysinh: map['ngaysinh']);
  }
}
