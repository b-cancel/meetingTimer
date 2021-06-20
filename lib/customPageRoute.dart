import 'package:flutter/material.dart';

class VerticalSlidePageTransition<T> extends PageRouteBuilder<T> {
  final bool animateDown;

  /// Child for your next page
  final Widget child;

  /// Child for your next page
  final Widget childCurrent;

  /// Curves for transitions
  final Curve curve;

  /// Aligment for transitions
  final Alignment? alignment;

  /// Durationf for your transition default is 300 ms
  final Duration duration;

  /// Duration for your pop transition default is 300 ms
  final Duration reverseDuration;

  /// Context for inheret theme
  final BuildContext? ctx;

  /// Optional inheret teheme
  final bool inheritTheme;

  /// Page transition constructor. We can pass the next page as a child,
  VerticalSlidePageTransition({
    Key? key,
    required this.animateDown,
    required this.child,
    required this.childCurrent,
    this.ctx,
    this.inheritTheme = false,
    this.curve = Curves.linear,
    this.alignment,
    this.duration = const Duration(milliseconds: 300),
    this.reverseDuration = const Duration(milliseconds: 300),
    RouteSettings? settings,
  })  : assert(inheritTheme ? ctx != null : true,
            "'ctx' cannot be null when 'inheritTheme' is true, set ctx: context"),
        super(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return inheritTheme
                ? InheritedTheme.captureAll(
                    ctx!,
                    child,
                  )
                : child;
          },
          transitionDuration: duration,
          reverseTransitionDuration: reverseDuration,
          settings: settings,
          maintainState: true,
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            if (animateDown) {
              return Stack(
                children: <Widget>[
                  SlideTransition(
                    position: Tween<Offset>(
                      //begin: const Offset(-1.0, 0.0),
                      begin: Offset(0.0, -1.0),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: curve,
                      ),
                    ),
                    child: child,
                  ),
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset.zero,
                      end: Offset(0.0, 1.0),
                      //end: Offset(1.0, 0.0),
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: curve,
                      ),
                    ),
                    child: childCurrent,
                  )
                ],
              );
            } else {
              return Stack(
                children: <Widget>[
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset.zero,
                      //end: Offset(-1.0, 0.0),
                      end: Offset(0.0, -1.0),
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: curve,
                      ),
                    ),
                    child: childCurrent,
                  ),
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(0.0, 1.0),
                      //begin: Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: curve,
                      ),
                    ),
                    child: child,
                  )
                ],
              );
            }
          },
        );
}
