import 'package:flutter/material.dart';

///widget for display the caption of this image and can be hidden by pressed the icon
class CaptionWidget extends StatefulWidget {
  const CaptionWidget({required this.captions, Key? key}) : super(key: key);
  final List<Widget> captions;

  @override
  _CaptionWidgetState createState() => _CaptionWidgetState();
}

class _CaptionWidgetState extends State<CaptionWidget> {
  bool visibleCaption = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            visibleCaption = !visibleCaption;
            setState(() {});
          },
          child: Image.asset(
            "assets/images/sentences.jpg",
            width: 35,
            height: 35,
          ),
        ),
        Visibility(
          visible: visibleCaption,
          child: Padding(
            padding: const EdgeInsets.only(top: 6.0, left: 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.captions,
            ),
          ),
        ),
      ],
    );
  }
}
