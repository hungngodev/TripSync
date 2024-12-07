import 'package:flutter/material.dart';
import '../../model/global.dart';

class UserAvatar extends StatelessWidget {
  bool hasStory;
  String imageUrl;
  //final VoidCallback onColorSelect;

  UserAvatar({required this.hasStory, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: const Alignment(0, 0),
      children: <Widget>[
        SizedBox(
            width: 48,
            height: 48,
            child: CircleAvatar(
              backgroundColor: hasStory == true
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
            )),
        const SizedBox(
            width: 45,
            height: 45,
            child: CircleAvatar(
              backgroundColor: Colors.white,
            )),
        SizedBox(
            width: 40,
            height: 40,
            child: CircleAvatar(
              backgroundImage: NetworkImage(imageUrl),
            )),
        FloatingActionButton(
          backgroundColor: Colors.transparent,
          highlightElevation: 0,
          elevation: 0,
          onPressed: () {},
        )
      ],
    );
  }
}
