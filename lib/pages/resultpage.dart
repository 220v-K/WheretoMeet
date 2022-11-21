import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wheretomeet/components/colors.dart';
import 'package:wheretomeet/components/component.dart';
import 'package:wheretomeet/components/textForButton.dart';
import 'package:wheretomeet/components/textstyle.dart';

import 'package:http/http.dart' as http;
import 'package:wheretomeet/locations.dart' as locations;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:location/location.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:wheretomeet/provider/arriveProvider.dart';
import 'package:wheretomeet/provider/departProvider.dart';
import 'package:wheretomeet/provider/resultProvider.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late DepartProvider _departProvider;
  late ArriveProvider _arriveProvider;
  late ResultProvider _resultProvider;

  List<Map> departPlacesList = [];
  List<Map> arrivePlacesList = [];

  int computeMode = 0;

  @override
  Widget build(BuildContext context) {
    _departProvider = Provider.of<DepartProvider>(context, listen: false);
    _arriveProvider = Provider.of<ArriveProvider>(context, listen: false);
    _resultProvider = Provider.of<ResultProvider>(context, listen: false);

    departPlacesList = _departProvider.places;
    arrivePlacesList = _arriveProvider.places;

    return safeAreaPage(
      mainColor,
      Colors.white,
      Column(
        children: [
          SizedBox(height: 20),
          colorButtonText(
              "검색", Colors.blue.withOpacity(0.7), whiteTextStyle(20), () {
            recommendPlace();
          }),
          Expanded(child: SizedBox()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              colorButtonText(
                  "이전", Colors.red.withOpacity(0.8), whiteTextStyle(20), () {
                Navigator.pop(context);
              }),
            ],
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }

  void recommendPlace() async {
    // Result Provider 초기화
    _resultProvider.clearRoutes();
    int arriveIndex = -1;
    int departIndex = -1;

    for (Map arrive in arrivePlacesList) {
      departIndex = -1;
      arriveIndex++;
      if (arrive["name"] == "") {
        continue;
      }
      // provider - arrive add
      _resultProvider.addArrive();
      for (Map depart in departPlacesList) {
        departIndex++;
        if (depart["name"] == "") {
          continue;
        }
        // depart에서 arrive까지 걸리는 시간 측정
        bool isFin =
            await computeTime(depart, arrive, arriveIndex, departIndex);
        if (isFin) computeRecommend(computeMode);
      }
    }
  }

  Future<bool> computeTime(
      Map depart, Map arrive, int arriveIndex, int departIndex) async {
    double arriveLat = arrive["lat"];
    double arriveLng = arrive["lng"];
    double departLat = depart["lat"];
    double departLng = depart["lng"];

    String url = "https://maps.googleapis.com/maps/api/directions/json?";
    String departLocation = "origin=$departLat,$departLng";
    String arriveLocation = "destination=$arriveLat,$arriveLng";
    String language = "language=ko";
    String key = dotenv.env['GOOGLE_DIRECTIONS_API'] ?? "";
    key = "key=$key";
    String mode = "mode=transit";

    url += "$language&$departLocation&$arriveLocation&$mode&$key";
    var response = await http.get(Uri.parse(url));
    var statusCode = response.statusCode;
    var responseHeaders = response.headers;
    var responseBody = response.body;

    print(responseBody);
    var routeData = jsonDecode(responseBody);

    addRoute(routeData, arriveIndex, departIndex);

    return true;
  }

  void addRoute(routeData, int arriveIndex, int departIndex) {
    var routes = routeData["routes"];

    // provider - route add (제일 추천되는 경로만)
    _resultProvider.addDepart(routes[0], arriveIndex);

    var legs = routes[0]["legs"];
    var duration = legs[0]["duration"];
    var durationText = duration["text"];
    var durationValue = duration["value"];

    print(durationText);
    print(durationValue);
  }

  void computeRecommend(int mode) {
    List timeList = [];
    for (var arrive in _resultProvider.routes) {
      for (var depart in arrive) {
        var legs = depart["legs"];
        var duration = legs[0]["duration"];
        var durationValue = duration["value"];
        timeList.add(durationValue);
      }
    }

    if (mode == 0) {}
  }
}
