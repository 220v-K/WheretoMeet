import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wheretomeet/colors.dart';
import 'package:wheretomeet/textstyle.dart';

Widget alertButtonOk(String content, BuildContext context) {
  // TODO : Change Onpressed Func
  var grayColor_07;
  return CupertinoButton(
    onPressed: () {
      Navigator.pop(context);
    },
    child: Container(
      width: 200,
      height: 40,
      decoration: BoxDecoration(
        color: grayColor_07,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          content,
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'GmarketSans',
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}

Widget alertButton_yes(String content, BuildContext context) {
  // TODO : Change Onpressed Func
  return CupertinoButton(
    onPressed: () {
      Navigator.pop(context);
    },
    child: Container(
      width: 75,
      height: 40,
      decoration: BoxDecoration(
        color: buttonBlue,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(10),
      child: Center(
        child: Text(
          content,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'GmarketSans',
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}

Widget alertButton_no(String content, BuildContext context) {
  return CupertinoButton(
    onPressed: () {
      Navigator.pop(context);
    },
    child: Container(
      width: 75,
      height: 40,
      decoration: BoxDecoration(
        color: buttonRed,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(10),
      child: Center(
        child: Text(
          content,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'GmarketSans',
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}

/// [content] is Text in the button.
/// Use This as blue color button with text.
Widget blueButtonText(String content) {
  return ElevatedButton(
    onPressed: () {},
    style: TextButton.styleFrom(
      primary: Colors.white,
      backgroundColor: buttonBlueColor,
      padding: EdgeInsets.all(10),
      // TODO: baselineoffset 적용?
      textStyle: TextStyle(
          fontFamily: mainFont, fontSize: 12, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)), // foreground
    ),
    child: Text(
      content,
      style: defaultTextStyle_white,
    ),
  );
}

/// [content] is Text in the button.
/// Use This as green color button with text.
Widget greenButtonText(String content) {
  return ElevatedButton(
    onPressed: () {},
    style: TextButton.styleFrom(
      primary: Colors.white,
      backgroundColor: Colors.green,
      padding: EdgeInsets.all(10),
      // TODO: baselineoffset 적용?
      textStyle: TextStyle(
          fontFamily: mainFont, fontSize: 12, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)), // foreground
    ),
    child: Text(
      content,
      style: defaultTextStyle,
    ),
  );
}

/// [content] is Text in the button.
/// Use This as red color button with text.
Widget redButtonText(String content) {
  return ElevatedButton(
    onPressed: () {},
    style: TextButton.styleFrom(
      primary: Colors.white,
      backgroundColor: Colors.red,
      padding: EdgeInsets.all(10),
      // TODO: baselineoffset 적용?
      textStyle: TextStyle(
          fontFamily: mainFont, fontSize: 12, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)), // foreground
    ),
    child: Text(
      content,
      style: defaultTextStyle,
    ),
  );
}

/// [content] is Text in the button.
/// Use This as gray color button with text.
Widget grayButtonText(String content) {
  return ElevatedButton(
    onPressed: () {},
    style: TextButton.styleFrom(
      primary: Colors.white,
      backgroundColor: Colors.grey,
      padding: EdgeInsets.all(10),
      // TODO: baselineoffset 적용?
      textStyle: TextStyle(
          fontFamily: mainFont, fontSize: 12, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)), // foreground
    ),
    child: Text(
      content,
      style: defaultTextStyle,
    ),
  );
}

/// [content] is Text in the button.
/// Use This as gray color button with text.
Widget colorButtonText(String content, Color backgroundColor,
    TextStyle textStyle, VoidCallback callbackFunc) {
  return CupertinoButton(
    onPressed: callbackFunc,
    minSize: 0,
    padding: EdgeInsets.all(0),
    child: Container(
      width: 120,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Center(
          child: Text(content, style: textStyle),
        ),
      ),
    ),
  );
}

/// [content] is Text in the button.
/// Use This as gray color button with text.
Widget colorButtonText_toggle(
  String content,
  String content2,
  Color backgroundColor,
  Color backgroundColor2,
  TextStyle textStyle,
  TextStyle textStyle2,
  bool trigger,
) {
  return CupertinoButton(
    onPressed: () {
      trigger = !trigger;
    },
    minSize: 0,
    padding: EdgeInsets.all(0),
    child: Container(
      width: 120,
      decoration: BoxDecoration(
        color: trigger ? backgroundColor : backgroundColor2,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Center(
          child: Text(trigger ? content : content2,
              style: trigger ? textStyle : textStyle2),
        ),
      ),
    ),
  );
}
