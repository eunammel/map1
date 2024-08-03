import 'package:flutter/material.dart';
import 'api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Location App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CarLocationPage(),
    );
  }
}

class CarLocationPage extends StatefulWidget {
  @override
  _CarLocationPageState createState() => _CarLocationPageState();
}

class _CarLocationPageState extends State<CarLocationPage> {
  List<Map<String, dynamic>> car_location = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCarLocations();
  }

  Future<void> fetchCarLocations() async {
    ApiService apiService = ApiService();
    try {
      List<Map<String, dynamic>> locations = await apiService.fetchLocations();
      setState(() {
        car_location = locations
            .map((location) => {
                  'plateNumber': location['plateNumber'],
                  'position': {
                    'latitude': location['latitude'],
                    'longitude': location['longitude']
                  }
                })
            .toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Locations'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: car_location.length,
              itemBuilder: (context, index) {
                final car = car_location[index];
                return ListTile(
                  title: Text('Plate Number: ${car['plateNumber']}'),
                  subtitle: Text(
                      'Lat: ${car['position']['latitude']}, Lon: ${car['position']['longitude']}'),
                );
              },
            ),
    );
  }
}
