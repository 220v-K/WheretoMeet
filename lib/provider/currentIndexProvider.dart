import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class CurrentIndexProvider extends ChangeNotifier {
  int index = 0;

  void setIndex(int index) {
    this.index = index;
    notifyListeners();
  }
}
