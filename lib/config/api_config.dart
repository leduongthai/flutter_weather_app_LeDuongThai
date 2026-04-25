import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';

  static String get apiKey =>
      dotenv.env['OPENWEATHER_API_KEY'] ?? 'your_api_key_here';

  // Endpoints
  static const String currentWeather = '/weather';
  static const String forecast = '/forecast';
  static const String oneCall = '/onecall';
  static const String airPollution = '/air_pollution';

  // Build URL with query parameters
  static String buildUrl(String endpoint, Map<String, dynamic> params) {
    final uri = Uri.parse('$baseUrl$endpoint');
    params['appid'] = apiKey;
    params['units'] = 'metric';
    return uri.replace(queryParameters: params.map(
      (key, value) => MapEntry(key, value.toString()),
    )).toString();
  }

  // Icon URL
  static String iconUrl(String iconCode) =>
      'https://openweathermap.org/img/wn/$iconCode@2x.png';

  static String iconUrlLarge(String iconCode) =>
      'https://openweathermap.org/img/wn/$iconCode@4x.png';
}
