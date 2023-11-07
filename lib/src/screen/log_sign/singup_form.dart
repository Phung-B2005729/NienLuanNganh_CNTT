// ignore_for_file: sized_box_for_whitespace, camel_case_types, avoid_unnecessary_containers, file_names, non_constant_identifier_names

//import 'dart:async';

// ignore: unused_import
import 'package:apparch/src/screen/share/loadingDialog.dart';
import 'package:apparch/src/screen/share/mgsDiaLog.dart';
import 'package:apparch/src/firebase/fire_base_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//import '../../AletLog/comhelper.dart';
import '../../firebase/services/database_user.dart';
import 'get_text_form_file.dart';
import '../../helper/temple/app_theme.dart';
import '../../helper/temple/color.dart';
import 'log_sign_title.dart';
import 'login_form.dart';

class SingupFrom extends StatefulWidget {
  const SingupFrom({super.key});
  @override
  State<SingupFrom> createState() => _SingupFromState();
}

class _SingupFromState extends State<SingupFrom> {
  final firAuth = FirAuth();

  // ignore: unnecessary_new
  final _formKey = new GlobalKey<FormState>();
  final _EmailController = TextEditingController();

  final _UserController = TextEditingController();

  final _PasswordController = TextEditingController();

  final _RePasswordController = TextEditingController();

  final FocusNode confirmPasswordFocusNode = FocusNode();
  final FocusNode emailPasswordFocusNode = FocusNode();
  final FocusNode PasswordFocusNode = FocusNode();
  final FocusNode usernameFocusNode = FocusNode();
  // Completer<void> completer = Completer<void>();

  // late UserTable us;
  @override
  void initState() {
    super.initState();
    // us = UserTable();
  }

  signUp() async {
    // ignore: avoid_print
    //  print('OK');
    // ignore: unused_local_variable
    String uname = _UserController.text;
    // ignore: unused_local_variable
    String email = _EmailController.text;
    String passwd = _PasswordController.text;
    String cpasswd = _RePasswordController.text;
    // ignore: unused_local_variable
    List<String> usernameList = [];
    if (_formKey.currentState!.validate()) {
      if (passwd != cpasswd) {
        MsgDialog.showLoadingDialog(context, "Mật khẩu xác nhận không đúng");
        // ignore: use_build_context_synchronously
        FocusScope.of(context).requestFocus(confirmPasswordFocusNode);
      } else {
        // ignore: unused_local_variable
        LoadingDialog.showLoadingDialog(context, 'Loading...');
        final QuerySnapshot querySnapshot = await DatabaseUser()
            .gettingUsernameData(
                uname); /* await FirebaseFirestore.instance
            .collection('users')
            .where('Username', isEqualTo: uname)
            .get(); */
        if (querySnapshot.docs.isNotEmpty) {
          // ignore: use_build_context_synchronously
          LoadingDialog.hideLoadingDialog(context);
          // ignore: use_build_context_synchronously
          MsgDialog.showLoadingDialog(context, "Username đã tồn tại");
        } else {
          firAuth.registerUserWithEmailandPassword(uname, email, passwd, () {
            // ket qua thanh cong
            LoadingDialog.hideLoadingDialog(context);
            MsgDialog.showSnackbar(
                context, ColorClass.fiveColor, "Đăng ký thành công!!");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => LoginForm()),
            );
          }, (msg) {
            // ket qua co loi
            LoadingDialog.hideLoadingDialog(context);
            MsgDialog.showLoadingDialog(context, msg);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/singuplight.png'),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Stack(children: [
              const LogSingTitle('Signup Account', 20.0, 14.0),
              Container(
                margin: const EdgeInsets.only(top: 90),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text("ArCH App", style: AppTheme.lightTextTheme.titleLarge),
                    const SizedBox(
                      height: 30,
                    ),
                    GetTextFormFile(
                      controller: _EmailController,
                      labeltext: 'Email',
                      inputType: TextInputType.emailAddress,
                      icon: Icons.email,
                      focus: emailPasswordFocusNode,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    GetTextFormFile(
                      controller: _UserController,
                      labeltext: 'User Name',
                      icon: Icons.person,
                      focus: usernameFocusNode,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    GetTextFormFile(
                      controller: _PasswordController,
                      labeltext: 'Password',
                      icon: Icons.lock,
                      isObscureText: true,
                      focus: PasswordFocusNode,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    GetTextFormFile(
                      controller: _RePasswordController,
                      labeltext: 'Confirm Password',
                      icon: Icons.lock,
                      isObscureText: true,
                      focus: confirmPasswordFocusNode,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(top: 5, left: 35, right: 35),
                      width: double.infinity,
                      // ignore: sort_child_properties_last
                      child: TextButton(
                        // ignore: sort_child_properties_last
                        child: Text('Signup Account',
                            style: AppTheme.lightTextTheme.displayMedium),
                        onPressed: signUp,
                      ),
                      decoration: BoxDecoration(
                        color: ColorClass.primaryColor,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Do you have account ? ',
                            style: AppTheme.lightTextTheme.displaySmall,
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: ColorClass.primaryColor,
                              padding: const EdgeInsets.all(16.0),
                              textStyle: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            child: const Text('Login'),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => LoginForm()),
                              );
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
