import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wheretomeet/arrivalpage.dart';
import 'package:wheretomeet/colors.dart';
import 'package:wheretomeet/component.dart';
import 'package:wheretomeet/textForButton.dart';
import 'package:wheretomeet/textstyle.dart';

class SearchPlace extends StatefulWidget {
  const SearchPlace({Key? key}) : super(key: key);

  @override
  State<SearchPlace> createState() => _SearchPlaceState();
}

class _SearchPlaceState extends State<SearchPlace> {
  @override
  Widget build(BuildContext context) {
    return safeAreaPage(
      Colors.white,
      Colors.white,
      Row(
        children: [
          Container(),
        ],
      ),
    );
  }
}
