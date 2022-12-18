import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'dart:math';

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
import 'package:wheretomeet/pages/resultmappage.dart';
import 'package:wheretomeet/provider/arriveProvider.dart';
import 'package:wheretomeet/provider/departProvider.dart';
import 'package:wheretomeet/provider/resultProvider.dart';
import 'package:wheretomeet/provider/tempPlaceProvider.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late DepartProvider _departProvider;
  late ArriveProvider _arriveProvider;
  late ResultProvider _resultProvider;
  late tempPlaceProvider _tempPlaceProvider;

  List<Map> departPlacesList = [];
  List<Map> arrivePlacesList = [];

  int computeMode = 0;
  List<int> recommendedArriveIndexList = [];
  List<int> recommendIndexList = [];

  bool isStartSearch = false;
  bool isSearchFinished = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    _departProvider = Provider.of<DepartProvider>(context, listen: false);
    _arriveProvider = Provider.of<ArriveProvider>(context, listen: false);
    _resultProvider = Provider.of<ResultProvider>(context, listen: false);
    _tempPlaceProvider = Provider.of<tempPlaceProvider>(context, listen: false);

    departPlacesList = _departProvider.places;
    arrivePlacesList = _arriveProvider.places;

    return safeAreaPage(
      mainColor,
      Colors.white,
      Column(
        children: [
          SizedBox(height: 20),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  colorButtonText(
                    "모두에게 제일 빠른 곳!",
                    (computeMode == 0)
                        ? mainColor.withOpacity(0.7)
                        : Colors.grey,
                    whiteTextStyle_Bold(13),
                    () {
                      isStartSearch = false;
                      computeMode = 0;
                      setState(() {});
                    },
                    width: 180,
                  ),
                  colorButtonText(
                    "모두에게 공평한 시간!",
                    (computeMode == 1)
                        ? mainColor.withOpacity(0.7)
                        : Colors.grey,
                    whiteTextStyle_Bold(13),
                    () {
                      isStartSearch = false;
                      computeMode = 1;
                      setState(() {});
                    },
                    width: 180,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  colorButtonText(
                    "위치상 모두에게 가까운 곳!",
                    (computeMode == 2)
                        ? mainColor.withOpacity(0.7)
                        : Colors.grey,
                    whiteTextStyle_Bold(13),
                    () {
                      isStartSearch = false;
                      computeMode = 2;
                      setState(() {});
                    },
                    width: 180,
                  ),
                  // colorButtonText(
                  //   "",
                  //   (computeMode == 3)
                  //       ? mainColor.withOpacity(0.7)
                  //       : Colors.grey,
                  //   whiteTextStyle_Bold(13),
                  //   () {
                  //     isStartSearch = false;
                  //     computeMode = 3;
                  //     setState(() {});
                  //   },
                  //   width: 180,
                  // ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          colorButtonText(
              "검색", Colors.blue.withOpacity(0.7), whiteTextStyle(20), () async {
            _resultProvider.clearRoutes();
            // 버튼 비활성화 추가, await 처리 잘 되는 지 확인
            setState(() {
              isSearchFinished = false;
            });

            recommendIndexList = await recommendPlace();

            setState(() {
              isSearchFinished = true;
            });
          }),
          SizedBox(height: 10),
          colorButtonText(
            "결과 보기",
            Colors.blue.withOpacity(0.7),
            whiteTextStyle(20),
            () {
              setState(() {
                isStartSearch = true;
              });
            },
            isActivated: isSearchFinished,
          ),
          SizedBox(height: 20),
          recommendWidget(recommendIndexList, width),
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

  Widget recommendWidget(recommendIndexList, double width) {
    if (isStartSearch) {
      return recommendListView(recommendIndexList, width);
      // return FutureBuilder(
      //   future: recommendPlace(),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasData == false) {
      //       return CircularProgressIndicator();
      //     } else if (snapshot.hasError) {
      //       return Text(
      //         "Error",
      //         style: blackTextStyle(20),
      //       );
      //     } else {
      //       List<int> recommendIndexList = snapshot.data as List<int>;

      //       return recommendListView(recommendIndexList);
      //     }
      //   },
      // );
    } else {
      return Expanded(
        child: Text(
          "검색을 눌러주세요",
          style: blackTextStyle(20),
        ),
      );
    }
  }

  Widget recommendListView(List<int> recommendIndexList, double width) {
    return Expanded(
      child: Column(
        children: [
          Text(
            "추천 기준에 따라 순서대로 장소를 추천합니다.",
            style: blackTextStyle(20),
          ),
          Expanded(
            child: Scrollbar(
              thickness: 3.0,
              radius: Radius.circular(8),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.all(8),
                shrinkWrap: true,
                itemCount: recommendIndexList.length,
                itemBuilder: (BuildContext context, int index) {
                  return recommendListBox(index, recommendIndexList, width);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget recommendListBox(
      int index, List<int> recommendIndexList, double width) {
    return CupertinoButton(
      onPressed: () {
        // save result lat, lng to tempPlaceProvider
        _tempPlaceProvider.setPlace(
          arrivePlacesList[recommendIndexList[index]]['lat'],
          arrivePlacesList[recommendIndexList[index]]['lng'],
          arrivePlacesList[recommendIndexList[index]]['name'],
          recommendIndexList[index],
        );

        // go to result Map page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultMapPage(),
          ),
        );
      },
      minSize: 0,
      padding: EdgeInsets.zero,
      child: Container(
        width: width * 0.8,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: mainColor, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "${index + 1}. ${arrivePlacesList[recommendIndexList[index]]['name']}",
            style: blackTextStyle(20),
          ),
        ),
      ),
    );
    // Text(
    //   "${index + 1}번째 장소: ${arrivePlacesList[recommendIndexList[index]]['name']}",
    //   style: blackTextStyle(20),
    // );
  }

  Future<List<int>> recommendPlace() async {
    int arriveIndex = -1;
    int departIndex = -1;
    bool isFin = false;

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
      }
    }
    recommendedArriveIndexList = computeRecommend(computeMode);

    return recommendedArriveIndexList;
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

    // print(responseBody);
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

    print("$durationText, $durationValue");
  }

  List<int> computeRecommend(int mode) {
    Map<int, List<int>> timeList = {};
    int i = 0;
    // Map에 key: arriveIndex, value: time List 형태로 저장
    for (var arrive in _resultProvider.routes) {
      List<int> arriveList = [];
      for (var depart in arrive) {
        var legs = depart["legs"];
        var duration = legs[0]["duration"];
        var durationValue = duration["value"];
        arriveList.add(durationValue);
      }
      timeList.addAll({i++: arriveList});
    }

    Map<int, int> sortedTimeList = {};
    // mode 0 => 걸리는 시간의 평균(합)이 최소
    if (mode == 0) {
      sortedTimeList = sortMode0(timeList, sortedTimeList);
    }
    // mode 1 => 걸리는 시간들의 표준편차가 최소 (크기순 나열이므로, 분산을 사용해도 무관)
    else if (mode == 1) {
      sortedTimeList = sortMode1(timeList, sortedTimeList);
    }

    // mode 2 => mode0, mode1을 가중치 5:5로 계산
    else if (mode == 2) {
      sortedTimeList = sortMode2(timeList, sortedTimeList);
    }

    return sortedTimeList.keys.toList();
  }

  Map<int, int> sortMode2(
    Map<int, List<int>> timeList,
    Map<int, int> sortedTimeList,
  ) {
    // fetch lng, lat from departPlacesList
    List<double> lngList = [];
    List<double> latList = [];
    for (var depart in departPlacesList) {
      lngList.add(depart["lng"]);
      latList.add(depart["lat"]);
    }

    // compute average of lng, lat
    double lngAvg = lngList.reduce((a, b) => a + b) / lngList.length;
    double latAvg = latList.reduce((a, b) => a + b) / latList.length;

    // compute distance of arrivePlacesList from lngAvg, latAvg
    List<double> distanceList = [];
    for (var arrive in arrivePlacesList) {
      double lng = arrive["lng"];
      double lat = arrive["lat"];
      double distance = sqrt(pow(lng - lngAvg, 2) + pow(lat - latAvg, 2));
      distanceList.add(distance);
    }

    // make map of distanceList with it's index
    Map<int, double> distanceMap = {};
    for (int i = 0; i < distanceList.length; i++) {
      distanceMap.addAll({i: distanceList[i]});
    }

    // sort distanceMap by value
    distanceMap = Map.fromEntries(distanceMap.entries.toList()
      ..sort((e1, e2) => e1.value.compareTo(e2.value)));

    print(distanceMap);

    // casting to Map<int, int>
    distanceMap.forEach((key, value) {
      sortedTimeList.addAll({key: value.toInt()});
    });

    return sortedTimeList;
  }

  // Map<int, int> sortMode2(
  //   Map<int, List<int>> timeList,
  //   Map<int, int> sortedTimeList,
  // ) {
  //   Map<int, int> tempSortedTimeList = {};
  //   Map<int, int> tempSortedTimeList2 = {};
  //   Map<int, double> sortedTimeList_mode0 = {};
  //   Map<int, double> sortedTimeList_mode1 = {};

  //   // normalize mode0's value (divide by min value)
  //   tempSortedTimeList = sortMode0(timeList, tempSortedTimeList);
  //   int min = tempSortedTimeList.values.first;
  //   tempSortedTimeList.forEach((key, value) {
  //     sortedTimeList_mode0.addAll({key: (value / min)});
  //   });

  //   print(sortedTimeList_mode0);

  //   // normalize mode1's value (divide by min value)
  //   tempSortedTimeList2 = sortMode1(timeList, tempSortedTimeList2);
  //   min = tempSortedTimeList2.values.first;
  //   tempSortedTimeList2.forEach((key, value) {
  //     sortedTimeList_mode1.addAll({key: (value / min)});
  //   });

  //   print(sortedTimeList_mode1);

  //   // mode0, mode1의 가중치 1:1로 계산
  //   sortedTimeList_mode0.forEach((key, value) {
  //     double mode0 = value;
  //     sortedTimeList.addAll({key: (mode0 * 1000).toInt()});
  //   });
  //   sortedTimeList_mode1.forEach((key, value) {
  //     double mode1 = value;
  //     sortedTimeList.update(key, (value) => value + (mode1 * 1000).toInt());
  //   });

  //   // sort sortedTimeList by value
  //   sortedTimeList = Map.fromEntries(sortedTimeList.entries.toList()
  //     ..sort((e1, e2) => e1.value.compareTo(e2.value)));

  //   print(sortedTimeList);

  //   return sortedTimeList;
  // }

  Map<int, int> sortMode1(
    Map<int, List<int>> timeList,
    Map<int, int> sortedTimeList,
  ) {
    print(timeList);
    // timeList의 value를 합산하여 새로운 Map<int, int> 생성
    timeList.forEach((key, value) {
      int sum = 0;
      for (int time in value) {
        sum += time;
      }
      int avg = sum ~/ value.length; // 평균
      int variance = 0;
      for (int time in value) {
        variance += (time - avg) * (time - avg); // 편차 제곱합
      }
      variance = variance ~/ value.length; // 분산 (편차 제곱합의 평균)
      // print("key: $key, variance: $variance");
      sortedTimeList.addAll({key: variance});
    });
    // sort Map by value (value = 분산)
    sortedTimeList = SplayTreeMap.from(
      sortedTimeList,
      ((key1, key2) => sortedTimeList[key1]!.compareTo(sortedTimeList[key2]!)),
    );
    print(sortedTimeList);
    return sortedTimeList;
  }

  Map<int, int> sortMode0(
    Map<int, List<int>> timeList,
    Map<int, int> sortedTimeList,
  ) {
    print(timeList);
    // timeList의 value를 합산하여 새로운 Map<int, int> 생성
    timeList.forEach((key, value) {
      int sum = 0;
      for (int time in value) {
        sum += time;
      }
      sortedTimeList.addAll({key: sum});
    });
    // sort Map by value (value = 합계)
    sortedTimeList = SplayTreeMap.from(
      sortedTimeList,
      ((key1, key2) => sortedTimeList[key1]!.compareTo(sortedTimeList[key2]!)),
    );
    print(sortedTimeList);
    return sortedTimeList;
  }
}
