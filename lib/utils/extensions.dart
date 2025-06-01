import 'package:flutter/material.dart';
import 'dart:math' as math;

extension NumDurationExtensions on num {
  Duration get um => Duration(microseconds: round());

  Duration get ms => (this * 1000).um;

  Duration get seconds => (this * 1000 * 1000).um;

  Duration get minutes => (this * 1000 * 1000 * 60).um;

  Duration get hours => (this * 1000 * 1000 * 60 * 60).um;

  Duration get days => (this * 1000 * 1000 * 60 * 60 * 24).um;
}

extension ScaleSizeWithParam on Size {
  Size toScaleSize(double scale) => Size(width * scale, height * scale);

  Size get invert => Size(height, width);

  double get max => math.max(width, height);

  double get min => math.min(width, height);

  Size get roundToDouble => Size(width.roundToDouble(), height.roundToDouble());

  Size translate(double dx, double dy) => Size(width + dx, height + dy);
}

extension MinValueOnList on List<double> {
  double get min => _getMin(this);

  double get max => _getMax(this);

  double _getMin(List<double> listValue) {
    double min = listValue[0];
    for (var element in listValue) {
      if (element < min) {
        min = element;
      }
    }
    return min;
  }

  double _getMax(List<double> listValue) {
    double max = listValue[0];
    for (var element in listValue) {
      if (element > max) {
        max = element;
      }
    }
    return max;
  }
}

extension ExpandedRect on Rect {
  Rect expandedRectWith(double distance) {
    Offset newTopLeft = topLeft.translate(-distance, -distance);
    Offset newBottomRight = bottomRight.translate(distance, distance);
    return Rect.fromPoints(newTopLeft, newBottomRight);
  }
}

extension ExpandOffsetToRect on Offset {
  Rect expandedRectFromOffset(double distance) {
    Offset newTopLeft = translate(-distance, -distance);
    Offset newBottomRight = translate(distance, distance);
    return Rect.fromPoints(newTopLeft, newBottomRight);
  }
}

extension AverageListNumber on List<double> {
  double average() {
    if (isEmpty) return 0.0;
    double sum = reduce((a, b) => a + b);
    return sum / length;
  }
}
