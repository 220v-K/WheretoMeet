import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wheretomeet/components/colors.dart';
import 'package:wheretomeet/components/component.dart';

import 'package:wheretomeet/locations.dart' as locations;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:location/location.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:wheretomeet/provider/arriveProvider.dart';
import 'package:wheretomeet/provider/departProvider.dart';
import 'package:wheretomeet/provider/resultProvider.dart';
import 'package:wheretomeet/provider/tempPlaceProvider.dart';

class ResultMapPage extends StatefulWidget {
  const ResultMapPage({Key? key}) : super(key: key);

  @override
  State<ResultMapPage> createState() => _ResultMapPageState();
}

class _ResultMapPageState extends State<ResultMapPage> {
  late tempPlaceProvider _tempPlaceProvider;
  late DepartProvider _departProvider;
  late ResultProvider _resultProvider;
  late ArriveProvider _arriveProvider;

  String placeText = "";

  //! Google Map
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  final Map<String, Marker> _markers = {};
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  String googleAPiKey = dotenv.env['GOOGLE_PLACES_API_2'] ?? "";

  @override
  void initState() {
    super.initState();

    polylinePoints = PolylinePoints();
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _tempPlaceProvider = Provider.of<tempPlaceProvider>(context, listen: false);
    _departProvider = Provider.of<DepartProvider>(context, listen: false);
    _resultProvider = Provider.of<ResultProvider>(context, listen: false);
    _arriveProvider = Provider.of<ArriveProvider>(context, listen: false);

    double placeLat = _tempPlaceProvider.lat;
    double placeLng = _tempPlaceProvider.lng;
    String placeName = _tempPlaceProvider.name;
    int placeIndex = _tempPlaceProvider.index + 1;

    mapController = controller;
    final googleOffices = await locations.getGoogleOffices();

    // 선택한 도착지 마커
    final resultMarker = Marker(
      markerId: MarkerId("result"),
      position: LatLng(placeLat, placeLng),
      infoWindow: InfoWindow(
        title: placeName,
        snippet: "$placeIndex번째 추천 도착지",
      ),
    );

    setState(() {
      _markers.clear();
      // for (final office in googleOffices.offices) {
      //   final marker = Marker(
      //     markerId: MarkerId(office.name),
      //     position: LatLng(office.lat, office.lng),
      //     infoWindow: InfoWindow(
      //       title: office.name,
      //       snippet: office.address,
      //     ),
      //   );
      //   _markers[office.name] = marker;
      // }

      // 출발지 마커 리스트
      final List<Marker> departMarkers = [];
      for (int i = 0; i < _departProvider.places.length; i++) {
        double departLat = _departProvider.places.elementAt(i)["lat"];
        double departLng = _departProvider.places.elementAt(i)["lng"];
        String departPlaceName = _departProvider.places.elementAt(i)["name"];
        departMarkers.add(
          Marker(
            markerId: MarkerId("depart$i"),
            position: LatLng(departLat, departLng),
            infoWindow: InfoWindow(
              title: departPlaceName,
              snippet: "${i + 1}번째 출발지",
            ),
          ),
        );

        _markers["depart$i"] = departMarkers[i];
      }
      _markers["result"] = resultMarker;
    });

    setPolylines();
  }

  // //! Fetch My Location Data
  // Future<LocationData> loadMyLocation() async {
  //   Location location = new Location();

  //   bool _serviceEnabled;
  //   PermissionStatus _permissionGranted;
  //   LocationData _locationData;

  //   _serviceEnabled = await location.serviceEnabled();
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await location.requestService();
  //     if (!_serviceEnabled) {
  //       return Future.error('Location services are disabled.');
  //     }
  //   }

  //   _permissionGranted = await location.hasPermission();
  //   if (_permissionGranted == PermissionStatus.denied) {
  //     _permissionGranted = await location.requestPermission();
  //     if (_permissionGranted != PermissionStatus.granted) {
  //       return Future.error('Location permissions are denied');
  //     }
  //   }

  //   _locationData = await location.getLocation();
  //   return _locationData;
  // }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return safeAreaPage(
      Colors.white,
      Colors.white,
      Column(
        children: [
          searchHeader(context),
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(37.5642135, 127.0016985),
                zoom: 11.0,
              ),
              markers: _markers.values.toSet(),
              polylines: _polylines,
              myLocationEnabled: false,
              zoomGesturesEnabled: true,
              scrollGesturesEnabled: true,
              compassEnabled: true,
              rotateGesturesEnabled: true,
              mapToolbarEnabled: true,
              tiltGesturesEnabled: true,
              onCameraMove: (CameraPosition cameraPosition) {},
              // ignore: prefer_collection_literals
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              ].toSet(),
            ),
          ),
        ],
      ),
    );
  }

  Widget searchHeader(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        CupertinoButton(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // Container(
        //   alignment: Alignment.topCenter,
        //   padding: EdgeInsets.only(bottom: 3),
        //   width: width * 0.6,
        //   child: CupertinoTextField(
        //     placeholder: "위치를 입력해주세요",
        //     placeholderStyle:
        //         customTextStyle(16, Colors.black.withOpacity(0.5)),
        //     style: customTextStyle(16, Colors.black),
        //     decoration: BoxDecoration(
        //       color: Colors.white,
        //       borderRadius: BorderRadius.circular(10),
        //     ),
        //     onChanged: (value) {
        //       setState(() {
        //         placeText = value;
        //       });
        //     },
        //   ),
        // ),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: SizedBox(),
        ),
        CupertinoButton(
          alignment: Alignment.center,
          minSize: 0,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Icon(
            Icons.place,
            color: Colors.black,
          ),
          onPressed: () {
            // print(loadMyLocation());
          },
        ),
        // CupertinoButton(
        //   alignment: Alignment.centerRight,
        //   minSize: 0,
        //   padding: EdgeInsets.zero,
        //   child: Icon(
        //     Icons.search,
        //     color: Colors.black,
        //   ),
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       CupertinoPageRoute(builder: (context) => SearchPlaceText()),
        //     );
        //   },
        // ),
        SizedBox(width: 10),
      ],
    );
  }

  void setPolylines() async {
    double arriveLat = _arriveProvider.places[0]["lat"];
    double arriveLng = _arriveProvider.places[0]["lng"];
    double departLat = _departProvider.places[0]["lat"];
    double departLng = _departProvider.places[0]["lng"];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(departLat, departLng),
      PointLatLng(arriveLat, arriveLng),
    );

    if (result.status == 'OK') {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    setState(() {
      _polylines.add(
        Polyline(
          polylineId: PolylineId(''),
          width: 10,
          color: mainColor,
          points: polylineCoordinates,
        ),
      );
    });
  }
}

/// Decode the google encoded string using Encoded Polyline Algorithm Format
/// for more info about the algorithm check https://developers.google.com/maps/documentation/utilities/polylinealgorithm
///
///return [List]
List<PointLatLng> decodeEncodedPolyline(String encoded) {
  List<PointLatLng> poly = [];
  int index = 0, len = encoded.length;
  int lat = 0, lng = 0;

  while (index < len) {
    int b, shift = 0, result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lat += dlat;

    shift = 0;
    result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lng += dlng;
    PointLatLng p =
        new PointLatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
    poly.add(p);
  }
  return poly;
}
