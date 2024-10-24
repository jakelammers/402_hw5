import 'dart:convert';
import 'package:http/http.dart' as http;


class WeatherService {
  static const String apiKey = 'YOUR_API_KEY'; // Get from OpenWeatherMap

  Future<WeatherData> getWeather(double lat, double lon) async {
    final url = 'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return WeatherData(
        temperature: data['main']['temp'].toString(),
        condition: data['weather'][0]['description'],
      );
    } else {
      throw Exception('Failed to load weather');
    }
  }
}

class WeatherData {
  final String temperature;
  final String condition;

  WeatherData({required this.temperature, required this.condition});
}
