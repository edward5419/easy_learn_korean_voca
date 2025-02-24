import 'package:balibali/pages/chapter_group_list_page.dart';
import 'package:balibali/pages/chapter_list_page.dart';
import 'package:balibali/pages/loading_page.dart';
import 'package:balibali/pages/voca_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'pages/homepage.dart';
import 'package:get/get.dart';
import 'package:balibali/pages/login_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: "/",
      getPages: [
        GetPage(
            name: "/homepage",
            page: () => HomePage(),
            transition: Transition.native),
        GetPage(
            name: "/vocaList",
            page: () => const VocaList(),
            transition: Transition.native),
        GetPage(
            name: "/chapterList",
            page: () => const ChapterList(),
            transition: Transition.native),
        GetPage(
            name: "/login",
            page: () => const LoginPage(),
            transition: Transition.native),
        GetPage(
            name: "/chapterGroupList",
            page: () => const ChapterGroupList(),
            transition: Transition.native),
      ],
      title: 'MyDream',
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.grey[50],
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white, // AppBar 배경색
            foregroundColor: Colors.brown, // AppBar 전경색 (아이콘 및 텍스트 색상)
            iconTheme: IconThemeData(color: Colors.brown), // AppBar 아이콘 색상
            titleTextStyle: TextStyle(
                color: Colors.grey, fontSize: 20), // AppBar 제목 텍스트 스타일
          ),
          textTheme: GoogleFonts.latoTextTheme().copyWith(
              titleLarge: GoogleFonts.lato(
                fontSize: 20,
                letterSpacing: 1.2,
                height: 1.5,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
              titleMedium: GoogleFonts.lato(
                fontSize: 16,
                letterSpacing: 1.2,
                height: 1.5,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
              bodyLarge: GoogleFonts.lato(
                fontSize: 20,
                letterSpacing: 1.2,
                height: 1.5,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
              bodyMedium: GoogleFonts.lato(
                fontSize: 17,
                letterSpacing: 1.2,
                height: 1.5,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
              bodySmall: GoogleFonts.lato(
                fontSize: 14,
                letterSpacing: 1.2,
                height: 1.5,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              labelMedium: GoogleFonts.lato(
                fontSize: 14,
                letterSpacing: 1.2,
                height: 1.5,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
              labelSmall: GoogleFonts.lato(
                fontSize: 14,
                letterSpacing: 1.2,
                height: 1.5,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              )),
          primarySwatch: Colors.brown,
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.brown)))),
      home: LoadingPage(),
      builder: EasyLoading.init(),
    );
  }
}
