import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/weather_model.dart';
import '../config/api_config.dart';
import '../utils/constants.dart';
import '../utils/date_formatter.dart';
import '../providers/weather_provider.dart';

class CurrentWeatherCard extends StatelessWidget {
  final WeatherModel weather;

  const CurrentWeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();
    final tempUnit = provider.tempUnit;
    final timeFormat = provider.timeFormat;
    final isFav = provider.isFavorite(weather.cityName);
    final gradient = AppConstants.getGradient(
      weather.mainCondition,
      isNight: weather.isNight,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      decoration: BoxDecoration(gradient: gradient),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  '${weather.cityName}, ${weather.country}',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: Colors.white,
                ),
                onPressed: () =>
                    provider.toggleFavorite(weather.cityName),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            DateFormatter.formatDate(weather.dateTime,
                use24h: timeFormat == '24h'),
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 16),
          CachedNetworkImage(
            imageUrl: ApiConfig.iconUrlLarge(weather.icon),
            height: 100,
            placeholder: (_, __) => const SizedBox(
              height: 100,
              child: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
            errorWidget: (_, __, ___) => Text(
              AppConstants.getWeatherEmoji(weather.mainCondition),
              style: const TextStyle(fontSize: 80),
            ),
          ),
          Text(
            '${weather.getTemperature(tempUnit).round()}°${tempUnit == 'Celsius' ? 'C' : 'F'}',
            style: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.w200,
              color: Colors.white,
            ),
          ),
          Text(
            weather.description.toUpperCase(),
            style: const TextStyle(
              fontSize: 18,
              letterSpacing: 2,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Feels like ${weather.getFeelsLike(tempUnit).round()}°',
            style: const TextStyle(fontSize: 15, color: Colors.white70),
          ),
          if (weather.tempMin != null && weather.tempMax != null) ...[
            const SizedBox(height: 4),
            Text(
              'H: ${weather.getTemperature(tempUnit == 'Celsius' ? 'Celsius' : 'Fahrenheit').round()}° / L: ${(weather.tempMin! * (tempUnit == 'Fahrenheit' ? 1.8 : 1) + (tempUnit == 'Fahrenheit' ? 32 : 0)).round()}°',
              style:
                  const TextStyle(fontSize: 14, color: Colors.white60),
            ),
          ],
          const SizedBox(height: 20),
          _buildQuickStats(provider),
        ],
      ),
    );
  }

  Widget _buildQuickStats(WeatherProvider provider) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem(
              '💧', '${weather.humidity}%', 'Humidity'),
          _divider(),
          _statItem(
              '💨',
              weather.getWindSpeed(provider.windUnit),
              'Wind'),
          _divider(),
          _statItem(
              '🔵', '${weather.pressure} hPa', 'Pressure'),
        ],
      ),
    );
  }

  Widget _statItem(String emoji, String value, String label) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13)),
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }

  Widget _divider() => Container(
        height: 40,
        width: 1,
        color: Colors.white.withOpacity(0.3),
      );
}
