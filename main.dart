import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:map1/secrets.dart';
import 'api_service.dart';
import 'dart:convert' as convert;
import 'package:map1/api_service.dart';


void main() {
  runApp(MyApp());
}



/*class Vehicle {
  double latitude;
  double longitude;
  String plateNumber;

  Vehicle({
    required this.latitude,
    required this.longitude,
    required this.plateNumber,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      latitude: double.parse(json['Latitude'].toString()),
      longitude: double.parse(json['Longitude'].toString()),
      plateNumber: json['plateNumber'].toString(),
    );
  }
}*/


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Maps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapView(),
    );
  }
}

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  CameraPosition _initialLocation =
      CameraPosition(target: LatLng(16.7479112, 100.1893587));
  String googleAPiKey = Secrets.API_KEY;
  late GoogleMapController mapController;

  Map<MarkerId, Marker> markers = {};
  
  get apiService => null;

  Future<Position> fetchCurrentLocation() async {
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  Future<Uint8List> _resizeImage(
      String assetPath, int width, int height) async {
    ByteData data = await rootBundle.load(assetPath);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
      targetHeight: height,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    ui.Image image = fi.image;
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
  void fetchCarLocations() async {
    try {
      List<Map<String, dynamic>> locations = await apiService.fetchLocations();
      setState(() {
        var car_location = locations;

        print('car_location data:');
        print(car_location);
        print('Total car locations: ${car_location.length}');
      });

    
    } catch (e) {
      print('Error: $e');
    }
  }

  void _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    final markerId = MarkerId(id);
    final marker = Marker(
      markerId: markerId,
      position: position,
      icon: descriptor,
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  @override
  void initState() {
    super.initState();
    addMultipleMarkers();
  }

  void addMultipleMarkers() async {
    List<Map<String, dynamic>> markersData = [
      {
        'latitude': 16.7503449,
        'longitude': 100.1897194,
        'id': 'marker_1',
        'icon': 'assents/images/marker_icon_1.png'
      },
      {
        'latitude': 16.7494484,
        'longitude': 100.1904319,
        'id': 'marker_2',
        'icon': 'assents/images/marker_icon_1.png'
      },
      {
        'latitude': 16.749877,
        'longitude': 100.1918236,
        'id': 'marker_3',
        'icon': 'assents/images/marker_icon_1.png'
      },
      {
        'latitude': 16.7482711,
        'longitude': 100.1910321,
        'id': 'marker_4',
        'icon': 'assents/images/marker_icon_1.png'
      },
      {
        'latitude': 16.7469047,
        'longitude': 100.1938645,
        'id': 'marker_5',
        'icon': 'assents/images/marker_icon_1.png'
      },
      {
        'latitude': 16.7425062,
        'longitude': 100.196538,
        'id': 'marker_6',
        'icon': 'assents/images/marker_icon_1.png'
      },
      {
        'latitude': 16.7427639,
        'longitude': 100.196638,
        'id': 'marker_7',
        'icon': 'assents/images/marker_icon_1.png'
      },
      {
        'latitude': 16.7422349,
        'longitude': 100.1943044,
        'id': 'marker_8',
        'icon': 'assents/images/marker_icon_1.png'
      },
      {
        'latitude': 16.7431331,
        'longitude': 100.1893751,
        'id': 'marker_9',
        'icon': 'assents/images/marker_icon_1.png'
      },
      {
        'latitude': 16.745522,
        'longitude': 100.1890049,
        'id': 'marker_10',
        'icon': 'assents/images/marker_icon_1.png'
      },
      {
        'latitude': 16.7477374,
        'longitude': 100.1880105,
        'id': 'marker_11',
        'icon': 'assents/images/marker_icon_1.png'
      },
      {
        'latitude': 16.7452083,
        'longitude': 100.1920723,
        'id': 'marker_12',
        'icon': 'assents/images/marker_icon_1.png'
      },
      {
        'latitude': 16.7480751,
        'longitude': 100.1890331,
        'id': 'marker_13',
        'icon': 'assents/images/marker_icon_1.png'
      },
      {
        'latitude': 16.742338,
        'longitude': 100.1968775,
        'id': 'marker_14',
        'icon': 'assents/images/marker_icon_2.png'
      },
      {
        'latitude': 16.7426189,
        'longitude': 100.1943886,
        'id': 'marker_15',
        'icon': 'assents/images/marker_icon_2.png'
      },
      {
        'latitude': 16.7425545,
        'longitude': 100.1922819,
        'id': 'marker_16',
        'icon': 'assents/images/marker_icon_2.png'
      },
      {
        'latitude': 16.7443056,
        'longitude': 100.1904736,
        'id': 'marker_17',
        'icon': 'assents/images/marker_icon_2.png'
      },
      {
        'latitude': 16.7450698,
        'longitude': 100.1919173,
        'id': 'marker_18',
        'icon': 'assents/images/marker_icon_2.png'
      },
      {
        'latitude': 16.7462884,
        'longitude': 100.1893795,
        'id': 'marker_19',
        'icon': 'assents/images/marker_icon_2.png'
      },
      {
        'latitude': 16.7496123,
        'longitude': 100.1917023,
        'id': 'marker_20',
        'icon': 'assents/images/marker_icon_2.png'
      },
      {
        'latitude': 16.7494653,
        'longitude': 100.1944583,
        'id': 'marker_21',
        'icon': 'assents/images/marker_icon_2.png'
      },
      {
        'latitude': 16.7482333,
        'longitude': 100.1931213,
        'id': 'marker_22',
        'icon': 'assents/images/marker_icon_2.png'
      },
      {
        'latitude': 16.7483253,
        'longitude': 100.1950233,
        'id': 'marker_23',
        'icon': 'assents/images/marker_icon_2.png'
      },
      {
        'latitude': 16.7467263,
        'longitude': 100.1959503,
        'id': 'marker_24',
        'icon': 'assents/images/marker_icon_2.png'
      },
      {
        'latitude': 16.7440403,
        'longitude': 100.1970413,
        'id': 'marker_25',
        'icon': 'assents/images/marker_icon_2.png'
      },
    ];

    for (var markerData in markersData) {
      try {
        Uint8List resizedBytes = await _resizeImage(markerData['icon'], 60, 60);
        BitmapDescriptor descriptor = BitmapDescriptor.fromBytes(resizedBytes);
        _addMarker(LatLng(markerData['latitude'], markerData['longitude']),
            markerData['id'], descriptor);
      } catch (e) {
        print('Error loading marker icon for ${markerData['id']}: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      height: height,
      width: width,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            GoogleMap(
              initialCameraPosition: _initialLocation,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              onMapCreated: (GoogleMapController controller) async {
                mapController = controller;
                Position position = await fetchCurrentLocation();
                LatLng currentLocation =
                    LatLng(position.latitude, position.longitude);
                mapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: currentLocation,
                      zoom: 15.0, // Adjust zoom level as needed
                    ),
                  ),
                );
                _addMarker(currentLocation, 'currentLocation',
                    BitmapDescriptor.defaultMarker);
              },
              markers: Set<Marker>.of(markers.values),
            ),
          ],
        ),
      ),
    );
  }
}
