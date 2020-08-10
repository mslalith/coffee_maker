import 'package:coffee_maker/providers/coffee_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TitleText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<CoffeeProvider, String>(
      selector: (_, provider) => provider.title,
      builder: (_, title, child) => _TitleText(title: title),
    );
  }
}

class _TitleText extends StatefulWidget {
  final String title;

  const _TitleText({
    Key key,
    @required this.title,
  }) : super(key: key);

  @override
  _TitleTextState createState() => _TitleTextState();
}

class _TitleTextState extends State<_TitleText>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  String visibleTitle;
  String nextTitle = '';

  @override
  void initState() {
    super.initState();
    visibleTitle = widget.title;
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(_TitleText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.title != widget.title) {
      visibleTitle = oldWidget.title;
      nextTitle = widget.title;
      controller.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: 1.0 - controller.value,
          child: Transform(
            transform: Matrix4.identity()
              ..translate(-controller.value * 90, 0, 0)
              ..scale(0.6 + (1.0 - controller.value) * 0.4),
            alignment: Alignment.center,
            child: Container(
              height: 60.0,
              child: Center(
                child: Text(
                  visibleTitle,
                  style: Theme.of(context).textTheme.headline6.copyWith(
                    color: const Color(0xFF340818),
                  ),
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: controller.value,
          child: Transform(
            transform: Matrix4.identity()
              ..translate((1.0 - controller.value) * 90, 0, 0)
              ..scale(0.6 + (controller.value * 0.4)),
            alignment: Alignment.center,
            child: Container(
              height: 60.0,
              child: Center(
                child: Text(
                  nextTitle,
                  style: Theme.of(context).textTheme.headline6.copyWith(
                    color: const Color(0xFF340818),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
