class ForecastModel {
  final DateTime dateTime;
  final double temperature;
  final String description;
  final String icon;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final double windSpeed;
  final String mainCondition;
  final int? pop; // probability of precipitation (0-100)

  ForecastModel({
    required this.dateTime,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.windSpeed,
    required this.mainCondition,
    this.pop,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return ForecastModel(
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      tempMin: (json['main']['temp_min'] as num).toDouble(),
      tempMax: (json['main']['temp_max'] as num).toDouble(),
      humidity: json['main']['humidity'],
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      mainCondition: json['weather'][0]['main'],
      pop: json['pop'] != null ? ((json['pop'] as num) * 100).round() : 0,
    );
  }

  double getTemperature(String unit) {
    if (unit == 'Fahrenheit') return temperature * 9 / 5 + 32;
    return temperature;
  }

  double getTempMin(String unit) {
    if (unit == 'Fahrenheit') return tempMin * 9 / 5 + 32;
    return tempMin;
  }

  double getTempMax(String unit) {
    if (unit == 'Fahrenheit') return tempMax * 9 / 5 + 32;
    return tempMax;
  }
}
