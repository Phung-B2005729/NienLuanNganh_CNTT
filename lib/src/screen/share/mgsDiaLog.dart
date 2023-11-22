// ignore: file_names
import 'package:apparch/src/helper/temple/app_theme.dart';
import 'package:apparch/src/helper/temple/color.dart';
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
      BuildContext context, String msg, Color tclo, Function hamxulyxoa) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Bạn có chắc ?',
              style: AppTheme.lightTextTheme.headlineLarge,
            ),
            content: Text(msg, style: AppTheme.lightTextTheme.bodyMedium),
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
                  hamxulyxoa();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  // ignore: avoid_types_as_parameter_names
  static void showSnackbar(context, color, message) {
    if (context != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 1),
            content: Text(
              message,
              style: const TextStyle(fontSize: 18),
            ),
            backgroundColor: color,
            /*  action: SnackBarAction(
          label: "OK",
          onPressed: () {},
          textColor: Colors.white,
        ), */
          ),
        );
    }
  }

  static void showSnackbarTextColor(context, color, tcolor, message) {
    if (context != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
              duration: const Duration(seconds: 1),
              content: Text(
                message,
                style: TextStyle(fontSize: 16, color: tcolor),
              ),
              backgroundColor: color
              /*  action: SnackBarAction(
          label: "OK",
          onPressed: () {},
          textColor: tcolor,
        ), */
              ),
        );
    }
  }

  static Future<bool?> showConfirmDialogDismissible(
      BuildContext context, String message) {
    return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
                title: Text(
                  'Bạn có chắc ?',
                  style: AppTheme.lightTextTheme.headlineLarge,
                ),
                content:
                    Text(message, style: AppTheme.lightTextTheme.bodyMedium),
                actions: <Widget>[
                  TextButton(
                    child: const Text('No',
                        style: TextStyle(color: ColorClass.fiveColor)),
                    onPressed: () {
                      // ignore: use_build_context_synchronously
                      Navigator.of(ctx).pop(false);
                    },
                  ),
                  TextButton(
                      child: const Text('Yes',
                          style: TextStyle(color: ColorClass.fiveColor)),
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      })
                ]));
  }
}
