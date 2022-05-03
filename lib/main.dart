import 'package:flutter/material.dart';
import 'package:samer_orfali_test/domain/util/logging.dart';
import 'package:samer_orfali_test/presentation/pages/search_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key) {
    initRootLogger();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SearchPage(),
    );
  }
}
