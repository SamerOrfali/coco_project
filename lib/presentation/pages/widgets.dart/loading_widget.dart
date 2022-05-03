import 'package:flutter/material.dart';
///loader gif
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/images/iconLoader.gif",
      height: 125.0,
      width: 125.0,
    );
  }
}
