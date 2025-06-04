// import 'package:flutter/material.dart';
// import 'package:my_messenger_app_flu/pages/home_page.dart';
// import 'package:my_messenger_app_flu/pages/login_page.dart';
// import 'package:my_messenger_app_flu/services/auth_service.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Login UI',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: FutureBuilder(
//         future: AuthService().isLoggedIn(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Scaffold(
//               body: Center(child: CircularProgressIndicator()),
//             );
//           }
//           return snapshot.data == true ? const HomePage() : const LoginPage();
//         },
//       ),
//       routes: {
//         '/login': (context) => const LoginPage(),
//         '/home': (context) => const HomePage(),
//       },
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_messenger_app_flu/config/constant.dart';
import 'package:my_messenger_app_flu/draw_resize.dart';
import 'package:my_messenger_app_flu/utils/extensions.dart';
import 'package:my_messenger_app_flu/utils/helpers/size_helpers.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List Item Example',
      home: DragResizeScreen(),
    );
  }
}

class ItemListWidget extends StatefulWidget {
  const ItemListWidget({super.key});

  @override
  State<ItemListWidget> createState() => _ItemListWidgetState();
}

class _ItemListWidgetState extends State<ItemListWidget>
    with TickerProviderStateMixin {
  Size reactionBoxSize = Size(250 + 32, 45);
  Offset? _startOffset, _updateOffset;
  Offset? _startOffsetBegin;

  OverlayEntry? _reactionOverlayEntry;
  final ValueNotifier<String?> _hoveredReaction = ValueNotifier(null);

  late AnimationController _animationController;

  late Animation<double> _animationReactionBox, _animationReactionIcon;

  bool get isShowingReactionBox => _reactionOverlayEntry != null;

  bool get isHaveHover => _hoveredReaction.value != null;

  Offset get reactionOffset {
    Size screenSize = SizeHelpers.getScreenSize(context);
    Offset abc;
    double dx = clampDouble(
      _startOffsetBegin!.dx - reactionBoxSize.width / 2,
      0,
      screenSize.width - reactionBoxSize.width,
    );

    double dy = clampDouble(
      _startOffsetBegin!.dy - reactionBoxSize.height - 20,
      0,
      screenSize.height - reactionBoxSize.height,
    );
    abc = Offset(dx, dy);
    //   abc = _startOffsetBegin!.translate(
    //   -reactionBoxSize.width / 2,
    //   -reactionBoxSize.height / 2 - 20,
    // );
    return abc;
  }

  Rect get rectLike {
    Offset a = reactionOffset;
    Offset b = reactionOffset.translate(
        reactionBoxSize.width / 6, reactionBoxSize.height + 20);

    return Rect.fromPoints(a, b);
  }

  Rect get rectHeart {
    return rectLike.translate(reactionBoxSize.width / 6, 0);
  }

  Rect get rectHaha {
    return rectHeart.translate(reactionBoxSize.width / 6, 0);
  }

  Rect get rectWow {
    return rectHaha.translate(reactionBoxSize.width / 6, 0);
  }

  Rect get rectYay {
    return rectWow.translate(reactionBoxSize.width / 6, 0);
  }

  Rect get rectSad {
    return rectYay.translate(reactionBoxSize.width / 6, 0);
  }

  Rect get rectAngry {
    return rectSad.translate(reactionBoxSize.width / 6, 0);
  }

  void _removeReactionOverlay() {
    _reactionOverlayEntry?.remove();
    _reactionOverlayEntry = null;
  }

  void _showReactionOverlay() {
    if (_startOffset == null) return;

    _removeReactionOverlay();

    _animationController = AnimationController(
      vsync: this,
      duration: 350.ms,
      reverseDuration: 250.ms,
    );

    _animationReactionBox = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );
    _animationReactionIcon = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );
    _animationController.forward();

    _reactionOverlayEntry = OverlayEntry(
      builder: (context) => StatefulBuilder(
        builder: (context, setStateForOverlay) {
          return Positioned(
            left: reactionOffset.dx,
            top: reactionOffset.dy,
            child: Material(
              color: Colors.transparent,
              child: ValueListenableBuilder(
                valueListenable: _hoveredReaction,
                builder: (context, _, __) {
                  return AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, _) {
                      return Opacity(
                        opacity: _animationReactionBox.value,
                        child: GestureDetector(
                          onTapDown: _onTapDownReactBox,
                          onPanUpdate: _onPanUpdateReactBox,
                          onPanEnd: _onPanEndReactBox,
                          child: Container(
                            width: reactionBoxSize.width,
                            height: reactionBoxSize.height,
                            padding: EdgeInsets.all(8),
                            transform: Matrix4.identity()
                              ..scale(
                                1.0,
                                isHaveHover ? 0.95 : 1.0,
                                1.0,
                              ),
                            transformAlignment: Alignment.bottomCenter,
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(90),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildReactionButton(
                                  PATH_LIKE_GIF,
                                  setStateForOverlay,
                                ),
                                _buildReactionButton(
                                  PATH_LOVE_GIF,
                                  setStateForOverlay,
                                ),
                                _buildReactionButton(
                                  PATH_HAHA_GIF,
                                  setStateForOverlay,
                                ),
                                _buildReactionButton(
                                  PATH_WOW_GIF,
                                  setStateForOverlay,
                                ),
                                _buildReactionButton(
                                  PATH_YAY_GIF,
                                  setStateForOverlay,
                                ),
                                _buildReactionButton(
                                  PATH_SAD_GIF,
                                  setStateForOverlay,
                                ),
                                _buildReactionButton(
                                  PATH_ANGRY_GIF,
                                  setStateForOverlay,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );

    Overlay.of(context).insert(_reactionOverlayEntry!);

    setState(() {});
  }

  void _onLongPressDown(LongPressDownDetails details) {
    if (_reactionOverlayEntry != null) return;
    _startOffsetBegin = _startOffset = details.globalPosition;
    _updateOffset = null;
    _showReactionOverlay();
  }

  void _onLongPressStart(LongPressStartDetails details) {}

  void _onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    _updateOffset = details.globalPosition;
    print("_onLongPressMoveUpdate: call -> $_updateOffset");

    if (rectLike.contains(_updateOffset!) == true) {
      print("_onPanUpdate: LIKE");
      _hoveredReaction.value = PATH_LIKE_GIF;
    } else if (rectHeart.contains(_updateOffset!) == true) {
      print("_onPanUpdate: LOVE");
      _hoveredReaction.value = PATH_LOVE_GIF;
    } else if (rectHaha.contains(_updateOffset!) == true) {
      print("_onPanUpdate: HAHA");
      _hoveredReaction.value = PATH_HAHA_GIF;
    } else if (rectWow.contains(_updateOffset!) == true) {
      print("_onPanUpdate: WOW");
      _hoveredReaction.value = PATH_WOW_GIF;
    } else if (rectYay.contains(_updateOffset!) == true) {
      print("_onPanUpdate: YAY");
      _hoveredReaction.value = PATH_YAY_GIF;
    } else if (rectSad.contains(_updateOffset!) == true) {
      print("_onPanUpdate: SAD");
      _hoveredReaction.value = PATH_SAD_GIF;
    } else if (rectAngry.contains(_updateOffset!) == true) {
      print("_onPanUpdate: ANGRY");
      _hoveredReaction.value = PATH_ANGRY_GIF;
    } else {
      _hoveredReaction.value = null;
    }
    setState(() {});
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    _startOffset = _updateOffset = null;
    if (_hoveredReaction.value != null) {
      _removeReactionOverlay();
      // cal api
      _hoveredReaction.value = null;
      setState(() {});
    }
  }

  void _onTapDownReactBox(TapDownDetails details) {
    _updateOffset = details.globalPosition;

    if (rectLike.contains(_updateOffset!) == true) {
      _hoveredReaction.value = PATH_LIKE_GIF;
    } else if (rectHeart.contains(_updateOffset!) == true) {
      _hoveredReaction.value = PATH_LOVE_GIF;
    } else if (rectHaha.contains(_updateOffset!) == true) {
      _hoveredReaction.value = PATH_HAHA_GIF;
    } else if (rectWow.contains(_updateOffset!) == true) {
      _hoveredReaction.value = PATH_WOW_GIF;
    } else if (rectYay.contains(_updateOffset!) == true) {
      _hoveredReaction.value = PATH_YAY_GIF;
    } else if (rectSad.contains(_updateOffset!) == true) {
      _hoveredReaction.value = PATH_SAD_GIF;
    } else if (rectAngry.contains(_updateOffset!) == true) {
      _hoveredReaction.value = PATH_ANGRY_GIF;
    } else {
      _hoveredReaction.value = null;
    }
  }

  void _onPanUpdateReactBox(DragUpdateDetails details) {
    _updateOffset = details.globalPosition;

    if (rectLike.contains(_updateOffset!) == true) {
      _hoveredReaction.value = PATH_LIKE_GIF;
    } else if (rectHeart.contains(_updateOffset!) == true) {
      _hoveredReaction.value = PATH_LOVE_GIF;
    } else if (rectHaha.contains(_updateOffset!) == true) {
      _hoveredReaction.value = PATH_HAHA_GIF;
    } else if (rectWow.contains(_updateOffset!) == true) {
      _hoveredReaction.value = PATH_WOW_GIF;
    } else if (rectYay.contains(_updateOffset!) == true) {
      _hoveredReaction.value = PATH_YAY_GIF;
    } else if (rectSad.contains(_updateOffset!) == true) {
      _hoveredReaction.value = PATH_SAD_GIF;
    } else if (rectAngry.contains(_updateOffset!) == true) {
      _hoveredReaction.value = PATH_ANGRY_GIF;
    } else {
      _hoveredReaction.value = null;
    }
    setState(() {});
  }

  void _onPanEndReactBox(DragEndDetails details) {
    _startOffset = _updateOffset = null;
    if (_hoveredReaction.value != null) {
      _removeReactionOverlay();
      // cal api
      _hoveredReaction.value = null;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
    _hoveredReaction.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("_hoveredReaction.value = ${_hoveredReaction.value}");
    return Scaffold(
      body: Stack(
        children: [
          ListView.builder(
            itemCount: 100,
            itemBuilder: (context, index) {
              return RawGestureDetector(
                gestures: <Type, GestureRecognizerFactory>{
                  LongPressGestureRecognizer:
                      GestureRecognizerFactoryWithHandlers<
                          LongPressGestureRecognizer>(
                    () => LongPressGestureRecognizer(
                      duration: Duration(milliseconds: 1000),
                    ),
                    (LongPressGestureRecognizer instance) {
                      instance
                        ..onLongPressDown = _onLongPressDown
                        ..onLongPressStart = _onLongPressStart
                        ..onLongPressMoveUpdate = _onLongPressMoveUpdate
                        ..onLongPressEnd = _onLongPressEnd;
                    },
                  ),
                  PanGestureRecognizer: GestureRecognizerFactoryWithHandlers<
                      PanGestureRecognizer>(
                    () => PanGestureRecognizer(),
                    (PanGestureRecognizer instance) {
                      instance
                        ..onStart = (_) {} // Không làm gì khi bắt đầu kéo
                        ..onUpdate = (_) {} // Không làm gì khi cập nhật kéo
                        ..onEnd = (_) {}; // Không làm gì khi kết thúc kéo
                    },
                  ),
                },
                // behavior: HitTestBehavior.opaque,
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 12.0),
                  child: Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Reaction $index", style: TextStyle(fontSize: 12)),
                      Divider(thickness: 2),
                      Text("Comment $index", style: TextStyle(fontSize: 12)),
                      Divider(thickness: 2),
                      Text("Share $index", style: TextStyle(fontSize: 12))
                    ],
                  ),
                ),
              );
            },
          ),
          if (isShowingReactionBox)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  _removeReactionOverlay();
                  setState(() {});
                },
                child: Container(
                  color: Colors.red.withValues(alpha: 0.4),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReactionButton(
    String emojiGif,
    void Function(void Function()) rebuild, {
    Size size = const Size(30, 30),
    EdgeInsets margin = EdgeInsets.zero,
  }) {
    bool isFocus = _hoveredReaction.value == emojiGif;
    double scale = (isFocus ? 1.5 : (isHaveHover ? 0.85 : 1.0));
    print(
        "_hoveredReaction.value_hoveredReaction.value : ${_hoveredReaction.value}");
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.symmetric(horizontal: 4),
      transform: Matrix4.identity()..scale(scale),
      transformAlignment: Alignment.bottomCenter,
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.red,
        ),
        margin: margin,
        child: Image.asset(
          emojiGif,
          width: size.width,
          height: size.height,
        ),
      ),
    );
  }
}
