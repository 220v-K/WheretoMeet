import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wheretomeet/colors.dart';
import 'package:wheretomeet/component.dart';
import 'package:wheretomeet/mainpage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: 'assets/.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'WhereToMeet';

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: CupertinoThemeData(
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(
            fontFamily: 'NotoSansKR',
          ),
        ),
      ),
      title: _title,
      home: MainPage(),
    );
  }
}
