class WeatherModel {
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final double windDeg;
  final int pressure;
  final String description;
  final String icon;
  final String mainCondition;
  final DateTime dateTime;
  final double? tempMin;
  final double? tempMax;
  final int? visibility;
  final int? cloudiness;
  final int? sunrise;
  final int? sunset;
  final double? lat;
  final double? lon;

  WeatherModel({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    this.windDeg = 0,
    required this.pressure,
    required this.description,
    required this.icon,
    required this.mainCondition,
    required this.dateTime,
    this.tempMin,
    this.tempMax,
    this.visibility,
    this.cloudiness,
    this.sunrise,
    this.sunset,
    this.lat,
    this.lon,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] ?? 'Unknown',
      country: json['sys']?['country'] ?? '',
      temperature: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      humidity: json['main']['humidity'],
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      windDeg: ((json['wind']['deg'] ?? 0) as num).toDouble(),
      pressure: json['main']['pressure'],
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      mainCondition: json['weather'][0]['main'],
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      tempMin: (json['main']['temp_min'] as num?)?.toDouble(),
      tempMax: (json['main']['temp_max'] as num?)?.toDouble(),
      visibility: json['visibility'],
      cloudiness: json['clouds']?['all'],
      sunrise: json['sys']?['sunrise'],
      sunset: json['sys']?['sunset'],
      lat: (json['coord']?['lat'] as num?)?.toDouble(),
      lon: (json['coord']?['lon'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': cityName,
      'sys': {'country': country, 'sunrise': sunrise, 'sunset': sunset},
      'main': {
        'temp': temperature,
        'feels_like': feelsLike,
        'humidity': humidity,
        'pressure': pressure,
        'temp_min': tempMin,
        'temp_max': tempMax,
      },
      'wind': {'speed': windSpeed, 'deg': windDeg},
      'weather': [
        {
          'description': description,
          'icon': icon,
          'main': mainCondition,
        }
      ],
      'dt': dateTime.millisecondsSinceEpoch ~/ 1000,
      'visibility': visibility,
      'clouds': {'all': cloudiness},
      'coord': {'lat': lat, 'lon': lon},
    };
  }

  // Convert temperature based on unit setting
  double getTemperature(String unit) {
    if (unit == 'Fahrenheit') {
      return temperature * 9 / 5 + 32;
    }
    return temperature;
  }

  double getFeelsLike(String unit) {
    if (unit == 'Fahrenheit') {
      return feelsLike * 9 / 5 + 32;
    }
    return feelsLike;
  }

  String getWindSpeed(String unit) {
    switch (unit) {
      case 'km/h':
        return '${(windSpeed * 3.6).toStringAsFixed(1)} km/h';
      case 'mph':
        return '${(windSpeed * 2.237).toStringAsFixed(1)} mph';
      default:
        return '${windSpeed.toStringAsFixed(1)} m/s';
    }
  }

  String getWindDirection() {
    const directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    final index = ((windDeg + 22.5) / 45).floor() % 8;
    return directions[index];
  }

  bool get isNight {
    if (sunrise != null && sunset != null) {
      final now = dateTime.millisecondsSinceEpoch ~/ 1000;
      return now < sunrise! || now > sunset!;
    }
    return false;
  }
}
