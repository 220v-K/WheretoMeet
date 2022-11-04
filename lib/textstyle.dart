import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wheretomeet/colors.dart';

const TextStyle defaultTextStyle = TextStyle(
  fontFamily: 'GmarketSans',
  color: CupertinoColors.black,
);

const TextStyle defaultTextStyle_white = TextStyle(
  fontFamily: 'GmarketSans',
  color: CupertinoColors.white,
);

const TextStyle defaultBoldTextStyle = TextStyle(
  fontFamily: 'GmarketSans',
  color: CupertinoColors.black,
  fontWeight: FontWeight.bold,
);

/// [size_] is Text's FontSize
TextStyle blackTextStyle(double size_) {
  return TextStyle(
    fontFamily: 'GmarketSans',
    color: CupertinoColors.black,
    fontSize: size_,
  );
}

/// [size_] is Text's FontSize
TextStyle blackTextStyle_Bold(double size_) {
  return TextStyle(
    fontFamily: 'GmarketSans',
    color: CupertinoColors.black,
    fontSize: size_,
    fontWeight: FontWeight.bold,
  );
}

/// [size_] is Text's FontSize
TextStyle grayTextStyle(double size_) {
  return TextStyle(
    fontFamily: 'GmarketSans',
    color: fontGray,
    fontSize: size_,
  );
}

/// [size_] is Text's FontSize
TextStyle grayTextStyle_07(double size_) {
  return TextStyle(
    fontFamily: 'GmarketSans',
    color: grayColor_07,
    fontSize: size_,
  );
}

/// [size_] is Text's FontSize.
/// TextColor - <fontGray>
/// FontWeight - <Bold>
TextStyle grayTextStyle_Bold(double size_) {
  return TextStyle(
    fontFamily: 'GmarketSans',
    color: fontGray,
    fontSize: size_,
    fontWeight: FontWeight.bold,
  );
}

/// [size_] is Text's FontSize.
/// [textColor] is Text's Color.
TextStyle customTextStyle(double size_, Color textColor) {
  return TextStyle(
    fontFamily: 'GmarketSans',
    color: textColor,
    fontSize: size_,
  );
}

/// [size_] is Text's FontSize.
/// [textColor] is Text's Color.
/// FontWeight - <Bold>
TextStyle customTextStyle_Bold(double size_, Color textColor) {
  return TextStyle(
    fontFamily: 'GmarketSans',
    color: textColor,
    fontSize: size_,
    fontWeight: FontWeight.bold,
  );
}

const TextStyle defaultTextStyle_gray = TextStyle(
  fontFamily: 'GmarketSans',
  color: Color.fromRGBO(0, 0, 0, 0.3),
);

/// [size_] is Text's FontSize.
TextStyle whiteTextStyle(double size_) {
  return TextStyle(
    fontFamily: 'GmarketSans',
    color: Colors.white,
    fontSize: size_,
  );
}

/// [size_] is Text's FontSize.
/// FontWeight - <Bold>
TextStyle whiteTextStyle_Bold(double size_) {
  return TextStyle(
    fontFamily: 'GmarketSans',
    color: Colors.white,
    fontSize: size_,
    fontWeight: FontWeight.bold,
  );
}

/// [size_] is Text's FontSize
TextStyle blueTextStyle(double size_) {
  return TextStyle(
    fontFamily: 'GmarketSans',
    color: fontBlueColor,
    fontSize: size_,
  );
}
