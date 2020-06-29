import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:status_downloader/Provider/image_video_provider.dart';
import 'package:status_downloader/Utils/config.dart';

import 'Utils/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ImageVideoProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: selectedcolor,
          // brightness: Brightness.dark
        ),
        initialRoute: "/home",
        onGenerateRoute: generateRoute,
      ),
    );
  }
}
