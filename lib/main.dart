import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_screen/screens/main_page.dart';
import 'package:flutter/rendering.dart';
import 'package:multi_screen/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider<DynamicTheme>(
      create: (_) => DynamicTheme(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DynamicTheme>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // title: 'Flutter Demo',
      theme: themeProvider.getDarkMode()
          ? ThemeData.dark().copyWith(
              iconTheme: IconThemeData(color: Colors.orange),
              textTheme: GoogleFonts.montserratTextTheme(),
              primaryTextTheme: TextTheme(
                headline6: TextStyle(color: Colors.white),
              ),
              // primarySwatch: Colors.orange,
            )
          : ThemeData.light().copyWith(
              iconTheme: IconThemeData(color: Colors.orange),
              textTheme: GoogleFonts.montserratTextTheme(),
              primaryTextTheme: TextTheme(
                headline6: TextStyle(color: Colors.black),
              ),
              // primarySwatch: Colors.orange,
            ),
      // theme: ThemeData(
      //   // fontFamily: "Roboto",
      //   iconTheme: IconThemeData(color: Colors.orange),
      //   textTheme: GoogleFonts.montserratTextTheme(),
      //   primaryTextTheme: TextTheme(
      //     headline6: TextStyle(color: Colors.black),
      //   ),
      //   primarySwatch: Colors.orange,
      // ),
      home: ScrollConfiguration(
        behavior: MyBehavior(),
        child: MainPage(),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
