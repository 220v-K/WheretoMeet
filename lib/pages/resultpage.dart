import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wheretomeet/components/component.dart';

import 'package:wheretomeet/locations.dart' as locations;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:location/location.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:wheretomeet/provider/arriveProvider.dart';
import 'package:wheretomeet/provider/departProvider.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late DepartProvider _departProvider;
  late ArriveProvider _arriveProvider;

  List<Map> departPlacesList = [];
  List<Map> arrivePlacesList = [];

  @override
  Widget build(BuildContext context) {
    _departProvider = Provider.of<DepartProvider>(context, listen: false);
    _arriveProvider = Provider.of<ArriveProvider>(context, listen: false);

    departPlacesList = _departProvider.places;
    arrivePlacesList = _arriveProvider.places;

    return safeAreaPage(
      Colors.white,
      Colors.white,
      Container(),
    );
  }
}
