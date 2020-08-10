import 'dart:ui';

import 'package:coffee_maker/providers/coffee_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoffeeCup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CoffeeProvider>(
      builder: (_, provider, child) => _CoffeeCup(
        coffeeSize: provider.coffeeSize,
        foam: provider.foam,
      ),
    );
  }
}

class _CoffeeCup extends StatefulWidget {
  final CoffeeSize coffeeSize;
  final double foam;

  const _CoffeeCup({
    Key key,
    @required this.coffeeSize,
    @required this.foam,
  }) : super(key: key);

  @override
  __CoffeeCupState createState() => __CoffeeCupState();
}

class __CoffeeCupState extends State<_CoffeeCup>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  CoffeeSize lastCupSize;

  @override
  void initState() {
    super.initState();
    lastCupSize = widget.coffeeSize;
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    )..addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(_CoffeeCup oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.coffeeSize != widget.coffeeSize) {
      lastCupSize = oldWidget.coffeeSize;
      controller.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CoffeeCupPainter(
        cupSize: widget.coffeeSize,
        lastCupSize: lastCupSize,
        foam: widget.foam,
        animPercent: controller.value,
      ),
      size: Size.infinite,
    );
  }
}

class CoffeeCupPainter extends CustomPainter {
  final CoffeeSize cupSize;
  final CoffeeSize lastCupSize;
  final double foam;
  final Color cupColor;
  final Color foamColor;
  final Color backgroundColor;
  final double animPercent;
  final strokeWidth;
  Paint cupPaint;
  Paint foamPaint;
  Paint backgroundPaint;

  CoffeeCupPainter({
    @required this.cupSize,
    @required this.lastCupSize,
    @required this.foam,
    @required this.animPercent,
    this.strokeWidth = 10.0,
    this.cupColor = const Color(0xFF340818),
    this.foamColor = Colors.yellow,
    this.backgroundColor = Colors.white,
  })  : foamPaint = Paint()..color = foamColor,
        backgroundPaint = Paint()..color = backgroundColor,
        cupPaint = Paint()
          ..color = cupColor
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    int index = CoffeeSize.values.indexOf(cupSize);
    int lastIndex = CoffeeSize.values.indexOf(lastCupSize);

    double widthBasePercent = 0.3;
    double widthIncrementPercent = 0.04;
    double widthPercent = widthBasePercent;
    if (index > 2 || lastIndex == 3) {
      widthPercent = lerpDouble(
        widthPercent - (widthIncrementPercent * (lastIndex - 2)),
        widthPercent - (widthIncrementPercent * (index - 2)),
        animPercent,
      );
    } else {
      widthPercent = widthBasePercent;
    }

    Size cupStartPercent = Size(widthPercent, 0.3);

    double mouthCurvePercent = 0.3;
    double bodyBottomOffsetPercent = 0.23;
    double bodyBaseHeightPercent = 0.4;
    double bodyIncrementPercent = 0.1;
    _drawCupHandle(
      canvas,
      size,
      cupStartPercent,
      bodyBaseHeightPercent,
      bodyIncrementPercent,
      bodyBottomOffsetPercent,
    );
    _drawFoam(
      canvas,
      size,
      cupStartPercent,
      mouthCurvePercent,
      bodyBaseHeightPercent,
      bodyBottomOffsetPercent,
      bodyIncrementPercent,
    );
    _drawCupMouth(
      canvas,
      size,
      cupStartPercent,
      mouthCurvePercent,
    );
    _drawCupBody(
      canvas,
      size,
      cupStartPercent,
      bodyBaseHeightPercent,
      bodyBottomOffsetPercent,
      bodyIncrementPercent,
    );
  }

  void _drawCupMouth(
    Canvas canvas,
    Size size,
    Size cupStartPercent,
    double mouthCurvePercent,
  ) {
    Size mouthStart = Size(
      size.width * cupStartPercent.width,
      size.height * cupStartPercent.height,
    );
    Size mouthEnd = Size(
      size.width - mouthStart.width,
      mouthStart.height,
    );
    Size mouthSize = Size(
      mouthEnd.width - mouthStart.width,
      mouthStart.height,
    );

    final cupMouthTop = Path()
      ..moveTo(mouthStart.width, mouthStart.height)
      ..quadraticBezierTo(
        mouthStart.width + mouthSize.width * (mouthCurvePercent * 0.3),
        mouthStart.height - mouthSize.height * (mouthCurvePercent * 0.28) * 0.9,
        mouthStart.width + mouthSize.width * mouthCurvePercent,
        mouthStart.height - mouthSize.height * (mouthCurvePercent * 0.28),
      )
      ..quadraticBezierTo(
        (mouthEnd.width + mouthStart.width) / 2,
        mouthEnd.height -
            mouthSize.height * (mouthCurvePercent * 0.28) -
            (mouthCurvePercent * 4),
        mouthEnd.width - mouthSize.width * mouthCurvePercent,
        mouthEnd.height - mouthSize.height * (mouthCurvePercent * 0.28),
      )
      ..quadraticBezierTo(
        mouthEnd.width - mouthSize.width * (mouthCurvePercent * 0.3),
        mouthEnd.height - mouthSize.height * (mouthCurvePercent * 0.28) * 0.9,
        mouthEnd.width,
        mouthEnd.height,
      );

    final cupMouthBottom = Path()
      ..moveTo(mouthEnd.width, mouthEnd.height)
      ..quadraticBezierTo(
        mouthEnd.width - mouthSize.width * (mouthCurvePercent * 0.3),
        mouthEnd.height + mouthSize.height * (mouthCurvePercent * 0.28) * 0.9,
        mouthEnd.width - mouthSize.width * mouthCurvePercent,
        mouthEnd.height + mouthSize.height * (mouthCurvePercent * 0.28),
      )
      ..quadraticBezierTo(
        (mouthEnd.width + mouthStart.width) / 2,
        mouthStart.height +
            mouthSize.height * (mouthCurvePercent * 0.28) +
            (mouthCurvePercent * 4),
        mouthStart.width + mouthSize.width * mouthCurvePercent,
        mouthStart.height + mouthSize.height * (mouthCurvePercent * 0.28),
      )
      ..quadraticBezierTo(
        mouthStart.width + mouthSize.width * (mouthCurvePercent * 0.3),
        mouthStart.height + mouthSize.height * (mouthCurvePercent * 0.28) * 0.9,
        mouthStart.width,
        mouthStart.height,
      );

    canvas.drawPath(
      cupMouthTop,
      cupPaint,
    );
    canvas.drawPath(
      cupMouthBottom,
      cupPaint..strokeWidth = strokeWidth / 2,
    );
    cupPaint..strokeWidth = strokeWidth;
  }

  void _drawCupBody(
    Canvas canvas,
    Size size,
    Size cupStartPercent,
    double bodyBaseHeightPercent,
    double bodyBottomOffsetPercent,
    double bodyIncrementPercent,
  ) {
    Size bodyStart = Size(
      size.width * cupStartPercent.width,
      size.height * cupStartPercent.height,
    );
    Size bodyEnd = Size(
      size.width - bodyStart.width,
      bodyStart.height,
    );
    Size bodySize = Size(
      bodyEnd.width - bodyStart.width,
      size.height * (1.0 - cupStartPercent.height) - bodyStart.height,
    );

    int index = CoffeeSize.values.indexOf(cupSize);
    int lastIndex = CoffeeSize.values.indexOf(lastCupSize);
    double bodyHeightPercent = bodyBaseHeightPercent;

    if (index <= 2 && lastIndex != 3) {
      bodyHeightPercent = lerpDouble(
        bodyHeightPercent + (bodyIncrementPercent * lastIndex),
        bodyHeightPercent + (bodyIncrementPercent * index),
        animPercent,
      );
    } else {
      bodyHeightPercent = bodyHeightPercent + (bodyIncrementPercent * 2);
    }

    final cupBody = Path()
      ..moveTo(bodyStart.width, bodyStart.height)
      ..quadraticBezierTo(
        bodyStart.width + (bodySize.width * 0.05),
        (bodyStart.height + bodySize.height * (bodyHeightPercent)) * 0.9,
        bodyStart.width + (bodySize.width * bodyBottomOffsetPercent),
        bodyStart.height + (bodySize.height * (bodyHeightPercent)),
      )
      ..quadraticBezierTo(
        bodyStart.width + (bodyEnd.width - bodyStart.width) / 2,
        bodyEnd.height + (bodySize.height * (bodyHeightPercent + 0.06)),
        bodyEnd.width - (bodySize.width * bodyBottomOffsetPercent),
        bodyEnd.height + (bodySize.height * (bodyHeightPercent)),
      )
      ..quadraticBezierTo(
        bodyEnd.width - (bodySize.width * 0.05),
        (bodyEnd.height + bodySize.height * (bodyHeightPercent)) * 0.9,
        bodyEnd.width,
        bodyEnd.height,
      );

    canvas.drawPath(
      cupBody,
      cupPaint,
    );
  }

  void _drawCupHandle(
    Canvas canvas,
    Size size,
    Size cupStartPercent,
    double bodyBaseHeightPercent,
    double bodyIncrementPercent,
    double bodyBottomOffsetPercent,
  ) {
    Size bodyStart = Size(
      size.width * cupStartPercent.width,
      size.height * cupStartPercent.height,
    );
    Size bodyEnd = Size(
      size.width - bodyStart.width,
      bodyStart.height,
    );
    Size bodySize = Size(
      bodyEnd.width - bodyStart.width,
      size.height * (1.0 - cupStartPercent.height) - bodyStart.height,
    );

    int index = CoffeeSize.values.indexOf(cupSize);
    int lastIndex = CoffeeSize.values.indexOf(lastCupSize);
    double bodyHeightPercent = bodyBaseHeightPercent;

    if (index <= 2 && lastIndex != 3) {
      bodyHeightPercent = lerpDouble(
        bodyHeightPercent + (bodyIncrementPercent * lastIndex),
        bodyHeightPercent + (bodyIncrementPercent * index),
        animPercent,
      );
    } else {
      bodyHeightPercent = bodyHeightPercent + (bodyIncrementPercent * 2);
    }

    final handlePath = Path()
      ..moveTo(
        bodyEnd.width * 0.9,
        bodyStart.height + (bodySize.height * bodyHeightPercent * 0.3),
      )
      ..cubicTo(
        bodyEnd.width + (bodySize.width * bodyHeightPercent * 0.9),
        bodyEnd.height + (bodySize.height * 0.1),
        bodyEnd.width + (bodySize.width * 0.3),
        bodyEnd.height + (bodySize.height * bodyHeightPercent),
        bodyEnd.width - (bodySize.width * bodyBottomOffsetPercent),
        bodyEnd.height + (bodySize.height * bodyHeightPercent * 0.8),
      );

    canvas.drawPath(
      handlePath,
      cupPaint..strokeWidth = strokeWidth / 2,
    );
    cupPaint..strokeWidth = strokeWidth;
  }

  void _drawFoam(
    Canvas canvas,
    Size size,
    Size cupStartPercent,
    double mouthCurvePercent,
    double bodyBaseHeightPercent,
    double bodyBottomOffsetPercent,
    double bodyIncrementPercent,
  ) {
    Size foamTopLeft = Size(
      size.width * cupStartPercent.width,
      size.height * cupStartPercent.height,
    );
    Size foamBottomRight = Size(
      size.width - foamTopLeft.width,
      size.height * (1.0 - cupStartPercent.height) - foamTopLeft.height,
    );
    Size mouthSize = Size(
      foamBottomRight.width - foamTopLeft.width,
      foamTopLeft.height,
    );
    Size bodySize = Size(
      foamBottomRight.width - foamTopLeft.width,
      size.height * (1.0 - cupStartPercent.height) - foamTopLeft.height,
    );

    int index = CoffeeSize.values.indexOf(cupSize);
    int lastIndex = CoffeeSize.values.indexOf(lastCupSize);
    double changeOffsetPercent = bodyBaseHeightPercent;
    double foamPercent = foam / 100;

    if (index <= 2 && lastIndex != 3) {
      changeOffsetPercent = lerpDouble(
        changeOffsetPercent + (bodyIncrementPercent * lastIndex),
        changeOffsetPercent + (bodyIncrementPercent * index),
        animPercent,
      );
    } else {
      changeOffsetPercent = changeOffsetPercent + (bodyIncrementPercent * 2);
    }

    final foamPath = Path()
      ..moveTo(foamTopLeft.width, foamTopLeft.height)
      ..quadraticBezierTo(
        foamTopLeft.width + mouthSize.width * (mouthCurvePercent * 0.3),
        foamTopLeft.height -
            mouthSize.height * (mouthCurvePercent * 0.28) * 0.9,
        foamTopLeft.width + mouthSize.width * mouthCurvePercent,
        foamTopLeft.height - mouthSize.height * (mouthCurvePercent * 0.28),
      )
      ..quadraticBezierTo(
        (foamBottomRight.width + foamTopLeft.width) / 2,
        foamTopLeft.height -
            mouthSize.height * (mouthCurvePercent * 0.28) -
            (mouthCurvePercent * 4),
        foamBottomRight.width - mouthSize.width * mouthCurvePercent,
        foamTopLeft.height - mouthSize.height * (mouthCurvePercent * 0.28),
      )
      ..quadraticBezierTo(
        foamBottomRight.width - mouthSize.width * (mouthCurvePercent * 0.3),
        foamTopLeft.height -
            mouthSize.height * (mouthCurvePercent * 0.28) * 0.9,
        foamBottomRight.width,
        foamTopLeft.height,
      )
      ..moveTo(foamTopLeft.width, foamTopLeft.height)
      ..quadraticBezierTo(
        foamTopLeft.width + (bodySize.width * 0.05),
        (foamTopLeft.height + bodySize.height * changeOffsetPercent) * 0.9,
        foamTopLeft.width + (bodySize.width * bodyBottomOffsetPercent),
        foamTopLeft.height + (bodySize.height * changeOffsetPercent),
      )
      ..quadraticBezierTo(
        foamTopLeft.width + (foamBottomRight.width - foamTopLeft.width) * 0.5,
        foamTopLeft.height + (bodySize.height * (changeOffsetPercent + 0.06)),
        foamBottomRight.width - (bodySize.width * bodyBottomOffsetPercent),
        foamTopLeft.height + (bodySize.height * changeOffsetPercent),
      )
      ..quadraticBezierTo(
        foamBottomRight.width - (bodySize.width * 0.05),
        (foamTopLeft.height + bodySize.height * changeOffsetPercent) * 0.9,
        foamBottomRight.width,
        foamTopLeft.height,
      );

    canvas.clipPath(foamPath);
    canvas.drawRect(
      Rect.fromLTWH(
        foamTopLeft.width,
        foamTopLeft.height - mouthSize.height * (mouthCurvePercent * 0.28),
        foamBottomRight.width - foamTopLeft.width,
        bodySize.height * (changeOffsetPercent + 0.06),
      ),
      backgroundPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        foamTopLeft.width,
        foamTopLeft.height - mouthSize.height * (mouthCurvePercent * 0.28),
        foamBottomRight.width - foamTopLeft.width,
        bodySize.height * (changeOffsetPercent + 0.06) * foamPercent,
      ),
      foamPaint,
    );
  }

  @override
  bool shouldRepaint(CoffeeCupPainter oldCup) =>
      oldCup.cupSize != cupSize && oldCup.animPercent != animPercent;
}
