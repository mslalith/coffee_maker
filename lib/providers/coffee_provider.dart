import 'package:flutter/material.dart';

class CoffeeProvider extends ChangeNotifier {
  String _title = 'Select Size';
  String get title => _title;

  CoffeeState _state = CoffeeState.selectSize;
  CoffeeState get state => _state;

  CoffeeSize _coffeeSize = CoffeeSize.XS;
  CoffeeSize get coffeeSize => _coffeeSize;
  double get coffeeSizeIndex => CoffeeSize.values.indexOf(_coffeeSize).toDouble();
  String get coffeeSizeText =>_coffeeSize.toString().split('.')[1];

  double _foam = 0.0;
  double get foam => _foam;

  bool get isInSelectSizeState => _state == CoffeeState.selectSize;
  void notify() => notifyListeners();

  void toSelectSizeState() {
    if (_state == CoffeeState.selectSize) return;

    _title = 'Select Size';
    _state = CoffeeState.selectSize;
    notifyListeners();
  }

  void toFoamState() {
    if (_state == CoffeeState.foam) return;

    _title = 'Foam';
    _state = CoffeeState.foam;
    notifyListeners();
  }

  void updateCoffeeSize(double value) {
    double oldIndex = coffeeSizeIndex;
    if ((oldIndex - value).abs() != 1) return;

    CoffeeSize coffeeSize;
    if (value >= 4.0)
      coffeeSize = CoffeeSize.XL;
    else if (value >= 3.0)
      coffeeSize = CoffeeSize.L;
    else if (value >= 2.0)
      coffeeSize = CoffeeSize.M;
    else if (value >= 1.0)
      coffeeSize = CoffeeSize.S;
    else if (value >= 0.0) coffeeSize = CoffeeSize.XS;

    _coffeeSize = coffeeSize;
    notifyListeners();
  }

  void updateFoam(double value) {
    if (_foam != value) {
      _foam = value;
      notifyListeners();
    }
  }
}

enum CoffeeState {
  selectSize,
  foam,
}

enum CoffeeSize {
  XS,
  S,
  M,
  L,
  XL,
}
