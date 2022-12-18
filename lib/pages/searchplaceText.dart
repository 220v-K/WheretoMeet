import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wheretomeet/components/component.dart';
import 'package:wheretomeet/components/textstyle.dart';
import 'package:wheretomeet/pages/searchplace.dart';

import 'package:wheretomeet/provider/arriveProvider.dart';
import 'package:wheretomeet/provider/currentIndexProvider.dart';
import 'package:wheretomeet/provider/departProvider.dart';

import 'package:wheretomeet/locations.dart' as locations;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SearchPlaceText extends StatefulWidget {
  const SearchPlaceText({
    Key? key,
    required this.isDepart,
    required this.update,
  }) : super(key: key);

  final bool isDepart;
  final Function update;

  @override
  State<SearchPlaceText> createState() => _SearchPlaceTextState();
}

class _SearchPlaceTextState extends State<SearchPlaceText> {
  // late DepartProvider _departProvider;
  String placeText = "";
  List<Map> placesList = [];
  Widget searchResultWidget = Container();

  @override
  Widget build(BuildContext context) {
    // _departProvider = Provider.of<DepartProvider>(context, listen: false);
    return safeAreaPage(
      Colors.white,
      Colors.white,
      Column(
        children: [
          searchHeader(context),
          // * 지도에서 검색하기 기능 삭제, 추후 추가 예정
          // searchInMap(context),
          searchResultWidget,
        ],
      ),
    );
  }

  CupertinoButton searchInMap(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => SearchPlaceMap()),
        );
      },
      minSize: 0,
      padding: EdgeInsets.zero,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 180,
        ),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Text(
                "지도에서 검색하기",
                style: blackTextStyle(15),
              ),
            ),
            Icon(
              CupertinoIcons.arrow_right_square,
              color: Colors.black,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Row searchHeader(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        CupertinoButton(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(bottom: 3),
          width: width * 0.6,
          child: CupertinoTextField(
            placeholder: "위치를 입력해주세요",
            placeholderStyle:
                customTextStyle(16, Colors.black.withOpacity(0.5)),
            style: customTextStyle(16, Colors.black),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            onChanged: (value) {
              setState(() {
                placeText = value;
              });
            },
          ),
        ),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: SizedBox(),
        ),
        CupertinoButton(
          alignment: Alignment.centerRight,
          minSize: 0,
          padding: EdgeInsets.zero,
          child: Icon(
            Icons.search,
            color: Colors.black,
          ),
          onPressed: () {
            // TODO
            // Navigator.push(
            //   context,
            //   CupertinoPageRoute(builder: (context) => SearchPlaceText()),
            // );
            // searchPlace();
            searchPlace(placeText, searchResultWidget, placesList);
          },
        ),
        SizedBox(width: 15),
      ],
    );
  }

  // search place with text input using Google Places API, http get method
  void searchPlace(
    String placeText_,
    Widget searchResultWidget_,
    List<Map> placesList_,
  ) async {
    //
    placesList_.clear();
    // String url =
    //     "https://maps.googleapis.com/maps/api/place/textsearch/json?query=restaurants%20in%20Sydney&key=";

    String url =
        "https://maps.googleapis.com/maps/api/place/textsearch/json?query=";
    String key = dotenv.env['GOOGLE_PLACES_API_2'] ?? "";
    // url += placeText_ + key;
    url += "$placeText_&language=ko&key=$key";
    var response = await http.get(Uri.parse(url));
    var statusCode = response.statusCode;
    var responseHeaders = response.headers;
    var responseBody = response.body;

    // print("statusCode: $statusCode");
    // print("responseHeaders: $responseHeaders");
    var json = jsonDecode(responseBody);
    // print(json["results"][0]["name"]);
    print("responseBody: $responseBody");

    createPlacesWidget(json, searchResultWidget_, placesList_, context);
  }

  void createPlacesWidget(
    json,
    Widget searchResultWidget_,
    List<Map> placesList_,
    context,
  ) {
    // Update the state of Last Page
    Function updateLastPage = widget.update;

    for (int i = 0; i < json["results"].length; i++) {
      placesList_.add({
        "name": json["results"][i]["name"],
        "address": json["results"][i]["formatted_address"],
        "lat": json["results"][i]["geometry"]["location"]["lat"],
        "lng": json["results"][i]["geometry"]["location"]["lng"],
      });
    }
    //* NULL CHECK - if there is no result
    if ((json["results"].length != 0 && json["status"] != "INVALID_REQUEST")) {
      searchResultWidget_ = Expanded(
        child: Scrollbar(
          thickness: 3.0,
          radius: Radius.circular(8),
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(8),
            shrinkWrap: true,
            itemCount: placesList.length,
            itemBuilder: (BuildContext context, int index) {
              return Provider(
                create: (context) => DepartProvider(),
                child: CupertinoButton(
                  onPressed: () {
                    // Provider에 Place정보 추가하며 화면 전환
                    if (widget.isDepart) {
                      Provider.of<DepartProvider>(context, listen: false)
                          .setPlace(
                              placesList[index],
                              Provider.of<CurrentIndexProvider>(context,
                                      listen: false)
                                  .index);
                    } else {
                      Provider.of<ArriveProvider>(context, listen: false)
                          .setPlace(
                              placesList[index],
                              Provider.of<CurrentIndexProvider>(context,
                                      listen: false)
                                  .index);
                    }
                    updateLastPage();
                    Navigator.pop(context);
                  },
                  minSize: 0,
                  padding: EdgeInsets.all(8),
                  child: Center(
                    child: Text(
                      placesList_[index]["name"],
                      style: blackTextStyle(20),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    } else {
      searchResultWidget_ = RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: blackTextStyle(20),
          children: const [
            TextSpan(
              text: "검색 결과가 없거나,\n",
            ),
            TextSpan(
              text: "정보를 불러오는데 실패했습니다.",
            ),
          ],
        ),
      );
    }

    setState(() {
      searchResultWidget = searchResultWidget_;
    });
  }
}
