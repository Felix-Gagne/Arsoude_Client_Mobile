import 'package:flutter/material.dart';

class MyClipperBackground extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0,size.height * 0.25);
    path.cubicTo(
      size.width *0.33, size.height *0.30, // Control point 1 (pulls the curve up)
      size.width *0.66, size.height *0.30, // Control point 2 (pulls the curve up)
      size.width, size.height *0.25, // Ending point (right side of the widget's height, halfway down the height)
    );

    // Line to the bottom-right corner
    path.lineTo(size.width, size.height);

    // Line to the bottom-left corner
    path.lineTo(0, size.height);

    // Close the path
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}