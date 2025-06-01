import 'package:flutter/material.dart';

class SnapHelper {
  static Offset snapHorizontalWithListOffset(
    Offset checkOffset,
    List<Offset> listTargetOffset, {
    double distanceCheck = 20,
  }) {
    /// dựa vào các target offset
    /// Kiểm tra xem gần target offset nào nhất
    /// Kiểm tra tiếp xem khoảng cách từ checkOffset đến điểm đó có nằm trong khoảng cách 20 pixel từ điểm gần nhất đó hay không
    /// Nếu có thì return điểm gần nhất đó
    /// Nếu không thì return lại checkOffset
    if (listTargetOffset.isEmpty) return checkOffset;

    Offset? closestOffset;
    double minDistance = double.infinity;

    for (Offset target in listTargetOffset) {
      double distance = (checkOffset.dx - target.dx).abs();
      if (distance < minDistance) {
        minDistance = distance;
        closestOffset = target;
      }
    }

    return (closestOffset != null && minDistance <= distanceCheck)
        ? Offset(closestOffset.dx, checkOffset.dy)
        : checkOffset;
  }

  static double snapHorizontal(
    double checkValue,
    List<double> listTargetValue, {
    double distanceCheck = 20,
  }) {
    if (listTargetValue.isEmpty) return checkValue;

    double? closestOffset;
    double minDistance = double.infinity;

    for (var target in listTargetValue) {
      double distance = (checkValue - target).abs();
      if (distance < minDistance) {
        minDistance = distance;
        closestOffset = target;
      }
    }

    return (closestOffset != null && minDistance <= distanceCheck)
        ? closestOffset
        : checkValue;
  }
}
