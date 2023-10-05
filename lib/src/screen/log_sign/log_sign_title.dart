import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../helper/temple/app_theme.dart';

class LogSingTitle extends StatelessWidget {
  const LogSingTitle(
    this.text,
    this.top,
    this.left, {
    super.key,
  });

  final String text;
  final double top;
  final double left;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top, // 40
      left: left, //14
      child: Row(
        children: [
          Row(
            children: [
              Text(text, style: AppTheme.lightTextTheme.titleMedium),
              const SizedBox(
                width: 5,
              ),
              const Icon(
                FontAwesomeIcons.user,
                color: Colors.black,
              ),
            ],
          ),
          const SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }
}
