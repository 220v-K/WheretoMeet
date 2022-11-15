import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wheretomeet/arrivalpage.dart';
import 'package:wheretomeet/colors.dart';
import 'package:wheretomeet/component.dart';
import 'package:wheretomeet/provider/departProvider.dart';
import 'package:wheretomeet/textForButton.dart';
import 'package:wheretomeet/textstyle.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late DepartProvider _departProvider;

  Map place = {
    "name": "",
    "address": "",
    "latitude": 37.557945,
    "longitude": 126.925608,
  };

  @override
  Widget build(BuildContext context) {
    _departProvider = Provider.of<DepartProvider>(context, listen: false);
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
          itemCount: _departProvider.places.length,
          itemBuilder: (BuildContext context, int index) {
            return locationBox(width, _departProvider.places[index]["name"],
                context, index, true);
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
          if (_departProvider.places.length < 10) {
            _departProvider.addPlace(place);
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
