import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wheretomeet/components/colors.dart';
import 'package:wheretomeet/components/component.dart';
import 'package:wheretomeet/components/textForButton.dart';
import 'package:wheretomeet/components/textstyle.dart';
import 'package:wheretomeet/provider/arriveProvider.dart';
import 'package:wheretomeet/provider/departProvider.dart';

class ArrivalPage extends StatefulWidget {
  const ArrivalPage({Key? key}) : super(key: key);

  @override
  State<ArrivalPage> createState() => _ArrivalPageState();
}

class _ArrivalPageState extends State<ArrivalPage> {
  late ArriveProvider _arriveProvider;

  Map place = {
    "name": "",
    "address": "",
    "latitude": 37.557945,
    "longitude": 126.925608,
  };

  void update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _arriveProvider = Provider.of<ArriveProvider>(context, listen: false);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return safeAreaPage(
      mainColor,
      Colors.white,
      Column(
        children: [
          SizedBox(height: 20),
          guideText(),
          SizedBox(height: 20),
          addArriveButton(),
          SizedBox(height: 20),
          arriveListView(width, height),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              colorButtonText(
                  "이전", Colors.red.withOpacity(0.8), whiteTextStyle(20), () {
                Navigator.pop(context);
              }),
              colorButtonText(
                  "검색", Colors.blue.withOpacity(0.7), whiteTextStyle(20), () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => ArrivalPage()),
                );
              }),
            ],
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget arriveListView(double width, double height) {
    List arrivePlacesList = _arriveProvider.places;
    return Expanded(
      child: Scrollbar(
        thickness: 3.0,
        radius: Radius.circular(8),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(8),
          shrinkWrap: true,
          itemCount: _arriveProvider.places.length,
          itemBuilder: (BuildContext context, int index) {
            return locationBox(width, _arriveProvider.places[index]["name"],
                context, index, false, update);
          },
        ),
      ),
    );
  }

  CupertinoButton addArriveButton() {
    return CupertinoButton(
      minSize: 0,
      padding: EdgeInsets.zero,
      child: Icon(
        Icons.add_box,
        color: mainColor.withOpacity(0.9),
        size: 40,
      ),
      onPressed: () {
        setState(() {
          if (_arriveProvider.places.length < 10) {
            _arriveProvider.addPlace(place);
          } else {
            alertPopup(context, "최대 10개까지\n추가할 수 있습니다.");
          }
        });
      },
    );
  }

  Center guideText() {
    return Center(
      child: Text.rich(
        textAlign: TextAlign.center,
        TextSpan(
          style: blackTextStyle_Bold(20),
          children: const <TextSpan>[
            TextSpan(text: '도착지 후보를 입력하세요'),
          ],
        ),
      ),
    );
  }
}
