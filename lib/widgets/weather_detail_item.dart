import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/weather_model.dart';
import '../providers/weather_provider.dart';
import '../utils/date_formatter.dart';

class WeatherDetailsSection extends StatelessWidget {
  final WeatherModel weather;

  const WeatherDetailsSection({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.white70, size: 16),
              SizedBox(width: 6),
              Text(
                'WEATHER DETAILS',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.8,
            children: [
              _DetailCard(
                icon: '💧',
                label: 'Humidity',
                value: '${weather.humidity}%',
              ),
              _DetailCard(
                icon: '💨',
                label: 'Wind',
                value:
                    '${weather.getWindSpeed(provider.windUnit)} ${weather.getWindDirection()}',
              ),
              _DetailCard(
                icon: '🌡️',
                label: 'Pressure',
                value: '${weather.pressure} hPa',
              ),
              _DetailCard(
                icon: '👁️',
                label: 'Visibility',
                value: weather.visibility != null
                    ? '${(weather.visibility! / 1000).toStringAsFixed(1)} km'
                    : 'N/A',
              ),
              _DetailCard(
                icon: '☁️',
                label: 'Cloudiness',
                value: weather.cloudiness != null
                    ? '${weather.cloudiness}%'
                    : 'N/A',
              ),
              if (weather.sunrise != null)
                _DetailCard(
                  icon: '🌅',
                  label: 'Sunrise',
                  value: DateFormatter.formatSuntime(weather.sunrise!),
                ),
              if (weather.sunset != null)
                _DetailCard(
                  icon: '🌇',
                  label: 'Sunset',
                  value: DateFormatter.formatSuntime(weather.sunset!),
                ),
              _DetailCard(
                icon: '🌡️',
                label: 'Feels Like',
                value:
                    '${weather.getFeelsLike(provider.tempUnit).round()}°',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const _DetailCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$icon  $label',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
