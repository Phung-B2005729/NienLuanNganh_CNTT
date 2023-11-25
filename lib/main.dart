import 'package:apparch/src/bloc/bloc_binhluan.dart';
import 'package:apparch/src/bloc/bloc_thongbao.dart';
import 'package:apparch/src/bloc/bloc_timkiem.dart';
import 'package:apparch/src/bloc/bloc_truyen.dart';
import 'package:apparch/src/bloc/bloc_user.dart';
import 'package:apparch/src/bloc/bloc_userlogin.dart';
import 'package:apparch/src/screen/home_screen.dart';
import 'package:apparch/src/screen/log_sign/login_form.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:apparch/src/helper/temple/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => BlocUserLogin()),
      ChangeNotifierProvider(create: (context) => BlocUser()),
      ChangeNotifierProvider(create: (context) => BlocThongBao()),
      ChangeNotifierProvider(create: (context) => BlocTimKiem()),
      ChangeNotifierProvider(create: (context) => BlocTruyen()),
      ChangeNotifierProvider(create: (context) => BlocBinhLuan())
    ], child: const MyApp()));
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    getUser();
    //  getLoggedState();
  }

  @override
  void dispose() {
    super.dispose();
    // getUser();
  }

  void getUser() {
    context.read<BlocUserLogin>().getLoggedState();
    context.read<BlocUserLogin>().getUserLogin();
    context.read<BlocThongBao>().getAllThongBao();
    context.read<BlocUser>().getAllUser();
    context.read<BlocTruyen>().getAllTruyen();
  }

  @override
  Widget build(BuildContext context) {
    final blocUserLogin = Provider.of<BlocUserLogin>(context);
    final isLogged = blocUserLogin.isLogged;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // bỏ biểu tượng đỏ trên app
      title: "Arch App",
      theme: AppTheme.light(),
      home: isLogged ? HomeScreen() : LoginForm(), // da va chua dang nhap
    );
  }
}
