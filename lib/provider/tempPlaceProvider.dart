import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class tempPlaceProvider extends ChangeNotifier {
  double lat = 0.0, lng = 0.0;
  String name = "";
  int index = 0;

  void setPlace(double lat, double lng, String name, int index) {
    this.lat = lat;
    this.lng = lng;
    this.name = name;
    this.index = index;
    notifyListeners();
  }

  void clearPlace() {
    lat = 0.0;
    lng = 0.0;
    notifyListeners();
  }
}
