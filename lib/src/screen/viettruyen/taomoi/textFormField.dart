import 'package:apparch/src/helper/temple/color.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class textFormField extends StatelessWidget {
  FocusNode nameFocusNode;
  TextEditingController nameController;
  dynamic style;
  String label;
  dynamic labelstyle;

  textFormField(
      {required this.nameFocusNode,
      required this.nameController,
      required this.label,
      required this.style,
      required this.labelstyle});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: label == 'Mô tả' ? null : 1,
      focusNode: nameFocusNode,
      validator: (value) {
        if ((value == null || value.isEmpty)) {
          return 'Vui lòng nhập $label';
        }
        return null;
      },
      controller: nameController,
      style: style,
      decoration: InputDecoration(
        errorStyle: const TextStyle(fontSize: 12),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: ColorClass.fiveColor),
        ),
        // Để chỉnh màu gạch ngang khi focus
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: ColorClass.fiveColor),
        ),
        label: Text(label),
        labelStyle: labelstyle,
      ),
    );
  }
}
