import 'package:daytrit/utils/constants.dart';
import 'package:flutter/material.dart';

class LoadingOverlay extends StatefulWidget {
  final bool isLoading;
  final double opacity;
  final Color? color;
  final Widget progressIndicator;
  final Widget child;

  const LoadingOverlay({super.key, 
    required this.isLoading,
    required this.child,
    this.opacity = 0.5,
    this.progressIndicator = const CircularProgressIndicator(
      backgroundColor: AppColours.navyBlue,
      valueColor: AlwaysStoppedAnimation<Color>(AppColours.dayTritBlueLight),
    ),
    this.color,
  });

  @override
  _LoadingOverlayState createState() => _LoadingOverlayState();
}

class _LoadingOverlayState extends State<LoadingOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late bool _overlayVisible;

  // _LoadingOverlayState();

  @override
  void initState() {
    super.initState();
    _overlayVisible = false;
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _animation.addStatusListener((status) {
      // ignore: unnecessary_statements
      status == AnimationStatus.forward
          ? setState(() => _overlayVisible = true)
          : null;
      // ignore: unnecessary_statements
      status == AnimationStatus.dismissed
          ? setState(() => _overlayVisible = false)
          : null;
    });
    if (widget.isLoading) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(LoadingOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isLoading && widget.isLoading) {
      _controller.forward();
    }

    if (oldWidget.isLoading && !widget.isLoading) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];
    widgets.add(widget.child);

    if (_overlayVisible == true) {
      final modal = FadeTransition(
        opacity: _animation,
        child: Column(
          children: <Widget>[
            Opacity(
              opacity: widget.opacity,
              child: ModalBarrier(
                dismissible: false,
                color: widget.color ?? Color.fromRGBO(0, 0, 0, 0.5),
              ),
            ),
            Center(child: widget.progressIndicator),
          ],
        ),
      );
      widgets.add(modal);
    }

    return IgnorePointer(
        ignoring: _overlayVisible, child: Column(children: widgets));
  }
}

final centerLoader = CircularProgressIndicator(
  backgroundColor: AppColours.dayTritBlue,
  valueColor: AlwaysStoppedAnimation<Color>(AppColours.navyBlue),
);
