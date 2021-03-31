import 'package:flutter/material.dart';
import 'package:learn_drawing/drawing.dart';

class DrawingPainter extends CustomPainter{
  Drawing drawing;
  Paint _paint;
  DrawingPainter({@required this.drawing}){
    _paint=new Paint()
        ..color=Colors.black
        ..strokeCap=StrokeCap.round
        ..style=PaintingStyle.stroke
        ..strokeWidth=4.1;
    
  }
  @override
  void paint(Canvas canvas, Size size) {
    drawing.strokes.forEach((stroke) { 
      var points=stroke.points;
      assert(points.length>0);
      Path path=Path();
      path.moveTo(_scale(points[0].x, size.width),_scale(points[0].y, size.height));
      for(int i=0;i<points.length;i++){
        path.lineTo(_scale(points[i].x, size.width), _scale(points[i].y, size.height));
      }
      canvas.drawPath(path, _paint);
    });
  }
  @override
  bool shouldRepaint(DrawingPainter oldDelegate){
    return oldDelegate.drawing.word!=this.drawing.word;
  }
  double _scale(double original, double axisLength) {
    return original * (axisLength / 256);
  }
}