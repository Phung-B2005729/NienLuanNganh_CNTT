// ignore_for_file: must_be_immutable, unused_field

/*import 'package:ct484_project/firebase/firebase_auth.dart';
import 'package:ct484_project/helper/template/app_theme.dart';
import 'package:ct484_project/helper/template/color.dart';
import 'package:ct484_project/manager/lophoc_manager.dart';
import 'package:ct484_project/manager/user_login_manager.dart';
import 'package:ct484_project/model/user_model.dart';
import 'package:ct484_project/ui/log_sign/login_form.dart';
import 'package:ct484_project/ui/share/appDrawer_user.dart';
import 'package:ct484_project/ui/share/msgDiaLog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrangCaNhan extends StatefulWidget {
  const TrangCaNhan({super.key});

  @override
  State<TrangCaNhan> createState() => _TrangCaNhanState();
}

class _TrangCaNhanState extends State<TrangCaNhan> {
  late Future<void> userData;
  final firAuth = FirAuth();

  @override
  void initState() {
    super.initState();
    userData = getData();
  }

  Future<void> getData() async {
    await context.read<UserLoginManager>().getIdUserLogin();
    return context.read<UserLoginManager>().getUserLogin();
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
                return Consumer<UserLoginManager>(
                    builder: (context, userLoginManager, child) {
                  final user = userLoginManager.userlogin;

                  return ListView(
                    physics: ScrollPhysics(),
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: ListTile(
                          title: Text(
                            'Họ tên',
                            style: AppTheme.lightTextTheme.headlineMedium,
                          ),
                          subtitle: Text(
                            user!.fullName,
                            style: AppTheme.lightTextTheme.bodySmall,
                          ),
                          onTap: () {
                            // mở modal thay đổi tên
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
                            await buildDiaLogEmail(context);
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
                              style: AppTheme.lightTextTheme.headlineMedium),
                          // ignore: prefer_const_constructors
                          subtitle: Text(
                            '..........',
                            style: AppTheme.lightTextTheme.headlineMedium,
                          ),
                          onTap: () {
                            // mở modal thay đổi mật khẩu
                          },
                        ),
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
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

  Future<dynamic> buildDiaLogEmail(BuildContext context) {
    String emailInput = '';
    String passInput = '';
    final user = Provider.of<UserLoginManager>(context, listen: false);
    UserModel userModel = user.userlogin!;
    final _formKey = new GlobalKey<FormState>();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Cập nhật Email mới',
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
                      onChanged: (value) => emailInput = value,
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
                    SizedBox(
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
                            .read<UserLoginManager>()
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
                      });
                      /* FirAuth().updateEmai(
                          'nvb@gmail.com', userModel.email, 'tvb123456',
                          () async {
                        print('Gọi hàm thành công');
                        //gọi update
                        userModel = user.userlogin!.copyWith(email: emailInput);
                        await context
                            .read<UserLoginManager>()
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
                    }
                  },
                  child: const Text('Thêm',
                      style: TextStyle(color: ColorClass.fiveColor))),
            ],
          );
        });
  }

  upDatEmail() {}
} */
