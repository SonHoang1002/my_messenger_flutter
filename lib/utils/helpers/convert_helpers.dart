// import 'package:flutter/material.dart';
// import 'package:printtosize/commons/constants.dart';
// import 'package:printtosize/commons/log_custom.dart';

// class ConvertHelpers {
//   static const String _pixel = PIXEL;
//   static const String _inch = INCH;
//   static const String _millimeter = MILLIMETER;
//   static const String _centimeter = CENTIMETER;
//   static const String _point = POINT;
//   static const String _pica = PICA;
//   static const String _percent = PERCENT;

//   static const Map<String, double> _conversionFactors = {
//     'PixelToInch': 1 / 96,
//     'InchToPixel': 96,
//     'InchToMillimeter': 25.4,
//     'MillimeterToInch': 1 / 25.4,
//     'InchToCentimeter': 2.54,
//     'PointToPixelComputer': 4 / 3,
//     'PointToPixelPrinter': 1.3283520133,
//     'PointToInchComputer': 1 / 72,
//     'PointToInchPrinter': 0.0138370001,
//     'PicaToPixelComputer': 16,
//     'PicaToPixelPrinter': 15.940224,
//   };

//   /// Convert unit from [fromUnit] to [toUnit]
//   ///
//   /// Input:
//   ///  * [value] caculated by [fromUnit]
//   ///  * If [fromUnit] is [Percent], must have [originalValueByPixel] to convert
//   ///  * If [toUnit]   is [Percent], return to 100%
//   ///  * [isUseForComputer] is used to choose converted mode ( computer or printer ), default: [computer] mode.
//   ///
//   ///     (https://www.unitconverters.net/typography-converter.html)
//   ///
//   /// Output
//   ///  * value caculated by [toUnit]
//   static double convertUnit({
//     required double value,
//     required String fromUnit,
//     required String toUnit,
//     bool isUseForComputer = true,
//     double? originalValueByPixel,
//   }) {
//     try {
//       if (fromUnit == toUnit) {
//         debugPrint("convertUnit notice: fromUnit == toUnit");
//         return value;
//       }

//       if (!LIST_UNIT.contains(fromUnit) || !LIST_UNIT.contains(toUnit)) {
//         debugPrint("convertUnit warning: fromUnit or toUnit not supported");
//         return value;
//       }
//       switch (fromUnit) {
//         case _pixel:
//           return _convertFromPixel(value, toUnit, isUseForComputer);
//         case _inch:
//           return _convertFromInch(value, toUnit, isUseForComputer);
//         case _centimeter:
//           return _convertFromCentimeter(value, toUnit, isUseForComputer);
//         case _millimeter:
//           return _convertFromMillimeter(value, toUnit, isUseForComputer);
//         case _point:
//           return _convertFromPoint(value, toUnit, isUseForComputer);
//         case _pica:
//           return _convertFromPica(value, toUnit, isUseForComputer);
//         case _percent:
//           if (originalValueByPixel == null) {
//             throw Exception(
//                 "convertUnit error: if convert from [_percent] unit, must have [originalValueByPixel] to caculate!");
//           }
//           return _convertFromPercent(
//               value, originalValueByPixel, toUnit, isUseForComputer);
//         default:
//           throw Exception(
//               "convertUnit exception: invalid value: either fromUnit: ${fromUnit} or toUnit: ${toUnit}");
//       }
//     } catch (e, stackTrace) {
//       debugPrint('Error in convertUnit: $e, StackTrace: $stackTrace');
//       return value;
//     }
//   }

//   static double _convertFromPixel(
//     double value,
//     String toUnit,
//     bool isUseForComputer,
//   ) {
//     try {
//       switch (toUnit) {
//         case _pixel:
//           return value;
//         case _inch:
//           return value * _conversionFactors['PixelToInch']!;
//         case _centimeter:
//           return value *
//               _conversionFactors['PixelToInch']! *
//               _conversionFactors['InchToCentimeter']!;
//         case _millimeter:
//           return value *
//               _conversionFactors['PixelToInch']! *
//               _conversionFactors['InchToMillimeter']!;
//         case _point:
//           return isUseForComputer ? value / 4 * 3 : value * 0.7528125;
//         case _pica:
//           return isUseForComputer ? value * 0.0625 : value * 0.0627343756;
//         case _percent:
//           return 100;
//         default:
//           throw Exception(
//               "_convertFromInch exception: invalid toUnit: ${toUnit}");
//       }
//     } catch (e, stackTrace) {
//       debugPrint('Error in _convertFromPixel: $e, StackTrace: $stackTrace');
//       return value;
//     }
//   }

//   static double _convertFromInch(
//     double value,
//     String toUnit,
//     bool isUseForComputer,
//   ) {
//     try {
//       switch (toUnit) {
//         case _pixel:
//           return value * _conversionFactors['InchToPixel']!;
//         case _inch:
//           return value;
//         case _centimeter:
//           return value * _conversionFactors['InchToCentimeter']!;
//         case _millimeter:
//           return value * _conversionFactors['InchToMillimeter']!;
//         case _point:
//           return isUseForComputer ? value * 72 : value * 72.27;
//         case _pica:
//           return isUseForComputer ? value * 6 : value * 6.0225000602;
//         case _percent:
//           return 100;
//         default:
//           throw Exception(
//               "_convertFromInch exception: invalid toUnit: ${toUnit}");
//       }
//     } catch (e, stackTrace) {
//       debugPrint('Error in _convertFromInch: $e, StackTrace: $stackTrace');
//       return value;
//     }
//   }

//   static double _convertFromMillimeter(
//     double value,
//     String toUnit,
//     bool isUseForComputer,
//   ) {
//     try {
//       switch (toUnit) {
//         case _pixel:
//           return value /
//               _conversionFactors['InchToMillimeter']! *
//               _conversionFactors['InchToPixel']!;
//         case _inch:
//           return value * _conversionFactors['MillimeterToInch']!;
//         case _centimeter:
//           return value / 10;
//         case _millimeter:
//           return value;
//         case _point:
//           return isUseForComputer
//               ? value * 72 / _conversionFactors['InchToMillimeter']!
//               : value * 72.27 / _conversionFactors['InchToMillimeter']!;
//         case _pica:
//           return isUseForComputer
//               ? value * 6 / _conversionFactors['InchToMillimeter']!
//               : value * 6.0225000602 / _conversionFactors['InchToMillimeter']!;
//         case _percent:
//           return 100;
//         default:
//           throw Exception(
//               "_convertFromMillimeter exception: invalid toUnit: ${toUnit}");
//       }
//     } catch (e, stackTrace) {
//       debugPrint(
//           'Error in _convertFromMillimeter: $e, StackTrace: $stackTrace');
//       return value;
//     }
//   }

//   static double _convertFromCentimeter(
//     double value,
//     String toUnit,
//     bool isUseForComputer,
//   ) {
//     try {
//       switch (toUnit) {
//         case _pixel:
//           return value /
//               _conversionFactors['InchToCentimeter']! *
//               _conversionFactors['InchToPixel']!;
//         case _inch:
//           return value / _conversionFactors['InchToCentimeter']!;
//         case _centimeter:
//           return value;
//         case _millimeter:
//           return value * 10;
//         case _point:
//           return isUseForComputer
//               ? value * 72 / _conversionFactors['InchToCentimeter']!
//               : value * 72.27 / _conversionFactors['InchToCentimeter']!;
//         case _pica:
//           return isUseForComputer
//               ? value * 6 / _conversionFactors['InchToCentimeter']!
//               : value * 6.0225000602 / _conversionFactors['InchToCentimeter']!;
//         case _percent:
//           return 100;
//         default:
//           throw Exception(
//               "_convertFromCentimeter exception: invalid toUnit: ${toUnit}");
//       }
//     } catch (e, stackTrace) {
//       debugPrint(
//           'Error in _convertFromCentimeter: $e, StackTrace: $stackTrace');
//       return value;
//     }
//   }

//   static double _convertFromPoint(
//     double value,
//     String toUnit,
//     bool isUseForComputer,
//   ) {
//     try {
//       switch (toUnit) {
//         case _pixel:
//           return isUseForComputer
//               ? value * _conversionFactors['PointToPixelComputer']!
//               : _conversionFactors['PointToPixelPrinter']!;
//         case _inch:
//           return isUseForComputer
//               ? value * _conversionFactors['PointToInchComputer']!
//               : _conversionFactors['PointToInchPrinter']!;
//         case _centimeter:
//           return isUseForComputer
//               ? value * _conversionFactors['InchToMillimeter']! / 72 / 10
//               : value * 0.3514598035 / 10;
//         case _millimeter:
//           return isUseForComputer
//               ? value * _conversionFactors['InchToMillimeter']! / 72
//               : value * 0.3514598035;
//         case _point:
//           return value;
//         case _pica:
//           return isUseForComputer ? value * 0.0833333333 : value * 0.0833333342;
//         case _percent:
//           return 100;
//         default:
//           throw Exception(
//               "_convertFromPoint exception: invalid toUnit: ${toUnit}");
//       }
//     } catch (e, stackTrace) {
//       debugPrint('Error in _convertFromPoint: $e, StackTrace: $stackTrace');
//       return value;
//     }
//   }

//   static double _convertFromPica(
//     double value,
//     String toUnit,
//     bool isUseForComputer,
//   ) {
//     try {
//       switch (toUnit) {
//         case _pixel:
//           return isUseForComputer
//               ? value * _conversionFactors['PicaToPixelComputer']!
//               : _conversionFactors['PicaToPixelPrinter']!;
//         case _inch:
//           return isUseForComputer ? value * 0.1666666667 : 0.166044;
//         case _centimeter:
//           return isUseForComputer
//               ? value * 4.2333333333 / 10
//               : value * 4.2175176 / 10;
//         case _millimeter:
//           return isUseForComputer ? value * 4.2333333333 : value * 4.2175176;
//         case _point:
//           return isUseForComputer ? value * 12 : value * 11.99999988;
//         case _pica:
//           return value;
//         case _percent:
//           return 100;
//         default:
//           throw Exception(
//               "_convertFromPica exception: invalid toUnit: ${toUnit}");
//       }
//     } catch (e, stackTrace) {
//       debugPrint('Error in _convertFromPica: $e, StackTrace: $stackTrace');
//       return value;
//     }
//   }

//   static double _convertFromPercent(
//     double _percent,
//     double originalValueByPixel,
//     String toUnit,
//     bool isUseForComputer,
//   ) {
//     double convertValueByPixel = _percent / 100 * originalValueByPixel;
//     if (toUnit == _pixel) return convertValueByPixel;
//     return _convertFromPixel(convertValueByPixel, toUnit, isUseForComputer);
//   }

//   static String collapsedUnitToPreview(String? unit) {
//     try {
//       switch (unit) {
//         case _pixel:
//           return "px";
//         case _inch:
//           return "in";
//         case _centimeter:
//           return "cm";
//         case _millimeter:
//           return "mm";
//         case _point:
//           return "pt";
//         case _pica:
//           return "pc";
//         case _percent:
//           return "%";
//         default:
//           throw Exception(
//               "collapsedUnitToPreview error: unit is not in LIST_UNIT ");
//       }
//     } catch (e, stackTrace) {
//       debugPrint('Error in _convertFromPixel: $e, StackTrace: $stackTrace');
//       return "--";
//     }
//   }

//   static double convertUnitResolution(
//     double value,
//     String oldUnit,
//     String targetUnit,
//   ) {
//     try {
//       consolelog(
//           "convertUnitResolution oldUnit: ${oldUnit}, targetUnit: ${targetUnit}, value: ${value}");
//       double newResolution;
//       if (oldUnit == PIXELS_PER_CENTIMETER) {
//         if (targetUnit == PIXELS_PER_INCH) {
//           newResolution = value / 2.54;
//         } else if (targetUnit == PIXELS_PER_CENTIMETER) {
//           newResolution = value;
//         } else {
//           throw Exception("Please re-check oldUnit and targetUnit !!");
//         }
//       } else if (oldUnit == PIXELS_PER_INCH) {
//         if (targetUnit == PIXELS_PER_INCH) {
//           newResolution = value;
//         } else if (targetUnit == PIXELS_PER_CENTIMETER) {
//           newResolution = value * 2.54;
//         } else {
//           throw Exception("Please re-check oldUnit and targetUnit !!");
//         }
//       } else {
//         throw Exception("Please re-check oldUnit and targetUnit !!");
//       }

//       return newResolution;
//     } catch (e, stackTrace) {
//       debugPrint('Error in _convertFromPixel: $e, StackTrace: $stackTrace');
//       return value;
//     }
//   }

//   static Size convertUnitSize({
//     required Size size,
//     required String fromUnit,
//     required String toUnit,
//   }) {
//     double convertWidth =
//         convertUnit(value: size.width, fromUnit: fromUnit, toUnit: toUnit);
//     double convertHeight =
//         convertUnit(value: size.height, fromUnit: fromUnit, toUnit: toUnit);
//     return Size(convertWidth, convertHeight);
//   }

//   static List<double> convertRectToListPercent(
//     Rect rectOfImage,
//     Size paperSize,
//   ) {
//     double percentLeft = rectOfImage.left / paperSize.width * 100;
//     double percentTop = rectOfImage.top / paperSize.height * 100;

//     double percentRight = (1 - rectOfImage.right / paperSize.width) * 100;
//     double percentBottom = (1 - rectOfImage.bottom / paperSize.height) * 100;
//     return [percentLeft, percentTop, percentRight, percentBottom];
//   }

//   static Rect convertListPercentToRect(
//     List<double> listPercent,
//     Size paperSize,
//   ) {
//     return Rect.fromLTWH(
//       listPercent[0] / 100 * paperSize.width,
//       listPercent[1] / 100 * paperSize.height,
//       (1 - listPercent[2] / 100) * paperSize.width,
//       (1 - listPercent[3] / 100) * paperSize.height,
//     );
//   }
// }
