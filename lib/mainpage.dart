import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wheretomeet/colors.dart';
import 'package:wheretomeet/component.dart';
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
    "가나다",
    "더미데이터"
  ];

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
          SizedBox(
            width: width * 0.9,
            height: height * 0.3,
            child: Expanded(
              child: Scrollbar(
                thickness: 3.0,
                radius: Radius.circular(8),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(8),
                  shrinkWrap: true,
                  itemCount: departList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return locationBox(width, departList[index]);
                  },
                ),
              ),
            ),
          ),
          addArriveButton(),
        ],
      ),
    );
  }

  CupertinoButton locationBox(double width, String location) {
    return CupertinoButton(
      onPressed: () {},
      minSize: 0,
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: mainColor, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        width: width * 0.8,
        height: 56,
        child: Container(
          margin: EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          child: Text(location, style: blackTextStyle(20)),
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

  CupertinoButton addArriveButton() {
    return CupertinoButton(
      minSize: 0,
      padding: EdgeInsets.zero,
      child: Icon(
        Icons.add_box,
        color: mainColor.withOpacity(0.9),
        size: 40,
      ),
      onPressed: () {},
    );
  }

  Center guideText() {
    return Center(
      child: Text.rich(
        textAlign: TextAlign.center,
        TextSpan(
          style: blackTextStyle_Bold(20),
          children: const <TextSpan>[
            TextSpan(text: '출발지와 도착지를 입력하고\n'),
            TextSpan(text: '약속장소를 추천받으세요'),
          ],
        ),
      ),
    );
  }
}
