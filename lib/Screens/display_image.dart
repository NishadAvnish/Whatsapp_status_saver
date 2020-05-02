import 'package:flutter/material.dart';
import 'package:status_downloader/Utils/config.dart';

class DisplayImage extends StatelessWidget {
  final List<String> image;
  const DisplayImage({this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Image")),
        backgroundColor: darkBackground,
        body: Container(
          child: Center(
            child: AspectRatio(
              aspectRatio: 11 / 9,
              child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: image.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      image[index],
                      fit: BoxFit.cover,
                    );
                  }),
            ),
          ),
        ));
  }
}
