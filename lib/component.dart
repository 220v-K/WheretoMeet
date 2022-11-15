import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wheretomeet/colors.dart';
import 'package:wheretomeet/searchplace.dart';
import 'package:wheretomeet/searchplaceText.dart';
import 'package:wheretomeet/textForButton.dart';
import 'package:wheretomeet/textstyle.dart';

CupertinoButton locationBox(
    double width, String location, BuildContext context, Map place) {
  return CupertinoButton(
    onPressed: () {
      // Navigator.push(
      //   context,
      //   CupertinoPageRoute(
      //     builder: (context) => SearchPlaceText(),
      //   ),
      // );
      fetchPlace(context, place);
    },
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

void fetchPlace(BuildContext context, Map place) async {
  Map result = await Navigator.push(
    context,
    CupertinoPageRoute(
      builder: (context) => SearchPlaceText(),
    ),
  );
  print(result);
  place = result;
}

/// [backgroundColor] is Color of outside of SafeArea.
///
/// [safeAreaColor] is Color of SafeArea ( Inside ).
///
/// [widget] is body of View. (Usually, Container/Row/Column..etc).
/// Use This as infrastructure of Page when Build New Page.
Widget safeAreaPage(Color backgroundColor, Color safeAreaColor, Widget widget) {
  return Container(
    color: backgroundColor,
    child: SafeArea(
      child: Container(
        color: safeAreaColor,
        child: widget,
      ),
    ),
  );
}

/// [centerText] is the Text in the middle of the Header.
///
/// [context] is Context - <BuildContext> to make Navigator.
///
/// [height] is Header's height. This value is Optional Value. default value => 50.0.
/// If you want change other sizes, Fix it later (Add some Optional Values in Parameter).
Widget defaultHeader(String centerText, BuildContext context,
    [double height = 50.0]) {
  return Container(
    color: Colors.white,
    height: height,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // * Left Icon
          Center(
            child: CupertinoButton(
              minSize: 0,
              padding: EdgeInsets.all(0),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.keyboard_double_arrow_left,
                color: Colors.black.withOpacity(0.9),
                size: 30,
              ),
            ),
          ),
          // * Center Text
          Center(
            child: Text(
              centerText,
              style: grayTextStyle(17),
            ),
          ),
          // * Right Icon
          Center(
            child: CupertinoButton(
              minSize: 0,
              padding: EdgeInsets.all(0),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.close,
                color: Colors.black.withOpacity(0.9),
                size: 28,
              ),
            ),
          )
        ],
      ),
    ),
  );
}

/// **Large Button to use at Mission/Charge Page**
///
/// [contentRow] is Row that includes Text (and Image)
///
/// [context] is parameter - Whole Page's Buildcontext
Widget coloredRowButton_Option(Widget contentRow, Color backgroundColor,
    BuildContext context, VoidCallback callbackFunc) {
  double width = MediaQuery.of(context).size.width;
  return CupertinoButton(
    onPressed: callbackFunc,
    minSize: 0,
    padding: EdgeInsets.zero,
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      width: width - 60,
      height: 70,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: contentRow,
    ),
  );
}

/// **Pop-up Screen. Use this when show basic confirm dialog.**
///
/// [context] is <BuildContext> context - the context of Page that show this Pop-up.
///
/// [msg1], [msg2] are Messages of Popup.
void confirmPopup(BuildContext context, String msg1, String msg2) {
  Widget showConfirm() {
    return SizedBox(
      child: Row(mainAxisAlignment: MainAxisAlignment.center),
    );
  }

  showCupertinoDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => CupertinoAlertDialog(
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              msg1,
              style: grayTextStyle_07(14),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              msg2,
              style: grayTextStyle_07(12),
            ),
          ),
          Row(
            // TODO : change onPressed Button Func - fetch return value (Y/N)
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              alertButton_yes("��", context),
              alertButton_no("�ƴϿ�", context)
            ],
          ),
        ],
      ),
    ),
  );
}

/// **Pop-up Screen. Use this when show basic alert dialog.**
///
/// [context] is <BuildContext> context - the context of Page that show this Pop-up.
///
/// [msg1], [msg2] are Messages of Popup.
void alertPopup(BuildContext context, String msg1) {
  Widget showAlert() {
    return SizedBox(
      child: Row(mainAxisAlignment: MainAxisAlignment.center),
    );
  }

  showCupertinoDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => CupertinoAlertDialog(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Text(
              msg1,
              style: grayTextStyle_07(17),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(0),
            child: alertButtonOk("확인", context),
          )
        ],
      ),
    ),
  );
}

/// [context] is Context - <BuildContext> to make Navigator.
/// This is button which is shaped question mark.
Widget questionButton(context) {
  return FloatingActionButton(
    backgroundColor: CupertinoColors.white,
    foregroundColor: buttonBlueColor,
    elevation: 0,
    child: Icon(Icons.question_mark_rounded, size: 35),
    onPressed: () {
      // TODO : fix this later
      Navigator.pop(context);
      // for alertPopup test
      // alertPopup(context, "�޼���1", "�޼���2");
      // for confirmPopup test
      // confirmPopup(context, "�޼���1", "�޼���2");
    },
  );
}

/// **Header of Mission, Charge Inner Pages.**
///
/// If Inner Page of Charge / Mission Pages -> if you need double_arrow_left Button,
///
/// set [isInnerPage] to **True**
Widget header_optionPage(BuildContext context, [bool isInnerPage = false]) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  return SizedBox(
    width: width,
    height: 50,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // * POP Just current Page
        isInnerPage
            ? CupertinoButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                borderRadius: BorderRadius.zero,
                minSize: 0,
                padding: EdgeInsets.symmetric(vertical: 7, horizontal: 9),
                child: Icon(
                  Icons.keyboard_double_arrow_left,
                  color: Colors.black.withOpacity(0.9),
                  size: 30,
                ),
              )
            : SizedBox.shrink(),
        // * POP to Option Page
        CupertinoButton(
          onPressed: () {
            // Navigator.popUntil(
            //     context, (route) => route.settings.name == "/homescreen");
            Navigator.pop(context);
          },
          borderRadius: BorderRadius.zero,
          minSize: 0,
          padding: EdgeInsets.symmetric(vertical: 7, horizontal: 9),
          child: Icon(
            Icons.close,
            color: Colors.black.withOpacity(0.9),
            size: 28,
          ),
        ),
      ],
    ),
  );
}

Widget header_OnlyBackArrow(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  return SizedBox(
    width: width,
    height: 50,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // * POP Just current Page
        CupertinoButton(
          onPressed: () {
            Navigator.pop(context);
          },
          borderRadius: BorderRadius.zero,
          minSize: 0,
          padding: EdgeInsets.symmetric(vertical: 7, horizontal: 9),
          child: Icon(
            Icons.keyboard_double_arrow_left,
            color: Colors.black.withOpacity(0.9),
            size: 30,
          ),
        ),
        SizedBox.shrink(),
      ],
    ),
  );
}

Widget cerealCircle(double width, double height, [String imgPath = ""]) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
    ),
    child: Image(
      image:
          AssetImage(imgPath == "" ? "assets/img/cereals/s15_3.png" : imgPath),
    ),
  );
}

Widget cerealCircleWithNum(double width, double height, [int? cerealNum = 0]) {
  String imgPath = "";
  if (cerealNum == null) {
    imgPath = "assets/img/cereals/s0.png";
  } else if (cerealNum == 0) {
    imgPath = "assets/img/cereals/s${cerealNum.toString()}.png";
  } else if (cerealNum == 99) {
    imgPath = "assets/img/main_character.png";
  } else {
    imgPath = "assets/img/cereals/s${cerealNum.toString()}_3.png";
  }

  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
    ),
    child: Image(
      image: AssetImage(imgPath),
    ),
  );
}

Widget currentMilkTicketBox(int count, bool isMilk) {
  return Container(
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(20)),
    child: Padding(
      padding: const EdgeInsets.fromLTRB(8, 3, 8, 5),
      child: Row(
        children: [
          Image(
            image: isMilk
                ? AssetImage("assets/img/milk_color.png")
                : AssetImage("assets/img/ticket_color.png"),
            width: 25,
            height: 25,
          ),
          SizedBox(width: 10),
          Text(
            "$count",
            style: grayTextStyle_Bold(14),
          )
        ],
      ),
    ),
  );
}

Widget whiteButtonImgCurrent(
    BuildContext context, String imgPath, String content) {
  return CupertinoButton(
    minSize: 0,
    padding: EdgeInsets.zero,
    onPressed: () {},
    child: Container(
        margin: EdgeInsets.all(3),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        // child: Text("���ɼ�", style: whiteTextStyle(12)),
        child: Row(children: [
          Image(
            image: AssetImage(imgPath),
            width: 15,
            height: 15,
          ),
          SizedBox(width: 3),
          Text(content, style: grayTextStyle_Bold(10)),
        ])),
  );
}
