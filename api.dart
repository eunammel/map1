import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiUrl = 'https://transit.nu.ac.th/allGPS';

  Future<List<Map<String, dynamic>>> fetchLocations() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List && data.isNotEmpty) {
        List<Map<String, dynamic>> locations = [];
        for (var item in data) {
          if (item is Map &&
              item.containsKey('Latitude') &&
              item.containsKey('Longitude') &&
              item.containsKey('plateNumber')) {
            locations.add({
              'latitude': double.parse(item['Latitude'].toString()),
              'longitude': double.parse(item['Longitude'].toString()),
              'plateNumber': item['plateNumber'].toString(),
            });
          }
        }
        return locations;
      } else {
        throw Exception('Unexpected data format');
      }
    } else {
      throw Exception('Failed to load location data');
    }
  }
}

void main() async {
  ApiService apiService = ApiService();
  try {
    List<Map<String, dynamic>> locations = await apiService.fetchLocations();

    // เพิ่มตัวแปรอาร์เรย์ car_location เพื่อเก็บตำแหน่งของรถทุกคัน
    List<Map<String, dynamic>> car_location = [];

    for (var location in locations) {
      // เพิ่มข้อมูลลงในอาร์เรย์ car_location
      car_location.add({
        'plateNumber': location['plateNumber'],
        'position': {
          'latitude': location['latitude'],
          'longitude': location['longitude']
        }
      });
    }

    // แสดงข้อมูลในอาร์เรย์ car_location
    print('Car Location Array:');
    print(car_location);
  } catch (e) {
    print('Error: $e');
  }
}
