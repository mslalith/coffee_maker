import 'package:coffee_maker/providers/coffee_provider.dart';
import 'package:coffee_maker/widgets/coffee_foam_indicator.dart';
import 'package:coffee_maker/widgets/coffee_size_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoffeeIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<CoffeeProvider, CoffeeState>(
      selector: (_, provider) => provider.state,
      builder: (_, state, child) {
        return state == CoffeeState.selectSize
            ? CoffeeSizeIndicator()
            : CoffeeFoamIndicator();
      },
    );
  }
}
