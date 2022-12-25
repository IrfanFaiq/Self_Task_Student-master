import 'package:flutter/material.dart';

class CurveWidget extends StatelessWidget {

  final Widget child;
  final double curveDistance;
  final double curveHeight;

  const CurveWidget({Key? key, required this.child,  this.curveDistance = 70,  this.curveHeight = 70}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //clip path => create custom shape
    return ClipPath(clipper: CurvedWidgetBackground(curveHeight: curveHeight, curveDistance: curveDistance),child: child,);
  }
}
//To create a custom clipper,
// you need to create a class that extends CustomClipper<Path>
// and must override two methods.

class CurvedWidgetBackground extends CustomClipper<Path>
{
  final double curveDistance;
  final double curveHeight;

  CurvedWidgetBackground({required this.curveDistance, required this.curveHeight});

  @override
  getClip(Size size) {
    Path clippedPath = Path();
    //x = width,y = height
    clippedPath.lineTo(size.width, 0);

    clippedPath.lineTo(size.width, size.height - curveDistance - curveHeight);

    clippedPath.quadraticBezierTo(size.width, size.height - curveHeight,
        size.width - curveDistance, size.height - curveHeight);

    clippedPath.lineTo(curveDistance, size.height - curveHeight);

    clippedPath.quadraticBezierTo(
        0, size.height - curveHeight, 0 ,size.height - curveDistance - curveHeight);

    clippedPath.lineTo(0, 0);
    return clippedPath;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }

}