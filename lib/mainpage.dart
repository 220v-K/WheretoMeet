import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wheretomeet/arrivalpage.dart';
import 'package:wheretomeet/colors.dart';
import 'package:wheretomeet/component.dart';
import 'package:wheretomeet/textForButton.dart';
import 'package:wheretomeet/textstyle.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<String> departList = <String>[
    "홍제역 3호선",
    "서울역 1호선",
    "신촌역 2호선",
  ];

  Map place = {
    "name": "홍대입구역",
    "address": "서울특별시 마포구 양화로 32",
    "latitude": 37.557945,
    "longitude": 126.925608,
  };

  @override
  Widget build(BuildContext context) {
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
          addDepartButton(),
          SizedBox(height: 20),
          departListView(width, height),
          SizedBox(height: 20),
          colorButtonText(
              "다음", Colors.blue.withOpacity(0.7), whiteTextStyle(20), () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => ArrivalPage()),
            );
          }),
          SizedBox(height: 50)
        ],
      ),
    );
  }

  Widget departListView(double width, double height) {
    return Expanded(
      child: Scrollbar(
        thickness: 3.0,
        radius: Radius.circular(8),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(8),
          shrinkWrap: true,
          itemCount: departList.length,
          itemBuilder: (BuildContext context, int index) {
            return locationBox(width, departList[index], context, place);
          },
        ),
      ),
    );
  }

  CupertinoButton addDepartButton() {
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
          if (departList.length < 10) {
            departList.add("더미데이터");
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
            TextSpan(text: '출발지를 입력하세요 (최대 10개)'),
          ],
        ),
      ),
    );
  }
}
