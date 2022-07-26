import 'package:flutter/material.dart';
import 'dart:ui'as ui;

class BlendPainter extends CustomPainter {
  ui.Image image, mask;

  BlendPainter(this.image, this.mask);

  @override
  void paint(Canvas canvas, Size size) {
    Rect r = Offset.zero & size;
    Paint paint = Paint();

    if (image != null && mask != null) {
      Size inputSize = Size(mask.width.toDouble(), mask.height.toDouble());
      FittedSizes fs = applyBoxFit(BoxFit.contain, inputSize, size);

      Rect src = Offset.zero & fs.source;
      Rect dst = Alignment.center.inscribe(fs.destination, r);

      canvas.saveLayer(dst, Paint());
      canvas.drawImageRect(mask, src, dst, paint);

       paint.blendMode = BlendMode.srcIn;


      canvas.drawImageRect(image, src, dst, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}