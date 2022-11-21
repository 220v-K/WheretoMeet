import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wheretomeet/arrivalpage.dart';
import 'package:wheretomeet/colors.dart';
import 'package:wheretomeet/component.dart';
import 'package:wheretomeet/searchplaceText.dart';
import 'package:wheretomeet/textForButton.dart';
import 'package:wheretomeet/textstyle.dart';
import 'package:wheretomeet/locations.dart' as locations;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:location/location.dart';
import 'package:flutter_google_places/flutter_google_places.dart';

class SearchPlaceMap extends StatefulWidget {
  const SearchPlaceMap({Key? key}) : super(key: key);

  @override
  State<SearchPlaceMap> createState() => _SearchPlaceMapState();
}

class _SearchPlaceMapState extends State<SearchPlaceMap> {
  String placeText = "";

  //! Google Map
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  final Map<String, Marker> _markers = {};
  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    final googleOffices = await locations.getGoogleOffices();
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
      final marker = Marker(
        markerId: MarkerId("Test"),
        position: LatLng(37.5642135, 127.0016985),
        infoWindow: InfoWindow(
          title: "Test",
          snippet: "Test",
        ),
      );
      _markers["Test"] = marker;
    });
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
                ].toSet()),
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
}
