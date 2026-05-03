import 'package:flutter/material.dart';

class AppConstants {
  static const String celsius = 'Celsius';
  static const String fahrenheit = 'Fahrenheit';

  static const String kmh = 'km/h';
  static const String ms = 'm/s';
  static const String mph = 'mph';

  static const String format12h = '12h';
  static const String format24h = '24h';

  static const int cacheValidMinutes = 30;

  static const int maxFavoriteCities = 5;

  static LinearGradient getGradient(String condition, {bool isNight = false}) {
    if (isNight) {
      return const LinearGradient(
        colors: [Color(0xFF1A202C), Color(0xFF2D3748)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
    switch (condition.toLowerCase()) {
      case 'clear':
        return const LinearGradient(
          colors: [Color(0xFF2980B9), Color(0xFF87CEEB)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'clouds':
        return const LinearGradient(
          colors: [Color(0xFF616161), Color(0xFF9E9E9E)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'rain':
      case 'drizzle':
        return const LinearGradient(
          colors: [Color(0xFF4A5568), Color(0xFF718096)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'thunderstorm':
        return const LinearGradient(
          colors: [Color(0xFF1A202C), Color(0xFF4A5568)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'snow':
        return const LinearGradient(
          colors: [Color(0xFFB0C4DE), Color(0xFFE0EAF5)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'mist':
      case 'fog':
      case 'haze':
        return const LinearGradient(
          colors: [Color(0xFF90A4AE), Color(0xFFB0BEC5)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
    }
  }

  static String getWeatherEmoji(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return '☀️';
      case 'clouds':
        return '☁️';
      case 'rain':
        return '🌧️';
      case 'drizzle':
        return '🌦️';
      case 'thunderstorm':
        return '⛈️';
      case 'snow':
        return '❄️';
      case 'mist':
      case 'fog':
      case 'haze':
        return '🌫️';
      default:
        return '🌡️';
    }
  }
}
