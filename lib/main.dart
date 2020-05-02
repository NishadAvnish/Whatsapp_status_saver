import 'package:flutter/material.dart';
import 'package:status_downloader/Utils/config.dart';

import 'Utils/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: selectedcolor,
        // brightness: Brightness.dark
      ),
      initialRoute: "/home",
      onGenerateRoute: generateRoute,
    );
  }
}
