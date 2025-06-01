import 'dart:math';

class NumberHelpers {
  static double mapValueToNewRange(
    double value,
    double oldMin,
    double oldMax,
    double newMin,
    double newMax,
  ) {
    if (value < oldMin) value = oldMin;
    if (value > oldMax) value = oldMax;
    double newValue =
        ((value - oldMin) / (oldMax - oldMin)) * (newMax - newMin) + newMin;
    return newValue;
  }

  static int randomInt() {
    return Random().nextInt(10000);
  }

  static bool isQuarterNumber(double degree) {
    return degree == 90 || degree == 270;
  }
}
