import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class TagTruyen extends StatelessWidget {
  List<dynamic> tag;
  TagTruyen({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (context, index) {
          return const SizedBox(width: 3);
        },
        scrollDirection: Axis.horizontal,
        itemCount: tag.isNotEmpty ? tag.length : 0, // Số lượng phần tử ngang
        itemBuilder: (context, index) {
          return Center(
            child: Chip(
                label: Text(
              tag[index],
              style: GoogleFonts.openSans(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            )),
          );
        });
  }
}
