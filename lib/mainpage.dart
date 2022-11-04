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
  @override
  Widget build(BuildContext context) {
    return safeAreaPage(
      mainColor,
      Colors.white,
      Column(
        children: [
          guideText(),
        ],
      ),
    );
  }

  Center guideText() {
    return Center(
      child: Text.rich(
        textAlign: TextAlign.center,
        TextSpan(
          style: blackTextStyle(20),
          children: const <TextSpan>[
            TextSpan(text: '출발지와 도착지를 입력하고\n'),
            TextSpan(text: '약속장소를 추천받으세요'),
          ],
        ),
      ),
    );
  }
}
