import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class DrawingPoints {
  Paint paint;
  Offset points;

  DrawingPoints({required this.points, required this.paint});
}

class ImagePainter extends CustomPainter {
  ImagePainter({required this.image, required this.pointsList});

  ui.Image image;

  List<DrawingPoints?> pointsList;
  List<Offset> offsetPoints = [];

  List<Offset> points = [];

  @override
  void paint(Canvas canvas, Size size) {
    final imageSize = Size(image.width.toDouble(), image.height.toDouble());
    final src = Offset.zero & imageSize;
    final dst = Offset.zero & size;
    ///Draws the subset of the given image
    canvas.drawImageRect(image, src, dst, Paint());
    pointsList = pointsList.map((e) {
      if (e != null) {
        if (e.points.dy <= dst.height) {
          return e;
        }
      }
      return null;
    }).toList();
    ///iterate over drawing point and draw line between each two points
    for (int i = 0; i < pointsList.length - 1; i++) {
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        canvas.drawLine(pointsList[i]!.points, pointsList[i + 1]!.points, pointsList[i]!.paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
