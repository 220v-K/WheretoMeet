import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wheretomeet/colors.dart';
import 'package:wheretomeet/component.dart';
import 'package:wheretomeet/textForButton.dart';
import 'package:wheretomeet/textstyle.dart';

class ArrivalPage extends StatefulWidget {
  const ArrivalPage({Key? key}) : super(key: key);

  @override
  State<ArrivalPage> createState() => _ArrivalPageState();
}

class _ArrivalPageState extends State<ArrivalPage> {
  List<String> arriveList = <String>[
    "충무로역 2호선",
    "을지로3가역 3호선",
    "동대문역사문화공원역 4호선",
  ];
  Map place = {};

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
                  "다음", Colors.blue.withOpacity(0.7), whiteTextStyle(20), () {
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
    return Expanded(
      child: Scrollbar(
        thickness: 3.0,
        radius: Radius.circular(8),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(8),
          shrinkWrap: true,
          itemCount: arriveList.length,
          itemBuilder: (BuildContext context, int index) {
            return locationBox(width, arriveList[index], context, index, false);
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
          if (arriveList.length < 10) {
            arriveList.add("더미데이터");
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
