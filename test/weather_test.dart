import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/models/forecast_model.dart';

final sampleWeatherJson = {
  'name': 'Ho Chi Minh City',
  'sys': {'country': 'VN', 'sunrise': 1700000000, 'sunset': 1700043600},
  'main': {
    'temp': 35.0,
    'feels_like': 40.0,
    'humidity': 75,
    'pressure': 1010,
    'temp_min': 30.0,
    'temp_max': 38.0,
  },
  'wind': {'speed': 3.5, 'deg': 90.0},
  'weather': [
    {'description': 'clear sky', 'icon': '01d', 'main': 'Clear'}
  ],
  'dt': 1700020000,
  'visibility': 10000,
  'clouds': {'all': 5},
  'coord': {'lat': 10.8231, 'lon': 106.6297},
};

final sampleForecastJson = {
  'dt': 1700031600,
  'main': {
    'temp': 32.0,
    'temp_min': 28.0,
    'temp_max': 36.0,
    'humidity': 70,
  },
  'weather': [
    {'description': 'partly cloudy', 'icon': '02d', 'main': 'Clouds'}
  ],
  'wind': {'speed': 4.0},
  'pop': 0.2,
};

void main() {
  group('WeatherModel Tests', () {
    test('Parse weather JSON correctly', () {
      final weather = WeatherModel.fromJson(sampleWeatherJson);
      expect(weather.temperature, 35.0);
      expect(weather.cityName, 'Ho Chi Minh City');
      expect(weather.country, 'VN');
      expect(weather.humidity, 75);
      expect(weather.windSpeed, 3.5);
      expect(weather.mainCondition, 'Clear');
      expect(weather.description, 'clear sky');
    });

    test('Convert to JSON and back', () {
      final weather = WeatherModel.fromJson(sampleWeatherJson);
      final json = weather.toJson();
      final weather2 = WeatherModel.fromJson(json);
      expect(weather2.cityName, weather.cityName);
      expect(weather2.temperature, weather.temperature);
      expect(weather2.humidity, weather.humidity);
    });

    test('Temperature unit conversion - Celsius to Fahrenheit', () {
      final weather = WeatherModel.fromJson(sampleWeatherJson);
      final fahrenheit = weather.getTemperature('Fahrenheit');
      expect(fahrenheit, closeTo(95.0, 0.5)); // 35°C = 95°F
    });

    test('Wind direction calculation', () {
      final weather = WeatherModel.fromJson(sampleWeatherJson);
      expect(weather.getWindDirection(), 'E');
    });

    test('Wind speed unit conversions', () {
      final weather = WeatherModel.fromJson(sampleWeatherJson);
      expect(weather.getWindSpeed('m/s'), contains('m/s'));
      expect(weather.getWindSpeed('km/h'), contains('km/h'));
      expect(weather.getWindSpeed('mph'), contains('mph'));
    });
  });

  group('ForecastModel Tests', () {
    test('Parse forecast JSON correctly', () {
      final forecast = ForecastModel.fromJson(sampleForecastJson);
      expect(forecast.temperature, 32.0);
      expect(forecast.tempMin, 28.0);
      expect(forecast.tempMax, 36.0);
      expect(forecast.humidity, 70);
      expect(forecast.mainCondition, 'Clouds');
      expect(forecast.pop, 20); // 0.2 * 100
    });

    test('Forecast temperature unit conversion', () {
      final forecast = ForecastModel.fromJson(sampleForecastJson);
      final fahrenheit = forecast.getTemperature('Fahrenheit');
      expect(fahrenheit, closeTo(89.6, 0.5)); // 32°C ≈ 89.6°F
    });

    test('Forecast min/max temperature conversion', () {
      final forecast = ForecastModel.fromJson(sampleForecastJson);
      expect(forecast.getTempMin('Celsius'), 28.0);
      expect(forecast.getTempMax('Celsius'), 36.0);
      expect(forecast.getTempMin('Fahrenheit'), closeTo(82.4, 0.5));
      expect(forecast.getTempMax('Fahrenheit'), closeTo(96.8, 0.5));
    });
  });

  group('WeatherModel Edge Cases', () {
    test('Handle missing optional fields', () {
      final minimalJson = {
        'name': 'Test City',
        'sys': {'country': 'US'},
        'main': {
          'temp': 20.0,
          'feels_like': 18.0,
          'humidity': 50,
          'pressure': 1013,
        },
        'wind': {'speed': 2.0},
        'weather': [
          {'description': 'sunny', 'icon': '01d', 'main': 'Clear'}
        ],
        'dt': 1700000000,
      };

      final weather = WeatherModel.fromJson(minimalJson);
      expect(weather.visibility, isNull);
      expect(weather.cloudiness, isNull);
      expect(weather.sunrise, isNull);
      expect(weather.sunset, isNull);
    });

    test('Temperature stays Celsius when unit is Celsius', () {
      final weather = WeatherModel.fromJson(sampleWeatherJson);
      expect(weather.getTemperature('Celsius'), 35.0);
    });
  });

  group('WeatherModel Serialization', () {
    test('toJson contains all required fields', () {
      final weather = WeatherModel.fromJson(sampleWeatherJson);
      final json = weather.toJson();
      expect(json.containsKey('name'), true);
      expect(json.containsKey('main'), true);
      expect(json.containsKey('wind'), true);
      expect(json.containsKey('weather'), true);
      expect(json.containsKey('dt'), true);
    });
  });
}
