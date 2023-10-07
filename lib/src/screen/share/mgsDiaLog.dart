// ignore: file_names
import 'package:flutter/material.dart';

// ignore: camel_case_types
class MsgDialog {
  static void showLoadingDialog(BuildContext context, String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            // title: const Text('Basic dialog title'),
            content: Text(
              msg,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w600, color: Colors.red),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                // ignore: unnecessary_const
                child:
                    // ignore: unnecessary_const
                    const Text('OK', style: const TextStyle(color: Colors.red)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  static void showXacNhanThongTin(
      BuildContext context, String msg, Color tclo, Function xacnhan) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            // title: const Text('Basic dialog title'),
            content: Text(
              msg,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                // ignore: unnecessary_const
                child:
                    // ignore: unnecessary_const
                    Text('Huỷ', style: TextStyle(color: tclo)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                // ignore: unnecessary_const
                child:
                    // ignore: unnecessary_const
                    Text('OK', style: TextStyle(color: tclo)),
                onPressed: () {
                  xacnhan();
                },
              ),
            ],
          );
        });
  }

  // ignore: avoid_types_as_parameter_names
  static void showSnackbar(context, color, message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 18),
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: "OK",
          onPressed: () {},
          textColor: Colors.white,
        ),
      ),
    );
  }

  static void showSnackbarTextColor(context, color, tcolor, message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontSize: 16, color: tcolor),
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: "OK",
          onPressed: () {},
          textColor: tcolor,
        ),
      ),
    );
  }
}
