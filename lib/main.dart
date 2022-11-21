import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:wheretomeet/pages/mainpage.dart';
import 'package:wheretomeet/provider/arriveProvider.dart';
import 'package:wheretomeet/provider/currentIndexProvider.dart';
import 'package:wheretomeet/provider/departProvider.dart';

void main() async {
  await dotenv.load(fileName: 'assets/.env');
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => DepartProvider()),
      ChangeNotifierProvider(create: (context) => ArriveProvider()),
      ChangeNotifierProvider(create: (context) => CurrentIndexProvider()),
    ],
    child: const MyApp(),
  ));
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
      home: const MainPage(),
    );
  }
}
