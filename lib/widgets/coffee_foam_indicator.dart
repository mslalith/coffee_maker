import 'package:coffee_maker/providers/coffee_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoffeeFoamIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<CoffeeProvider, double>(
      selector: (_, provider) => provider.foam,
      builder: (_, foam, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              foam.toString(),
              style: TextStyle(
                fontSize: 72.0,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 24.0),
              child: Text(
                '%',
                style: TextStyle(fontSize: 30.0),
              ),
            ),
          ],
        );
      },
    );
  }
}
