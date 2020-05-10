import 'package:flutter/material.dart';
import 'package:status_downloader/Screens/display.dart';
import 'package:status_downloader/Screens/home.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case "/home":
      return MaterialPageRoute(builder: (context) => Home());
    case "/display":
      final Map<String, dynamic> _argument = settings.arguments;
      final image = _argument["list"];
      final index = _argument["index"];
      final flag = _argument["flag"];
      return MaterialPageRoute(
          builder: (context) => Display(
                list: image,
                index: index,
                flag: flag,
              ));
    
  }
}
