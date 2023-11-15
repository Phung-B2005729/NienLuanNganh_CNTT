// ignore_for_file: must_be_immutable, unused_field
import 'dart:io';

import 'package:apparch/src/bloc/bloc_userlogin.dart';
import 'package:apparch/src/firebase/fire_base_auth.dart';
import 'package:apparch/src/firebase/fire_base_storage.dart';
import 'package:apparch/src/helper/date_time_function.dart';
import 'package:apparch/src/helper/temple/app_theme.dart';
import 'package:apparch/src/helper/temple/color.dart';
import 'package:apparch/src/model/user_model.dart';
import 'package:apparch/src/screen/log_sign/login_form.dart';
import 'package:apparch/src/screen/share/loadingDialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CaNhan extends StatefulWidget {
  const CaNhan({super.key});

  @override
  State<CaNhan> createState() => _CaNhanState();
}

class _CaNhanState extends State<CaNhan> {
  late Future<void> userData;
  final firAuth = FirAuth();
  File? image;
  String imageName = '';
  String imageURL = '';

  @override
  void initState() {
    super.initState();
    userData = getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getData() async {
    await context.read<BlocUserLogin>().getUserLogin();
  }

  Future pickImage(UserModel userModel) async {
    print('goi ham imgae');
    try {
      LoadingDialog.showLoadingDialog(context, 'Loading....');
      final picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        image = File(pickedFile.path);
        imageName = pickedFile.name.toString();
        print(pickedFile.path);
        print(imageName);
        print(image);
      } else {
        print('No image selected.');
      }

      if (image != null) {
        // lay anh
        imageURL = await FireStorage().uploadImage(image!);
      }

      if (mounted) {
        // Check if the widget is still mounted
        UserModel user = userModel.copyWith(avata: imageURL);
        await context.read<BlocUserLogin>().updateUser(user);
        // ignore: use_build_context_synchronously
        LoadingDialog.hideLoadingDialog(context);
      }
    } catch (e) {
      // ignore: avoid_print, prefer_interpolation_to_compose_strings
      print('loi image  ' + e.toString());
      if (mounted) {
        LoadingDialog.hideLoadingDialog(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorClass.xanh3Color,
          title: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "Thông tin cá nhân",
              style: AppTheme.lightTextTheme.titleMedium,
            ),
          ),
        ),
        body: FutureBuilder(
            future: userData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Consumer<BlocUserLogin>(
                    builder: (context, blocUserLogin, child) {
                  final user = blocUserLogin.userlogin;
                  return ListView(
                    physics: ScrollPhysics(),
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: ListTile(
                          leading: CircleAvatar(
                            // ignore: unnecessary_null_comparison
                            backgroundImage: NetworkImage(user!.avata),
                            radius: 30,
                          ),
                          title: Text(
                            'avata',
                            style: AppTheme.lightTextTheme.bodyMedium,
                          ),
                          subtitle: Text(
                            'Nhấp vào để thay đổi',
                            style: AppTheme.lightTextTheme.bodySmall,
                          ),
                          onTap: () {
                            pickImage(user);
                          },
                        ),
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: ListTile(
                          title: Text(
                            'Họ tên',
                            style: AppTheme.lightTextTheme.headlineMedium,
                          ),
                          subtitle: Text(
                            user.fullName ?? '',
                            style: AppTheme.lightTextTheme.bodySmall,
                          ),
                          onTap: () {
                            // mở modal thay đổi tên
                            buildDiaLog(context, 'Họ tên', user);
                          },
                        ),
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: ListTile(
                          title: Text(
                            'UserName',
                            style: AppTheme.lightTextTheme.headlineMedium,
                          ),
                          subtitle: Text(
                            user.userName,
                            style: AppTheme.lightTextTheme.bodySmall,
                          ),
                          onTap: () async {
                            buildDiaLog(context, 'UserName', user);
                          },
                        ),
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: ListTile(
                          title: Text(
                            'Ngày sinh',
                            style: AppTheme.lightTextTheme.headlineMedium,
                          ),
                          subtitle: Text(
                            user.ngaysinh ?? '',
                            style: AppTheme.lightTextTheme.bodySmall,
                          ),
                          onTap: () async {
                            LoadingDialog.showLoadingDialog(
                                context, 'Loading..');
                            await _selectDate(
                                context, user.ngaysinh ?? '', user);
                            // ignore: use_build_context_synchronously
                            LoadingDialog.hideLoadingDialog(context);
                          },
                        ),
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: ListTile(
                          title: Text(
                            'Email',
                            style: AppTheme.lightTextTheme.headlineMedium,
                          ),
                          subtitle: Text(
                            user.email,
                            style: AppTheme.lightTextTheme.bodySmall,
                          ),
                          onTap: () async {
                            // mở modal thay đổi email
                            await buildDiaLogEmail(context, user);
                          },
                        ),
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: ListTile(
                              title: Text('Mật Khẩu',
                                  style:
                                      AppTheme.lightTextTheme.headlineMedium),
                              // ignore: prefer_const_constructors
                              subtitle: Text(
                                '..........',
                                style: AppTheme.lightTextTheme.headlineMedium,
                              ),
                              onTap: () async {
                                // mở modal thay đổi mật khẩu
                                try {
                                  await buildDiaLogMatKhau(context, user);
                                } catch (e) {
                                  print('Lỗi');
                                }
                              })),
                      const Divider(
                        color: Colors.black,
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: ListTile(
                            title: Row(
                              children: [
                                const Icon(Icons.exit_to_app),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text('Đăng xuất',
                                    style:
                                        AppTheme.lightTextTheme.headlineLarge),
                              ],
                            ),
                            onTap: () async {
                              firAuth.logOut();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginForm()),
                                  (Route<dynamic> route) => false);
                            },
                          )),
                    ],
                  );
                });
              }
              return const Center(
                child: CircularProgressIndicator(
                  color: ColorClass.xanh2Color,
                ),
              );
            }));
  }

  Future<dynamic> buildDiaLog(
      BuildContext context, String label, UserModel user) {
    String lableInput = '';
    final _formKey = new GlobalKey<FormState>();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Cập nhật ${label} mới',
              style: AppTheme.lightTextTheme.headlineLarge,
            ),
            content: Form(
              key: _formKey,
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isNotEmpty == false) {
                    return 'Bạn chưa nhập vào ${label}';
                  }
                  return null;
                },
                style: AppTheme.lightTextTheme.bodySmall,
                cursorColor: ColorClass.fiveColor,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => lableInput = value,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorClass.fiveColor),
                    ),
                    // Để chỉnh màu gạch ngang khi focus
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorClass.fiveColor),
                    ),
                    hintStyle: TextStyle(fontSize: 12, color: Colors.black)),
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Huỷ',
                    style: TextStyle(color: ColorClass.fiveColor),
                  )),
              TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // update

                      try {
                        LoadingDialog.showLoadingDialog(context, 'Loading...');
                        if (label == 'Họ tên') {
                          UserModel userModel =
                              user.copyWith(fullName: lableInput);
                          await context
                              .read<BlocUserLogin>()
                              .updateUser(userModel);
                        }
                        if (label == 'UserName') {
                          UserModel userModel =
                              user.copyWith(userName: lableInput);
                          // ignore: use_build_context_synchronously
                          await context
                              .read<BlocUserLogin>()
                              .updateUser(userModel);
                        }
                        // ignore: use_build_context_synchronously
                        LoadingDialog.hideLoadingDialog(context);
                        Navigator.pop(context);
                        // ignore: use_build_context_synchronously
                      } catch (e) {
                        print('gọi update lỗi' + e.toString());
                        LoadingDialog.hideLoadingDialog(context);
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: const Text('Thay đổi',
                      style: TextStyle(color: ColorClass.fiveColor))),
            ],
          );
        });
  }

  Future<void> _selectDate(
      BuildContext context, String ngaysinh, UserModel user) async {
    final DateTime seleted = await ngaysinh != '' // ngày đưa vào khách rỗng
        ? DatetimeFunction.getDateTimeFormString(
            ngaysinh) // chuyển về kiểm datetime
        : DateTime.now(); // lấy thời gian ngày hôm nay
    // set ngay thang
    // ignore: use_build_context_synchronously
    final DateTime? pickedDate = await showDatePicker(
      // mở modal chọn ngày tháng năm
      // mở ngày
      context: context,
      initialDate: seleted, // thời gian chọn
      firstDate: DateTime(1000), // bắt đầu
      lastDate: DateTime.now(), // kết thúc
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(), // chỉnh màu
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      // chọn được ngày

      final DateTime selectedDate = DateTime(
        pickedDate.year, // set lại datetime
        pickedDate.month,
        pickedDate.day,
      );
      String ngay = DatetimeFunction.getStringFormDateTime(
          selectedDate); // chuyển về kiểu String
      print('Ngày ' + ngay);
      // gọi update
      UserModel userModel = user.copyWith(ngaysinh: ngay);
      await context.read<BlocUserLogin>().updateUser(userModel);
    }
  }

  buildDiaLogEmail(BuildContext context, UserModel user) async {
    String lableInput = '';
    String passInput = '';
    final _formKey = GlobalKey<FormState>();
    final currentContext = context;

    return showDialog(
      context: currentContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Cập nhật email mới',
            style: AppTheme.lightTextTheme.headlineLarge,
          ),
          content: Container(
            height: 200,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bạn chưa nhập vào email';
                      }
                      return null;
                    },
                    style: AppTheme.lightTextTheme.bodySmall,
                    cursorColor: ColorClass.fiveColor,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => lableInput = value,
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorClass.fiveColor),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorClass.fiveColor),
                      ),
                      hintText: 'Email',
                      hintStyle: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Bạn chưa nhập vào mật khẩu xác nhận';
                        }
                        return null;
                      },
                      style: AppTheme.lightTextTheme.bodySmall,
                      cursorColor: ColorClass.fiveColor,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      onChanged: (value) => passInput = value,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorClass.fiveColor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorClass.fiveColor),
                        ),
                        hintText: 'Xác nhận mật khẩu',
                        hintStyle: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(currentContext).pop();
              },
              child: const Text(
                'Huỷ',
                style: TextStyle(color: ColorClass.fiveColor),
              ),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  //   Navigator.of(currentContext).pop();

                  try {
                    UserModel userModel = user.copyWith(email: lableInput);
                    // ignore: prefer_interpolation_to_compose_strings
                    print('Email mới' + lableInput);
                    firAuth.updateEmai(
                      lableInput,
                      user.email,
                      passInput,
                      () async {
                        // gọi update
                        context.read<BlocUserLogin>().updateUser(userModel);
                        print('Gọi xong');
                        Navigator.of(currentContext).pop();
                      },
                      (msg) {
                        print('Lỗi ' + msg);
                        Navigator.of(currentContext).pop();
                        showErrorDialog(currentContext, msg);
                      },
                    );
                  } catch (e) {
                    print('Gọi hàm lỗi' + e.toString());
                  }
                }
              },
              child: const Text(
                'Thay đổi',
                style: TextStyle(color: ColorClass.fiveColor),
              ),
            ),
          ],
        );
      },
    );
  }

  buildDiaLogMatKhau(BuildContext context, UserModel user) async {
    String lableInput = '';
    String passInput = '';
    final _formKey = GlobalKey<FormState>();
    final currentContext = context;

    return showDialog(
      context: currentContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Cập nhật Mật Khẩu mới',
            style: AppTheme.lightTextTheme.headlineLarge,
          ),
          content: Container(
            height: 200,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bạn chưa nhập vào Mật Khẩu';
                      }
                      return null;
                    },
                    style: AppTheme.lightTextTheme.bodySmall,
                    cursorColor: ColorClass.fiveColor,
                    keyboardType: TextInputType.text,
                    autocorrect: true,
                    obscureText: true,
                    onChanged: (value) => lableInput = value,
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorClass.fiveColor),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorClass.fiveColor),
                      ),
                      hintText: 'Mật Khẩu mới',
                      hintStyle: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Bạn chưa nhập vào mật khẩu xác nhận';
                        }
                        return null;
                      },
                      style: AppTheme.lightTextTheme.bodySmall,
                      cursorColor: ColorClass.fiveColor,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      onChanged: (value) => passInput = value,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorClass.fiveColor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorClass.fiveColor),
                        ),
                        hintText: 'Xác nhận mật khẩu củ',
                        hintStyle: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(currentContext).pop();
              },
              child: const Text(
                'Huỷ',
                style: TextStyle(color: ColorClass.fiveColor),
              ),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // Navigator.of(currentContext).pop();

                  try {
                    print('Email mới' + lableInput);
                    firAuth.updatePassword(
                      lableInput,
                      passInput,
                      user.email,
                      () async {
                        // gọi update
                        firAuth.logOut();

                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginForm()),
                            (Route<dynamic> route) => false);
                      },
                      (msg) {
                        print('Lỗi ' + msg);
                        showErrorDialog(currentContext, msg);
                      },
                    );
                  } catch (e) {
                    print('Gọi hàm lỗi' + e.toString());
                  }
                }
              },
              child: const Text(
                'Thay đổi',
                style: TextStyle(color: ColorClass.fiveColor),
              ),
            ),
          ],
        );
      },
    );
  }

  void showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text('Error', style: TextStyle(color: Colors.red, fontSize: 18)),
          content: Text(
            errorMessage,
            style: AppTheme.lightTextTheme.bodySmall,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  upDateFullName(String newEmail) {}
}
/* 
  Future<dynamic> buildDiaLog(BuildContext context, String label) {
    String lableInput = '';
    final user = Provider.of<BlocUserLogin>(context, listen: false);
    UserModel userModel = user.userlogin!;
    final _formKey = new GlobalKey<FormState>();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Cập nhật email mới',
              style: AppTheme.lightTextTheme.headlineLarge,
            ),
            content: Container(
              height: 200,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isNotEmpty == false) {
                          return 'Bạn chưa nhập vào email';
                        }
                        return null;
                      },
                      style: AppTheme.lightTextTheme.bodySmall,
                      cursorColor: ColorClass.fiveColor,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) => lableInput = value,
                      decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: ColorClass.fiveColor),
                          ),
                          // Để chỉnh màu gạch ngang khi focus
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: ColorClass.fiveColor),
                          ),
                          hintText: 'Email mới',
                          hintStyle:
                              TextStyle(fontSize: 12, color: Colors.black)),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isNotEmpty == false) {
                            return 'Bạn chưa nhập vào mật khẩu xác nhận';
                          }
                          return null;
                        },
                        style: AppTheme.lightTextTheme.bodySmall,
                        cursorColor: ColorClass.fiveColor,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: true,
                        onChanged: (value) => passInput = value,
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorClass.fiveColor),
                            ),
                            // Để chỉnh màu gạch ngang khi focus
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorClass.fiveColor),
                            ),
                            hintText: 'Xác nhận mật khẩu',
                            hintStyle:
                                TextStyle(fontSize: 12, color: Colors.black)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Huỷ',
                    style: TextStyle(color: ColorClass.fiveColor),
                  )),
              TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Navigator.of(context).pop();
                      FirAuth().updatePassword(
                          'tvb1234567', "tvb123456", userModel.email, () async {
                        print('Gọi hàm thành công');
                        //gọi update
                        userModel = user.userlogin!.copyWith(email: emailInput);
                        await context
                            .read<BlocUserLogin>()
                            .updateUser(userModel);
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => LoginForm()));
                      }, (msg) {
                        if (msg == 'reLogin') {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Đăng nhập lại tài khoản')));
                        } else {
                          // ignore: prefer_interpolation_to_compose_strings
                          print('Lỗi ' + msg);
                        }
                      });
                    }
                  },
                  child: const Text('Thay đổi',
                      style: TextStyle(color: ColorClass.fiveColor))),
            ],
          );
        });
  }
  FirAuth().updateEmai(
                          'nvb@gmail.com', userModel.email, 'tvb123456',
                          () async {
                        print('Gọi hàm thành công');
                        //gọi update
                        userModel = user.userlogin!.copyWith(email: emailInput);
                        await context
                            .read<BlocUserLogin>()
                            .updateUser(userModel);
                        // ignore: use_build_context_synchronously
                      }, (msg) {
                        if (msg == 'reLogin') {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Đăng nhập lại tài khoản')));
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (_) => LoginForm()));
                        } else {
                          // ignore: prefer_interpolation_to_compose_strings
                          print('Lỗi ' + msg);
                        }
                      }); */
