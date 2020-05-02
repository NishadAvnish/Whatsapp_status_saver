import 'package:flutter/material.dart';
import 'package:status_downloader/Screens/display_image.dart';
import 'package:status_downloader/Screens/home.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case "/home":
      return MaterialPageRoute(builder: (context) => Home());
    case "/displayImage":
      final image=settings.arguments;
      return MaterialPageRoute(builder: (context)=>DisplayImage(image:image));  
    default:
  }
}
