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
              'plateNumber': item['plateNumber'].toString(),
              'position': {
                'latitude': double.parse(item['Latitude'].toString()),
                'longitude': double.parse(item['Longitude'].toString()),
              }
            });
          }
        }
        print('Locations data:');
        print(json.encode(locations));
        print('Total locations: ${locations.length}');
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
  // สร้างออบเจ็กต์จากคลาส ApiService
  ApiService apiService = ApiService();

  try {
    // เรียกใช้ฟังก์ชัน fetchLocations() เพื่อดึงข้อมูลที่ตั้งและหมายเลขทะเบียนของรถทุกคัน
    List<Map<String, dynamic>> locations = await apiService.fetchLocations();

    // แสดงข้อมูลที่ตั้งและหมายเลขทะเบียนของรถทุกคัน
    for (var location in locations) {
      //print('Plate Number: ${location['plateNumber']}');
      //print('Latitude: ${location['latitude']}');
      //print('Longitude: ${location['longitude']}');
      //print('-----------------------');
    }
  } catch (e) {
    // แสดงข้อผิดพลาดถ้ามี
    print('Error: $e');
  }
}
