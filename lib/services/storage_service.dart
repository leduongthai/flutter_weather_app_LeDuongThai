import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';

class StorageService {
  static const String _weatherKey = 'cached_weather';
  static const String _lastUpdateKey = 'last_update';
  static const String _favoriteCitiesKey = 'favorite_cities';
  static const String _recentSearchesKey = 'recent_searches';
  static const String _tempUnitKey = 'temp_unit';
  static const String _windUnitKey = 'wind_unit';
  static const String _timeFormatKey = 'time_format';

  // ─── Weather Cache ───────────────────────────────────────────────────────

  Future<void> saveWeatherData(WeatherModel weather) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_weatherKey, json.encode(weather.toJson()));
    await prefs.setInt(
        _lastUpdateKey, DateTime.now().millisecondsSinceEpoch);
  }

  Future<WeatherModel?> getCachedWeather() async {
    final prefs = await SharedPreferences.getInstance();
    final weatherJson = prefs.getString(_weatherKey);
    if (weatherJson != null) {
      try {
        return WeatherModel.fromJson(json.decode(weatherJson));
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  Future<bool> isCacheValid() async {
    final prefs = await SharedPreferences.getInstance();
    final lastUpdate = prefs.getInt(_lastUpdateKey);
    if (lastUpdate == null) return false;
    final difference =
        DateTime.now().millisecondsSinceEpoch - lastUpdate;
    return difference < 30 * 60 * 1000; // 30 minutes
  }

  Future<DateTime?> getLastUpdateTime() async {
    final prefs = await SharedPreferences.getInstance();
    final lastUpdate = prefs.getInt(_lastUpdateKey);
    if (lastUpdate == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(lastUpdate);
  }

  // ─── Favorite Cities ─────────────────────────────────────────────────────

  Future<void> saveFavoriteCities(List<String> cities) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoriteCitiesKey, cities);
  }

  Future<List<String>> getFavoriteCities() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoriteCitiesKey) ?? [];
  }

  Future<void> addFavoriteCity(String city) async {
    final cities = await getFavoriteCities();
    if (!cities.contains(city)) {
      cities.insert(0, city);
      if (cities.length > 5) cities.removeLast();
      await saveFavoriteCities(cities);
    }
  }

  Future<void> removeFavoriteCity(String city) async {
    final cities = await getFavoriteCities();
    cities.remove(city);
    await saveFavoriteCities(cities);
  }

  Future<bool> isFavoriteCity(String city) async {
    final cities = await getFavoriteCities();
    return cities.contains(city);
  }

  // ─── Recent Searches ─────────────────────────────────────────────────────

  Future<void> addRecentSearch(String city) async {
    final searches = await getRecentSearches();
    searches.remove(city);
    searches.insert(0, city);
    if (searches.length > 10) searches.removeLast();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_recentSearchesKey, searches);
  }

  Future<List<String>> getRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_recentSearchesKey) ?? [];
  }

  Future<void> clearRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_recentSearchesKey);
  }

  // ─── Settings ────────────────────────────────────────────────────────────

  Future<void> saveTemperatureUnit(String unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tempUnitKey, unit);
  }

  Future<String> getTemperatureUnit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tempUnitKey) ?? 'Celsius';
  }

  Future<void> saveWindUnit(String unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_windUnitKey, unit);
  }

  Future<String> getWindUnit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_windUnitKey) ?? 'm/s';
  }

  Future<void> saveTimeFormat(String format) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_timeFormatKey, format);
  }

  Future<String> getTimeFormat() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_timeFormatKey) ?? '12h';
  }
}
