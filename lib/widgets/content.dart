import 'package:coffee_maker/widgets/coffee_cup.dart';
import 'package:coffee_maker/widgets/coffee_indicator.dart';
import 'package:coffee_maker/widgets/vertical_slider.dart';
import 'package:flutter/material.dart';

class Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: VerticalSlider(),
        ),
        Expanded(
          flex: 10,
          child: Column(
            children: [
              Expanded(
                flex: 4,
                child: CoffeeIndicator(),
              ),
              Expanded(
                flex: 8,
                child: CoffeeCup(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
