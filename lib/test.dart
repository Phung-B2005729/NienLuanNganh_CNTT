
/*
import 'package:apparch/src/bloc/bloc_timkiem.dart';
import 'package:apparch/src/bloc/bloc_userlogin.dart';
import 'package:apparch/src/screen/home_screen.dart';
import 'package:apparch/src/screen/log_sign/login_form.dart';
import 'package:provider/provider.dart';
import 'package:apparch/src/helper/temple/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'src/Screen/logSign/loginForm.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => BlocUserLogin()),
    ChangeNotifierProvider(create: (context) => BlocTimKiem())
  ], child: const MyApp()));
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
    context.read<BlocUserLogin>().getLoggedState();
    //  getLoggedState();
  }

  @override
  void dispose() {
    super.dispose();
    context.read<BlocUserLogin>().getLoggedState();
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
} */
/*import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyScrollView(),
    );
  }
}

class MyScrollView extends StatefulWidget {
  @override
  _MyScrollViewState createState() => _MyScrollViewState();
}

class _MyScrollViewState extends State<MyScrollView> {
  final ScrollController _controller = ScrollController();
  double scrollProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_scrollListener);
  }

  void _scrollListener() {
    setState(() {
      scrollProgress =
          _controller.position.pixels / _controller.position.maxScrollExtent;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Slider(
            value: scrollProgress,
            onChanged: (value) {
              setState(() {
                scrollProgress = value;
                // Tại đây, bạn có thể cập nhật tiến trình đọc nội dung dựa trên giá trị của `value`.
                double newScrollPosition =
                    value * _controller.position.maxScrollExtent;
                _controller.jumpTo(newScrollPosition);
              });
            },
            min: 0.0,
            max: 1.0,
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _controller,
              child: Column(
                children: <Widget>[
                  // Nội dung bạn muốn hiển thị trong SingleChildScrollView
                  for (int i = 0; i < 50; i++)
                    ListTile(
                      title: Text('Item $i'),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/