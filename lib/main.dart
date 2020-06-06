import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tizeno/screens/main_page.dart';
import 'package:flutter/rendering.dart';
import 'package:catcher/catcher_plugin.dart';

main() {
  CatcherOptions debugOptions =
      CatcherOptions(DialogReportMode(), [ConsoleHandler()]);
  CatcherOptions releaseOptions = CatcherOptions(DialogReportMode(), [
    EmailManualHandler(["hash.studios.inc@gmail.com"])
  ]);

  CatcherOptions profileOptions = CatcherOptions(
    DialogReportMode(),
    [ConsoleHandler(), ToastHandler()],
    handlerTimeout: 1000,
  );

  Catcher.addDefaultErrorWidget(showStacktrace: true);
  Catcher(MyApp(),
      debugConfig: debugOptions,
      releaseConfig: releaseOptions,
      profileConfig: profileOptions);

  //profile configuration
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Catcher.navigatorKey,
      builder: (BuildContext context, Widget widget) {
        Catcher.addDefaultErrorWidget(
            showStacktrace: true,
            title: "Crash",
            description: "Something went wrong!",
            maxWidthForSmallMode: 150);
        return widget;
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        iconTheme: IconThemeData(color: Colors.orange),
        textTheme: GoogleFonts.montserratTextTheme(),
        primaryTextTheme: TextTheme(
          headline6: TextStyle(color: Colors.black),
        ),
        primarySwatch: Colors.orange,
      ),
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
