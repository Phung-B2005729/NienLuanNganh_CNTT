import 'package:apparch/src/bloc/bloc_timkiem.dart';
import 'package:apparch/src/helper/temple/app_theme.dart';
import 'package:apparch/src/screen/timkiem/tim_kiem_tags_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DsTags extends StatelessWidget {
  const DsTags({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BlocTimKiem>(builder: (context, blocTimKiem, child) {
      return ListView(children: [
        if (blocTimKiem.dstags != [] && blocTimKiem.dstags.length != 0)
          for (var i = 0; i < blocTimKiem.dstags.length; i++)
            if (blocTimKiem.dstags[i] != '')
              ListTile(
                onTap: () {
                  // chuyen trang list truyen co tags là này;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              TimKiemTagsSreen(value: blocTimKiem.dstags[i])));
                },
                leading: const Icon(Icons.search),
                title: Text(
                  // ignore: prefer_interpolation_to_compose_strings
                  "#" + blocTimKiem.dstags[i],
                  style: AppTheme.lightTextTheme.bodyMedium,
                ),
              )
      ]);
    });
  }
}
