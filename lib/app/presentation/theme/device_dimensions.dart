import 'package:flutter/widgets.dart';

class DeviceDimensions {
  static late double _width;
  static late double _height;

  static void initialize(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    _width = mediaQuery.size.width;
    _height = mediaQuery.size.height;
  }

  static double get width => _width;
  static double get height => _height;
}
