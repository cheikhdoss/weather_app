import 'package:dio/dio.dart';
import '../models/city.dart';
import '../models/weather.dart';

class WeatherApiService {
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';
  final Dio _dio = Dio();

  Future<Weather> fetchWeather(City city) async {
    final response = await _dio.get(_baseUrl, queryParameters: {
      'latitude': city.lat,
      'longitude': city.lon,
      'current_weather': true,
      'hourly': 'relative_humidity_2m,weathercode',
      'timezone': 'auto',
    });
    return Weather.fromOpenMeteoJson(response.data);
  }
} 