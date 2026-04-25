import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/forecast_model.dart';
import '../config/api_config.dart';
import '../utils/date_formatter.dart';
import '../providers/weather_provider.dart';

class HourlyForecastList extends StatelessWidget {
  final List<ForecastModel> forecasts;

  const HourlyForecastList({super.key, required this.forecasts});

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
              Icon(Icons.access_time, color: Colors.white70, size: 16),
              SizedBox(width: 6),
              Text(
                'HOURLY FORECAST',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: forecasts.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final f = forecasts[index];
                return _HourlyItem(
                  forecast: f,
                  tempUnit: provider.tempUnit,
                  timeFormat: provider.timeFormat,
                  isFirst: index == 0,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HourlyItem extends StatelessWidget {
  final ForecastModel forecast;
  final String tempUnit;
  final String timeFormat;
  final bool isFirst;

  const _HourlyItem({
    required this.forecast,
    required this.tempUnit,
    required this.timeFormat,
    required this.isFirst,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          isFirst
              ? 'Now'
              : DateFormatter.formatHour(forecast.dateTime,
                  use24h: timeFormat == '24h'),
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
        CachedNetworkImage(
          imageUrl: ApiConfig.iconUrl(forecast.icon),
          height: 36,
          errorWidget: (_, __, ___) =>
              const Icon(Icons.cloud, color: Colors.white, size: 36),
        ),
        Text(
          '${forecast.getTemperature(tempUnit).round()}°',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        if (forecast.pop != null && forecast.pop! > 0)
          Text(
            '💧${forecast.pop}%',
            style:
                const TextStyle(color: Colors.lightBlueAccent, fontSize: 11),
          ),
      ],
    );
  }
}
