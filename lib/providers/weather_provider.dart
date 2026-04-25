import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';
import '../services/connectivity_service.dart';

enum WeatherState { initial, loading, loaded, error }

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService;
  final LocationService _locationService;
  final StorageService _storageService;
  final ConnectivityService _connectivityService;

  WeatherModel? _currentWeather;
  List<ForecastModel> _forecast = [];
  WeatherState _state = WeatherState.initial;
  String _errorMessage = '';
  bool _isOffline = false;
  DateTime? _lastUpdated;
  List<String> _favoriteCities = [];
  List<String> _recentSearches = [];

  // Settings
  String _tempUnit = 'Celsius';
  String _windUnit = 'm/s';
  String _timeFormat = '12h';

  WeatherProvider(
    this._weatherService,
    this._locationService,
    this._storageService,
    this._connectivityService,
  ) {
    _loadSettings();
    _loadFavorites();
    _loadRecentSearches();
  }

  // ─── Getters ──────────────────────────────────────────────────────────────
  WeatherModel? get currentWeather => _currentWeather;
  List<ForecastModel> get forecast => _forecast;
  WeatherState get state => _state;
  String get errorMessage => _errorMessage;
  bool get isOffline => _isOffline;
  DateTime? get lastUpdated => _lastUpdated;
  List<String> get favoriteCities => _favoriteCities;
  List<String> get recentSearches => _recentSearches;
  String get tempUnit => _tempUnit;
  String get windUnit => _windUnit;
  String get timeFormat => _timeFormat;

  // ─── Fetch Weather ────────────────────────────────────────────────────────

  Future<void> fetchWeatherByCity(String cityName) async {
    _state = WeatherState.loading;
    notifyListeners();

    final isOnline = await _connectivityService.isConnected();
    if (!isOnline) {
      await _tryLoadCache();
      _isOffline = true;
      notifyListeners();
      return;
    }

    try {
      _currentWeather =
          await _weatherService.getCurrentWeatherByCity(cityName);
      _forecast = await _weatherService.getForecast(cityName);
      await _storageService.saveWeatherData(_currentWeather!);
      await _storageService.addRecentSearch(cityName);
      _recentSearches = await _storageService.getRecentSearches();
      _lastUpdated = DateTime.now();
      _isOffline = false;
      _state = WeatherState.loaded;
      _errorMessage = '';
    } catch (e) {
      _state = WeatherState.error;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    }
    notifyListeners();
  }

  Future<void> fetchWeatherByLocation() async {
    _state = WeatherState.loading;
    notifyListeners();

    final isOnline = await _connectivityService.isConnected();
    if (!isOnline) {
      await _tryLoadCache();
      _isOffline = true;
      notifyListeners();
      return;
    }

    try {
      final position = await _locationService.getCurrentLocation();
      _currentWeather =
          await _weatherService.getCurrentWeatherByCoordinates(
        position.latitude,
        position.longitude,
      );
      _forecast = await _weatherService.getForecastByCoordinates(
        position.latitude,
        position.longitude,
      );
      await _storageService.saveWeatherData(_currentWeather!);
      _lastUpdated = DateTime.now();
      _isOffline = false;
      _state = WeatherState.loaded;
      _errorMessage = '';
    } catch (e) {
      _state = WeatherState.error;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      await _tryLoadCache();
    }
    notifyListeners();
  }

  Future<void> refreshWeather() async {
    if (_currentWeather != null) {
      await fetchWeatherByCity(_currentWeather!.cityName);
    } else {
      await fetchWeatherByLocation();
    }
  }

  Future<void> _tryLoadCache() async {
    final cached = await _storageService.getCachedWeather();
    if (cached != null) {
      _currentWeather = cached;
      _state = WeatherState.loaded;
      _lastUpdated = await _storageService.getLastUpdateTime();
    }
  }

  // ─── Favorites ────────────────────────────────────────────────────────────

  Future<void> _loadFavorites() async {
    _favoriteCities = await _storageService.getFavoriteCities();
    notifyListeners();
  }

  Future<void> toggleFavorite(String city) async {
    if (_favoriteCities.contains(city)) {
      await _storageService.removeFavoriteCity(city);
    } else {
      if (_favoriteCities.length >= 5) {
        _errorMessage = 'Maximum 5 favorite cities allowed';
        notifyListeners();
        return;
      }
      await _storageService.addFavoriteCity(city);
    }
    _favoriteCities = await _storageService.getFavoriteCities();
    notifyListeners();
  }

  bool isFavorite(String city) => _favoriteCities.contains(city);

  // ─── Recent Searches ──────────────────────────────────────────────────────

  Future<void> _loadRecentSearches() async {
    _recentSearches = await _storageService.getRecentSearches();
    notifyListeners();
  }

  Future<void> clearRecentSearches() async {
    await _storageService.clearRecentSearches();
    _recentSearches = [];
    notifyListeners();
  }

  // ─── Settings ─────────────────────────────────────────────────────────────

  Future<void> _loadSettings() async {
    _tempUnit = await _storageService.getTemperatureUnit();
    _windUnit = await _storageService.getWindUnit();
    _timeFormat = await _storageService.getTimeFormat();
    notifyListeners();
  }

  Future<void> setTempUnit(String unit) async {
    _tempUnit = unit;
    await _storageService.saveTemperatureUnit(unit);
    notifyListeners();
  }

  Future<void> setWindUnit(String unit) async {
    _windUnit = unit;
    await _storageService.saveWindUnit(unit);
    notifyListeners();
  }

  Future<void> setTimeFormat(String format) async {
    _timeFormat = format;
    await _storageService.saveTimeFormat(format);
    notifyListeners();
  }

  // ─── Forecast helpers ─────────────────────────────────────────────────────

  List<ForecastModel> get hourlyForecast {
    final now = DateTime.now();
    return _forecast
        .where((f) => f.dateTime.isAfter(now))
        .take(8)
        .toList();
  }

  List<ForecastModel> get dailyForecast {
    final Map<String, ForecastModel> dailyMap = {};
    for (final f in _forecast) {
      final key =
          '${f.dateTime.year}-${f.dateTime.month}-${f.dateTime.day}';
      if (!dailyMap.containsKey(key)) {
        dailyMap[key] = f;
      }
    }
    return dailyMap.values.take(5).toList();
  }
}
