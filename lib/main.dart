import 'package:flutter/material.dart';
import 'package:wheretomeet/colors.dart';
import 'package:wheretomeet/component.dart';

void main() {
  runApp(const MainPage());
}

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
      Container(),
    );
  }
}
