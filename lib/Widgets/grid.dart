import 'dart:io';
import 'package:flutter/material.dart';

class Grid extends StatelessWidget {
  final String flag;
  final List<String> list;
  const Grid({this.list, this.flag});

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Container(
      height: _size.height,
      width: _size.width,
      margin: EdgeInsets.all(2),
      child: GridView.builder(
          itemCount: list.length,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            childAspectRatio: 2 / 2.4,
            maxCrossAxisExtent: 196,
          ),
          itemBuilder: (_, index) {
            return InkWell(
                onTap: () {
                  return Navigator.of(context).pushNamed("/display",
                      arguments: {"list": list, "index": index,"flag":flag});
                },
                child: Card(
                  child: Image.file(
                    File(list[index]),
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.low,
                  ),
                ));
          }),
    );
  }
}
