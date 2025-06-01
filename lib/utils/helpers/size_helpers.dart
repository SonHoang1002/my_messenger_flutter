import 'package:flutter/material.dart';

class SizeHelpers {
  ///
  ///
  ///  [Android] API level 17:
  ///
  ///  (0 - LandscapeRight)
  ///
  ///  (90 - Portrait)
  ///
  ///  (180 - LandscapeLeft)
  ///
  ///  (270 - portraitUpsideDown)
  ///
  ///
  static Size getSizeFromOrientation(int? orientation, Size originalSize) {
    Size realSize = originalSize;

    switch (orientation) {
      case 0:
      case 180:
        realSize = originalSize;
        break;
      case 90:
      case 270:
        realSize = Size(originalSize.height, originalSize.width);
        break;
    }
    return realSize;
  }

  static Size getScreenSize(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return size;
  }

  /// Scale [realSize] to fit [previewSize]
  static Size resizeDestinationSize(
    Size realSize,
    Size previewSize,
  ) {
    return getAspectRatioSize(
      maxSize: previewSize,
      ratioTarget: realSize.aspectRatio,
    );
  }

  static Size getAspectRatioSize({
    required Size maxSize,
    required double ratioTarget,
  }) {
    double width, height;
    double ratioMaxSize = maxSize.aspectRatio;
    if (ratioMaxSize > ratioTarget) {
      height = maxSize.height;
      width = height * ratioTarget;
    } else if (ratioMaxSize < ratioTarget) {
      width = maxSize.width;
      height = width / ratioTarget;
    } else {
      width = maxSize.width;
      height = maxSize.height;
    }
    return Size(width, height);
  }
}
