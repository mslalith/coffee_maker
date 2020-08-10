import 'package:coffee_maker/providers/coffee_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoffeeSizeIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<CoffeeProvider, String>(
      selector: (_, provider) => provider.coffeeSizeText,
      builder: (_, size, child) => _CoffeeSizeIndicator(size: size),
    );
  }
}

class _CoffeeSizeIndicator extends StatefulWidget {
  final String size;

  const _CoffeeSizeIndicator({
    Key key,
    @required this.size,
  }) : super(key: key);

  @override
  _CoffeeSizeIndicatorState createState() => _CoffeeSizeIndicatorState();
}

class _CoffeeSizeIndicatorState extends State<_CoffeeSizeIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  String visibleSize;
  String newSize = '';

  @override
  void initState() {
    super.initState();
    visibleSize = widget.size;
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          visibleSize = newSize;
          newSize = '';
          controller.reverse();
        }
      });
  }

  @override
  void didUpdateWidget(_CoffeeSizeIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.size != widget.size) {
      visibleSize = oldWidget.size;
      newSize = widget.size;
      controller.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Selector<CoffeeProvider, String>(
      selector: (_, provider) => provider.coffeeSizeText,
      builder: (_, size, child) {
        return Transform.scale(
          scale: 1.0 + controller.value / 2,
          child: Center(
            child: Text(
              visibleSize,
              style: TextStyle(
                color: const Color(0xFF340818),
                fontSize: 72.0,
              ),
            ),
          ),
        );
      },
    );
  }
}
