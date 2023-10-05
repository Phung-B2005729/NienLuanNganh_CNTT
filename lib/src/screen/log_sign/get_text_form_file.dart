// ignore_for_file: must_be_immutable, file_names, use_key_in_widget_constructors
import 'package:apparch/src/helper/temple/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:apparch/src/helper/temple/color.dart';

// ignore: camel_case_types
class GetTextFormFile extends StatelessWidget {
  String labeltext;
  IconData icon;
  bool isObscureText;
  bool isEnable;
  TextInputType inputType;
  FocusNode focus;
  // double height;
  TextEditingController controller;

  validateEmail(String email) {
    // ignore: unnecessary_new
    final emailReg = new RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return emailReg.hasMatch(email);
  }

  GetTextFormFile(
      {required this.controller,
      required this.labeltext,
      required this.icon,
      this.inputType = TextInputType.text,
      this.isEnable = true,
      this.isObscureText = false,
      required this.focus});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 30.0,
        left: 30.0,
      ),
      child: Center(
        child: TextFormField(
          style: AppTheme.lightTextTheme.headlineMedium,
          focusNode: focus,
          controller: controller,
          obscureText: isObscureText,
          cursorColor: ColorClass.xanh3Color,
          enabled: isEnable,
          keyboardType: inputType,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Vui lòng nhập $labeltext';
            }
            if (labeltext == "Email" && !validateEmail(value)) {
              return 'Email không hợp lệ';
            }
            if (labeltext == "User Name" && value.length < 4) {
              return 'User Name phải có độ dài ít nhất 4 kí tự';
            }
            if ((labeltext == "Password" || labeltext == "Confirm Password") &&
                value.length < 8) {
              return 'Mật khẩu phải có ít nhất 8 kí tự';
            }
            return null;
          },
          // truyen thuoc tinh vao
          //  scrollPadding: const EdgeInsets.all(10),
          // trang tri
          decoration: InputDecoration(
            // contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              borderSide: BorderSide(color: ColorClass.primaryColor),
            ),
            errorStyle: const TextStyle(fontSize: 12),
            hintText: labeltext,
            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
            prefixIcon: Icon(icon),
            fillColor: Colors.grey[350],
            filled: true,
          ),
        ),
      ),
    );
  }
}
