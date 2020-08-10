import 'package:flutter/material.dart';

class CoffeeProvider extends ChangeNotifier {
  String _title = 'Select Size';
  String get title => _title;

  CoffeeState _state = CoffeeState.selectSize;
  CoffeeState get state => _state;

  double size = 0.0;
  CoffeeSize _coffeeSize = CoffeeSize.S;
  CoffeeSize get coffeeSize => _coffeeSize;
  String get coffeeSizeText =>_coffeeSize.toString().split('.')[1];

  double _foam = 0.0;
  double get foam => _foam;

  bool get isInSelectSizeState => _state == CoffeeState.selectSize;
  void notify() => notifyListeners();

  void toSelectSizeState() {
    if (_state == CoffeeState.selectSize) return;

    _title = 'Select Size';
    size = 0.0;
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
    if ((size - value).abs() != 1) return;

    size = value;
    CoffeeSize coffeeSize;
    if (size >= 4.0)
      coffeeSize = CoffeeSize.XL;
    else if (size >= 3.0)
      coffeeSize = CoffeeSize.L;
    else if (size >= 2.0)
      coffeeSize = CoffeeSize.M;
    else if (size >= 1.0)
      coffeeSize = CoffeeSize.S;
    else if (size >= 0.0) coffeeSize = CoffeeSize.XS;

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
