import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wheretomeet/arrivalpage.dart';
import 'package:wheretomeet/colors.dart';
import 'package:wheretomeet/component.dart';
import 'package:wheretomeet/textForButton.dart';
import 'package:wheretomeet/textstyle.dart';
import 'package:wheretomeet/locations.dart' as locations;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:wheretomeet/searchplace.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SearchPlaceText extends StatefulWidget {
  const SearchPlaceText({Key? key}) : super(key: key);

  @override
  State<SearchPlaceText> createState() => _SearchPlaceTextState();
}

class _SearchPlaceTextState extends State<SearchPlaceText> {
  String placeText = "";
  @override
  Widget build(BuildContext context) {
    return safeAreaPage(
      Colors.white,
      Colors.white,
      Column(
        children: [
          searchHeader(context),
        ],
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
            searchPlace(placeText);
          },
        ),
        SizedBox(width: 15),
      ],
    );
  }
}

// search place with text input using Google Places API, http get method
void searchPlace(String placeText) async {
  // String url =
  //     "https://maps.googleapis.com/maps/api/place/textsearch/json?query=restaurants%20in%20Sydney&key=";

  String url =
      "https://maps.googleapis.com/maps/api/place/textsearch/json?query=";
  String key = dotenv.env['GOOGLE_PLACES_API_2'] ?? "";
  url += "$placeText&key=$key";
  var response = await http.get(Uri.parse(url));
  var statusCode = response.statusCode;
  var responseHeaders = response.headers;
  var responseBody = response.body;

  // print("statusCode: $statusCode");
  // print("responseHeaders: $responseHeaders");
  var json = jsonDecode(responseBody);
  print(json["results"][0]["name"]);
  // print("responseBody: $responseBody");
}
