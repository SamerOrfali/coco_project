import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'image_pinter.dart';

///image widget which contains the objects
///first we convert the image from network image to ui image so we can draw in it
/// because of api response is a list of double we need to create object of DrawingPoints
/// so we create object between to consecutive double value (pixels)
/// and then we pass it to custom painter to draw lines

class ImageWidget extends StatefulWidget {
  const ImageWidget({required this.url, required this.coloredPixel, key}) : super(key: key);
  ///network image url
  final String url;
  ///instances from api response is a list of double
  final List<double> coloredPixel;

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  ui.Image? image;

  @override
  void initState() {
    super.initState();
    getIm();
  }

  getIm() async {
    image = await convertImage(widget.url);
    if (mounted) {
      setState(() {});
    }
  }

  Uint8List? im;

  List<DrawingPoints?> createDrawingPoints() {
    Color color = Colors.blue;
    List<DrawingPoints?> points = [];
    ///the for is i+=2 because it deals with 2 Consecutive elements
    for (int i = 0; i < widget.coloredPixel.length; i += 2) {
      ///I add this condition because I passed -1 values just to separate objects segmentation and not draw all objects in one continuous line
      ///also I changed the color after drawing each object
      ///by this condition I can now that this object segmentation is finished
      if (widget.coloredPixel[i] == -1 || widget.coloredPixel[i + 1] == -1) {
        points.add(null);
        color = Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
      } else {
        ///add points to drawing points list to pass it to image pinter
        points.add(
          DrawingPoints(
            points: Offset(widget.coloredPixel[i], widget.coloredPixel[i + 1]),
            paint: Paint()
              ..color = color
              ..style = PaintingStyle.fill
              ..strokeWidth = 4
              ..strokeJoin = StrokeJoin.miter
              ..strokeCap = StrokeCap.round
              ..isAntiAlias = true,
          ),
        );
      }
    }
    return points;
  }

  @override
  Widget build(BuildContext context) {
    return image == null
        ? Container()
        : SizedBox(
            height: image!.height.toDouble(),
            width: image!.width.toDouble(),
            child: CustomPaint(
              painter: ImagePainter(
                image: image!,
                pointsList: createDrawingPoints(),
              ),
            ),
          );
  }

  ///function for convert network image to ui image to draw on ir
  Future<ui.Image> convertImage(String path) async {
    var completer = Completer<ImageInfo>();
    var img = NetworkImage(path);
    img.resolve(const ImageConfiguration()).addListener(ImageStreamListener((info, _) {
      completer.complete(info);
    }));
    ImageInfo imageInfo = await completer.future;
    return imageInfo.image;
  }
}
