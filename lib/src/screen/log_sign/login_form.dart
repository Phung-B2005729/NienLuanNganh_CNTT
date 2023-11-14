// ignore: file_names
// ignore: file_names
//import 'dart:async';

//import 'package:apparch/src/firebase/fire_base_auth.dart';
import 'package:apparch/src/screen/share/loadingDialog.dart';
import 'package:apparch/src/screen/share/mgsDiaLog.dart';
import 'package:apparch/src/screen/home_screen.dart';
import 'package:apparch/src/screen/log_sign/singup_form.dart';
import 'package:apparch/src/firebase/fire_base_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import '../../Manager/comhelper.dart';
import '../../firebase/services/database_user.dart';
import '../../helper/helper_function.dart';
import '../../helper/temple/color.dart';
import 'get_text_form_file.dart';
import '../../helper/temple/app_theme.dart';
//import 'loginForm.dart';
import 'log_sign_title.dart';

// ignore: use_key_in_widget_constructors, camel_case_types
class LoginForm extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _LoginFormState createState() => _LoginFormState();
}

// ignore: camel_case_types
class _LoginFormState extends State<LoginForm> {
  bool _ktrpass = true;
  FirAuth firAuth = FirAuth();
  // ignore: prefer_final_fields
//  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  // ignore: unnecessary_new
  final _formKey = new GlobalKey<FormState>();
  // ignore: override_on_non_overriding_member, non_constant_identifier_names
  final _EmailController = TextEditingController();
  // ignore: non_constant_identifier_names
  final _PasswordController = TextEditingController();
  // ignore: non_constant_identifier_names
  final FocusNode PasswordFocusNode = FocusNode();
  final FocusNode emailPasswordFocusNode = FocusNode();
  // ignore: prefer_typing_uninitialized_variables
  @override
  void initState() {
    super.initState();
  }

  login() async {
    String email = _EmailController.text;
    String pass = _PasswordController.text;
    if (_formKey.currentState!.validate()) {
      LoadingDialog.showLoadingDialog(context, "loading...");
      firAuth.login(email, pass, () async {
        LoadingDialog.hideLoadingDialog(context);
        QuerySnapshot snapshot =
            await DatabaseUser(uid: FirebaseAuth.instance.currentUser!.uid)
                .gettingUserData(email);
        // saving the values to our shared preferences
        await HelperFunctions.saveLoggedInStatus(true);
        await HelperFunctions.saveEmailSF(email);
        await HelperFunctions.saveUserID(snapshot.docs[0]['uid']);
        await HelperFunctions.saveUserNameSF(snapshot.docs[0]['username']);
        await HelperFunctions.saveAvataSF(snapshot.docs[0]['avata']);
        await HelperFunctions.saveAnhMacDinh();

        // ignore: use_build_context_synchronously
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (Route<dynamic> route) => false);
      }, (mgs) {
        LoadingDialog.hideLoadingDialog(context);
        MsgDialog.showLoadingDialog(context, mgs);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/loginlight.png'),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Stack(children: [
              const LogSingTitle('Login Account', 20.0, 14.0),
              // scoll tu chu Arch App
              Container(
                margin: const EdgeInsets.only(
                    top: 130), //MediaQuery.of(context).size.height * 0.46),
                child: Column(
                  children: [
                    Text("ArCH App", style: AppTheme.lightTextTheme.titleLarge),
                    const SizedBox(
                      height: 80,
                    ),
                    GetTextFormFile(
                      controller: _EmailController,
                      labeltext: 'Email',
                      icon: Icons.email,
                      inputType: TextInputType.emailAddress,
                      focus: emailPasswordFocusNode,
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    GetTextFormFile(
                      controller: _PasswordController,
                      labeltext: 'Password',
                      icon: Icons.lock,
                      isObscureText: _ktrpass,
                      focus: PasswordFocusNode,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 40.0, left: 35.0, right: 35.0, bottom: 20),
                      width: double.infinity,
                      // ignore: sort_child_properties_last
                      child: TextButton(
                        // ignore: sort_child_properties_last
                        child: Text('Login',
                            style: AppTheme.lightTextTheme.displayMedium),
                        onPressed: login,
                      ),
                      decoration: BoxDecoration(
                        color: ColorClass.primaryColor,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    // ignore: sized_box_for_whitespace
                    Container(
                      height: 70,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Do not have account ? ',
                            style: AppTheme.lightTextTheme.displaySmall,
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: ColorClass.primaryColor,
                              padding: const EdgeInsets.all(20.0),
                              textStyle: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            child: const Text('Signup'),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const SingupFrom()),
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
