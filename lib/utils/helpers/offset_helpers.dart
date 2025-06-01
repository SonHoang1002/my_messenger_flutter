import 'package:flutter/material.dart';

class OffsetHelpers {
  static bool checkInsideDistance(
      double checkValue, double checkedValue, double addtionalValue) {
    final rightCheckValue = checkValue + addtionalValue;
    final leftCheckValue = checkValue - addtionalValue;
    if (leftCheckValue < checkedValue && checkedValue < rightCheckValue) {
      return true;
    } else {
      return false;
    }
  }

  static bool containOffset(
    Offset checkOffset,
    Offset startOffset,
    Offset endOffset,
  ) {
    return (startOffset.dx <= checkOffset.dx &&
            checkOffset.dx <= endOffset.dx) &&
        (startOffset.dy <= checkOffset.dy && checkOffset.dy <= endOffset.dy);
  }

  static bool containOffsetInRect(Offset checkOffset, Rect checkRect) {
    return containOffset(checkOffset, checkRect.topLeft, checkRect.bottomRight);
  }

  static bool containPointIn4Points({
    required List<Offset> listPoint,
    required Offset checkPoint,
  }) {
    // Tạo danh sách các cạnh của tứ giác
    List<List<Offset>> edges = [
      [listPoint[0], listPoint[1]],
      [listPoint[1], listPoint[2]],
      [listPoint[2], listPoint[3]],
      [listPoint[3], listPoint[0]],
    ];

    int intersectionCount = 0;

    // Duyệt qua từng cạnh và kiểm tra giao điểm với tia nằm ngang
    for (var edge in edges) {
      Offset a = edge[0];
      Offset b = edge[1];

      // Kiểm tra xem tia nằm ngang có cắt qua cạnh này không
      if ((a.dy > checkPoint.dy) != (b.dy > checkPoint.dy)) {
        // Tính toán giao điểm
        double intersectX =
            (b.dx - a.dx) * (checkPoint.dy - a.dy) / (b.dy - a.dy) + a.dx;

        // Nếu giao điểm nằm bên phải điểm cần kiểm tra, tăng biến đếm
        if (checkPoint.dx < intersectX) {
          intersectionCount++;
        }
      }
    }

    // Nếu số lần cắt là lẻ, điểm nằm trong tứ giác
    return intersectionCount % 2 == 1;
  }
}
