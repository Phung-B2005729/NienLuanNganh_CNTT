import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class TagTruyen extends StatelessWidget {
  List<dynamic> tag;
  TagTruyen({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return ListView(
        scrollDirection: Axis.horizontal,
        // Số lượng phần tử ngang
        children: [
          for (var index = 0; index < tag.length; index++)
            if (tag[index] != '')
              Center(
                child: Chip(
                    label: Text(
                  tag[index],
                  style: GoogleFonts.openSans(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                )),
              )
        ]);
  }
}
