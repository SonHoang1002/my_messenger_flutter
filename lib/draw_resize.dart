import 'dart:math' as math;
import 'package:flutter/material.dart';


void main(){
  runApp(const DragResizeScreen());
}
enum MediaPositionStatus {
  innerMedia,
  topLeft,
  topCenter,
  topRight,
  centerLeft,
  centerRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
}

class DragResizeScreen extends StatefulWidget {
  const DragResizeScreen({super.key});
  @override
  _DragResizeScreenState createState() => _DragResizeScreenState();
}

class _DragResizeScreenState extends State<DragResizeScreen> {
  MediaPositionStatus _positionStatus = MediaPositionStatus.innerMedia;
  Rect mainRect = const Rect.fromLTWH(100, 200, 200, 150);
  Rect _startRect = Rect.zero;
  Offset _startOffset = Offset.zero;
  double _angle = 0.0;
  double _startAngle = 0.0;
  double _scale = 1.0;
  double _startScale = 1.0;
  Size screenSize = Size.zero;

  // Màu sắc cải tiến với gradient
  static const Color blue = Color(0xFF2196F3);
  static const Color white = Colors.white;
  static const Color red = Colors.red;
  static const Color black = Colors.black;
  static const Color greenTextDark = Color(0xFF2E7D32);

  void _dragLogic({
    required double angle,
    required Offset dragVecInImageCoordinal,
    required Rect beginFrame,
    required Offset translate,
    required MediaPositionStatus position,
  }) {
    // Xoay vector kéo sang hệ tọa độ của giấy
    final dragVecInPaperCoordinal =
        _rotatePoint(dragVecInImageCoordinal, angle);

    // Tính chiều dài vector di chuyển
    final length = _getLength(translate);

    // Tính góc giữa vector di chuyển và vector kéo
    final dragAngle = _angleBetween(translate, dragVecInPaperCoordinal);

    // Tính độ dài bóng chiếu
    final vecLength = length * math.cos(dragAngle);

    // Tính vector bóng chiếu trong hệ tọa độ của giấy
    final dragTranslateInPaperCoordinal = Offset(
      vecLength *
          math.cos(_angleBetween(dragVecInPaperCoordinal, const Offset(1, 0))),
      vecLength *
          math.sin(_angleBetween(dragVecInPaperCoordinal, const Offset(1, 0))),
    );

    // Tính vector bóng chiếu trong hệ tọa độ của ảnh
    final dragTranslateInImageCoordinal =
        _rotatePoint(dragTranslateInPaperCoordinal, -angle);

    // Tính kích thước và vị trí mới dựa trên vị trí handle
    Size newSize;
    Offset newOrigin;
    print("dragTranslateInImageCoordinal: $dragTranslateInImageCoordinal");
    switch (position) {
      case MediaPositionStatus.topLeft:
        newSize = Size(
          beginFrame.width - dragTranslateInImageCoordinal.dx,
          beginFrame.height - dragTranslateInImageCoordinal.dy,
        );
        break;

      case MediaPositionStatus.topRight:
        newSize = Size(
          beginFrame.width + dragTranslateInImageCoordinal.dx,
          beginFrame.height - dragTranslateInImageCoordinal.dy,
        );
        break;

      case MediaPositionStatus.bottomRight:
        newSize = Size(
          beginFrame.width + dragTranslateInImageCoordinal.dx,
          beginFrame.height + dragTranslateInImageCoordinal.dy,
        );
        break;

      case MediaPositionStatus.bottomLeft:
        newSize = Size(
          beginFrame.width - dragTranslateInImageCoordinal.dx,
          beginFrame.height + dragTranslateInImageCoordinal.dy,
        );
        break;

      case MediaPositionStatus.topCenter:
        newSize = Size(
          beginFrame.width - dragTranslateInImageCoordinal.dy, // keep ratio
          beginFrame.height - dragTranslateInImageCoordinal.dy,
        );
        break;

      case MediaPositionStatus.bottomCenter:
        newSize = Size(
          beginFrame.width + dragTranslateInImageCoordinal.dy, // keep ratio
          beginFrame.height + dragTranslateInImageCoordinal.dy,
        );
        break;

      case MediaPositionStatus.centerLeft:
        newSize = Size(
          beginFrame.width - dragTranslateInImageCoordinal.dx,
          beginFrame.height - dragTranslateInImageCoordinal.dx, // keep ratio
        );
        break;

      case MediaPositionStatus.centerRight:
        newSize = Size(
          beginFrame.width + dragTranslateInImageCoordinal.dx,
          beginFrame.height + dragTranslateInImageCoordinal.dx, // keep ratio
        );
        break;

      default:
        newSize = beginFrame.size;
        newOrigin = beginFrame.topLeft;
        break;
    }

    newOrigin = Offset(
      beginFrame.center.dx +
          dragTranslateInPaperCoordinal.dx / 2 -
          newSize.width / 2,
      beginFrame.center.dy +
          dragTranslateInPaperCoordinal.dy / 2 -
          newSize.height / 2,
    );

    // Tạo khung mới
    final newFrame = Rect.fromLTWH(
      newOrigin.dx,
      newOrigin.dy,
      newSize.width,
      newSize.height,
    );

    // Cập nhật mainRect với validation
    if (newFrame.width > 50 && newFrame.height > 50) {
      setState(() {
        mainRect = newFrame;
      });
    }
  }

  // Utility functions
  Offset _rotatePoint(Offset point, double angle) {
    final cos = math.cos(angle);
    final sin = math.sin(angle);
    return Offset(
      point.dx * cos - point.dy * sin,
      point.dx * sin + point.dy * cos,
    );
  }

  double _getLength(Offset vector) {
    return math.sqrt(vector.dx * vector.dx + vector.dy * vector.dy);
  }

  double _angleBetween(Offset vector1, Offset vector2) {
    return math.atan2(vector1.dy, vector1.dx) -
        math.atan2(vector2.dy, vector2.dx);
  }

  Offset _getDragVector(MediaPositionStatus position) {
    switch (position) {
      case MediaPositionStatus.topLeft:
        return const Offset(-1, -1);
      case MediaPositionStatus.topCenter:
        return const Offset(0, -1);
      case MediaPositionStatus.topRight:
        return const Offset(1, -1);
      case MediaPositionStatus.centerLeft:
        return const Offset(-1, 0);
      case MediaPositionStatus.centerRight:
        return const Offset(1, 0);
      case MediaPositionStatus.bottomLeft:
        return const Offset(-1, 1);
      case MediaPositionStatus.bottomCenter:
        return const Offset(0, 1);
      case MediaPositionStatus.bottomRight:
        return const Offset(1, 1);
      default:
        return Offset.zero;
    }
  }

  void _onScaleUpdateDot(
    MediaPositionStatus position,
    ScaleUpdateDetails details,
  ) {
    final deltaDx = details.focalPoint.dx - _startOffset.dx;
    final deltaDy = details.focalPoint.dy - _startOffset.dy;
    final translate = Offset(deltaDx, deltaDy);

    // Xác định vector drag dựa trên vị trí handle
    Offset dragVecInImageCoordinal = _getDragVector(position);

    // Áp dụng logic Swift đã chuyển đổi
    _dragLogic(
      angle: _angle,
      dragVecInImageCoordinal: dragVecInImageCoordinal,
      beginFrame: _startRect,
      translate: translate,
      position: position,
    );
  }

  void _onScaleStartDot(
      MediaPositionStatus position, ScaleStartDetails details) {
    _positionStatus = position;
    _startRect = mainRect;
    _startOffset = details.focalPoint;
    _startAngle = _angle;
    _startScale = _scale;
    setState(() {});
  }

  void _onScaleEndDot(MediaPositionStatus position, ScaleEndDetails details) {
    _positionStatus = MediaPositionStatus.innerMedia;
  }

  Widget _buildHandle({
    required String label,
    required Color color,
    required Color textColor,
    required MediaPositionStatus position,
    required double size,
  }) {
    return GestureDetector(
      onTapDown: (_) {
        _positionStatus = position;
      },
      onScaleStart: (details) => _onScaleStartDot(position, details),
      onScaleUpdate: (details) => _onScaleUpdateDot(position, details),
      onScaleEnd: (details) => _onScaleEndDot(position, details),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [color.withOpacity(0.8), color],
            stops: const [0.3, 1.0],
          ),
          shape: BoxShape.circle,
          border: Border.all(color: white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    const handleSize = 28.0;

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Advanced Drag Resize'),
      //   backgroundColor: Colors.blueGrey[800],
      //   foregroundColor: Colors.white,
      //   elevation: 0,
      // ),
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          // Background grid pattern
          CustomPaint(
            size: screenSize,
            painter: GridPainter(),
          ),

          // Status indicator
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Position: ${_positionStatus.toString().split('.').last}',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),

          // Main draggable widget
          Positioned.fromRect(
            rect: mainRect,
            child: Transform.rotate(
              angle: _angle,
              child: GestureDetector(
                onTapDown: (details) {
                  _positionStatus = MediaPositionStatus.innerMedia;
                  setState(() {});
                },
                onScaleStart: (details) {
                  _startRect = mainRect;
                  _startOffset = details.focalPoint;
                  _startScale = _scale;
                  _startAngle = _angle;
                },
                onScaleUpdate: (details) {
                  double deltaDx = details.focalPoint.dx - _startOffset.dx;
                  double deltaDy = details.focalPoint.dy - _startOffset.dy;

                  if (details.pointerCount == 1) {
                    // Single finger - translate
                    var newRect = _startRect.translate(deltaDx, deltaDy);
                    if (newRect.left >= 0 &&
                        newRect.top >= 0 &&
                        newRect.right <= screenSize.width &&
                        newRect.bottom <= screenSize.height) {
                      mainRect = newRect;
                      setState(() {});
                    }
                  } else if (details.pointerCount == 2) {
                    // Two fingers - rotate and scale
                    _angle = _startAngle + details.rotation;
                    _scale = _startScale * details.scale;
                    setState(() {});
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        blue.withOpacity(0.7),
                        blue.withOpacity(0.9),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildHandle(
                            label: "TL",
                            color: Colors.blue,
                            textColor: white,
                            position: MediaPositionStatus.topLeft,
                            size: handleSize,
                          ),
                          _buildHandle(
                            label: "TC",
                            color: Colors.green,
                            textColor: white,
                            position: MediaPositionStatus.topCenter,
                            size: handleSize,
                          ),
                          _buildHandle(
                            label: "TR",
                            color: Colors.black,
                            textColor: white,
                            position: MediaPositionStatus.topRight,
                            size: handleSize,
                          ),
                        ],
                      ),

                      // Middle row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildHandle(
                            label: "CL",
                            color: Colors.pink,
                            textColor: white,
                            position: MediaPositionStatus.centerLeft,
                            size: handleSize,
                          ),
                          _buildHandle(
                            label: "CR",
                            color: Colors.grey,
                            textColor: white,
                            position: MediaPositionStatus.centerRight,
                            size: handleSize,
                          ),
                        ],
                      ),

                      // Bottom row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildHandle(
                            label: "BL",
                            color: Colors.yellow,
                            textColor: black,
                            position: MediaPositionStatus.bottomLeft,
                            size: handleSize,
                          ),
                          _buildHandle(
                            label: "BC",
                            color: Colors.cyanAccent,
                            textColor: black,
                            position: MediaPositionStatus.bottomCenter,
                            size: handleSize,
                          ),
                          _buildHandle(
                            label: "BR",
                            color: Colors.indigo,
                            textColor: white,
                            position: MediaPositionStatus.bottomRight,
                            size: handleSize,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for grid background
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 0.5;

    const spacing = 20.0;

    // Draw vertical lines
    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
