import 'package:coffee_maker/providers/coffee_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:provider/provider.dart';

class VerticalSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CoffeeProvider>(
      builder: (_, provider, child) {
        final value = provider.isInSelectSizeState
            ? CoffeeSize.values.indexOf(provider.coffeeSize)
            : provider.foam;
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 36.0),
          child: FlutterSlider(
            axis: Axis.vertical,
            rtl: provider.isInSelectSizeState,
            tooltip: FlutterSliderTooltip(disabled: true),
            selectByTap: false,
            values: [value],
            min: 0.0,
            max: provider.isInSelectSizeState
                ? CoffeeSize.values.length.toDouble() - 1
                : 100.0,
            onDragCompleted: (_, low, high) => provider.notify(),
            onDragging: (_, low, high) {
              provider.isInSelectSizeState
                  ? provider.updateCoffeeSize(low)
                  : provider.updateFoam(low);
            },
            handler: FlutterSliderHandler(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.yellow,
                ),
              ),
            ),
            trackBar: FlutterSliderTrackBar(
              activeTrackBarHeight: 16.0,
              inactiveTrackBarHeight: 8.0,
              activeTrackBar: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(60.0),
              ),
              inactiveTrackBar: BoxDecoration(
                color: const Color(0xFF340818),
                borderRadius: BorderRadius.circular(60.0),
              ),
            ),
          ),
        );
      },
    );
  }
}
