import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ResultProvider extends ChangeNotifier {
  // arrive에 따른 depart List
  // depart에 따른 route List
  // ignore: slash_for_doc_comments
  ///
  ///  routes = [ arrive1, arrive2, arrive3, ... ],
  ///  arrive1 = [ depart1, depart2, depart3, ... ],
  ///  depart1 = [ route1 ]
  List<List<Map>> routes = [];

  void addArrive() {
    routes.add([]);
    notifyListeners();
  }

  void addDepart(Map route, int arriveIndex) {
    routes[arriveIndex].add(route);
    notifyListeners();
  }

  void clearRoutes() {
    routes.clear();
    notifyListeners();
  }
}
