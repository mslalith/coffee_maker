import 'package:coffee_maker/providers/coffee_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60.0,
      child: RaisedButton(
        color: Colors.yellow,
        child: Text(
          'NEXT',
          style: TextStyle(
            color: Colors.brown,
            fontWeight: FontWeight.bold
          ),
        ),
        onPressed: () {
          final provider = Provider.of<CoffeeProvider>(context, listen: false);
          if (provider.isInSelectSizeState) provider.toFoamState();
          else provider.toSelectSizeState();
        },
      ),
    );
  }
}
