import 'package:flutter/material.dart';
import 'package:my_messenger_app_flu/utils/extensions.dart';
void popNavigator(BuildContext context) {
  Navigator.of(context).pop();
}

void pushNavigator(BuildContext context, Widget newScreen) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => newScreen));
}

void pushNavigator1(
  BuildContext context,
  Widget newScreen, {
  Duration? transitionDuration,
  Duration? reverseTransitionDuration,
}) {
  Navigator.push(
    context,
    MaterialPageRouteBuilder(
      transitionDuration: transitionDuration ?? 500.ms,
      reverseTransitionDuration: reverseTransitionDuration ?? 500.ms,
      pageBuilder: (conext, __, ___) => newScreen,
      opaque: false,
    ),
  );
}

/// Sử dụng trong trường hợp trước đó đã pop navigator -> context đã bị huỷ
///
/// --> Hàm này sử dụng context trong builder cung cấp nên sẽ không bị trường hợp trên
void pushNavigator2(
  BuildContext context,
  Widget Function(
    BuildContext,
    Animation<double>,
    Animation<double>,
  ) pageBuilder, {
  Duration transitionDuration = const Duration(milliseconds: 500),
  Duration reverseTransitionDuration = const Duration(milliseconds: 500),
}) {
  Navigator.push(
    context,
    MaterialPageRouteBuilder(
      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration,
      pageBuilder: pageBuilder,
      opaque: false,
    ),
  );
}

void pushAndRemoveUntilNavigator(BuildContext context, Widget newScreen) {
  Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => newScreen), (route) => false);
}

void pushAndReplaceToNextScreen(BuildContext context, Widget newScreen) {
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (_) => newScreen));
}

void pushAndReplaceNamedToNextScreen(
    BuildContext context, String newRouteLink) {
  Navigator.of(context).pushReplacementNamed(newRouteLink);
}

Widget _defaultTransitionsBuilder(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return child;
}

class MaterialPageRouteBuilder<T> extends PageRoute<T> {
  MaterialPageRouteBuilder({
    super.settings,
    required this.pageBuilder,
    this.transitionsBuilder = _defaultTransitionsBuilder,
    this.transitionDuration = const Duration(milliseconds: 500),
    this.reverseTransitionDuration = const Duration(milliseconds: 500),
    this.opaque = false,
    this.barrierDismissible = false,
    this.barrierColor,
    this.barrierLabel,
    this.maintainState = true,
    super.fullscreenDialog,
    super.allowSnapshotting = true,
  });

  final RoutePageBuilder pageBuilder;
  final RouteTransitionsBuilder transitionsBuilder;

  @override
  final Duration transitionDuration;

  @override
  final Duration reverseTransitionDuration;

  @override
  final bool opaque;

  @override
  final bool barrierDismissible;

  @override
  final Color? barrierColor;

  @override
  final String? barrierLabel;

  @override
  final bool maintainState;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return pageBuilder(context, animation, secondaryAnimation);
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return transitionsBuilder(context, animation, secondaryAnimation, child);
  }
}
