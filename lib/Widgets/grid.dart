import 'package:flutter/material.dart';

class Grid extends StatelessWidget {
  final List<String> imageList;
  const Grid({this.imageList});

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Container(
      height: _size.height,
      width: _size.width,
      margin: EdgeInsets.all(2),
      child: GridView.builder(
          itemCount: imageList.length,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            childAspectRatio: 2 / 2.4,
            maxCrossAxisExtent: 196,
          ),
          itemBuilder: (_, index) {
            return InkWell(
                onTap: () {Navigator.of(context).pushNamed("/displayImage",arguments: imageList.sublist(index,imageList.length));},
                child: Card(
                  child: Image.network(
                    imageList[index],
                    fit: BoxFit.cover,
                    filterQuality:FilterQuality.low,
                  ),
                ));
          }),
    );
  }
}
