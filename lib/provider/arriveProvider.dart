import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ArriveProvider extends ChangeNotifier {
  List<Map> places = [];

  void setPlace(Map place, int index) {
    places[index] = place;
    notifyListeners();
  }

  void addPlace(Map place) {
    places.add(place);
    notifyListeners();
  }

  void removePlace(int index) {
    places.removeAt(index);
    notifyListeners();
  }

  void clearPlace() {
    places.clear();
    notifyListeners();
  }
}
