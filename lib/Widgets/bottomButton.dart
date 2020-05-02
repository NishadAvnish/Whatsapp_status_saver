import 'package:flutter/material.dart';
import 'package:status_downloader/Listenable/imgOrVideo.dart';
import 'package:status_downloader/Utils/config.dart';

class BottomButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        MaterialButton(
            color: imgOrVideo.value == 0 ? selectedcolor : unselectedcolor,
            splashColor: Colors.amberAccent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            onPressed: () {
              if (imgOrVideo.value != 0) {
                imgOrVideo.value = 0;
              }
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 3),
              child: Text("Image",
                  style: Theme.of(context).textTheme.body2.copyWith(
                      color:
                          imgOrVideo.value == 0 ? Colors.white : Colors.black)),
            )),
        SizedBox(
          width: 15,
        ),
        MaterialButton(
            splashColor: Colors.amberAccent,
            color: imgOrVideo.value == 1 ? selectedcolor : unselectedcolor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            onPressed: () {
              if (imgOrVideo.value != 1) {
                imgOrVideo.value = 1;
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 3),
              child: Text("Video",
                  style: Theme.of(context).textTheme.body2.copyWith(
                        color:
                            imgOrVideo.value == 1 ? Colors.white : Colors.black,
                      )),
            )),
      ],
    );
  }
}
