import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/forecast_model.dart';
import '../config/api_config.dart';
import '../utils/date_formatter.dart';
import '../providers/weather_provider.dart';

class DailyForecastSection extends StatelessWidget {
  final List<ForecastModel> forecasts;

  const DailyForecastSection({super.key, required this.forecasts});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();
    final daily = provider.dailyForecast;

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
              Icon(Icons.calendar_today,
                  color: Colors.white70, size: 16),
              SizedBox(width: 6),
              Text(
                '5-DAY FORECAST',
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
          ...daily.map((f) => _DailyRow(
                forecast: f,
                tempUnit: provider.tempUnit,
              )),
        ],
      ),
    );
  }
}

class _DailyRow extends StatelessWidget {
  final ForecastModel forecast;
  final String tempUnit;

  const _DailyRow({required this.forecast, required this.tempUnit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              DateFormatter.formatDayShort(forecast.dateTime),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
          ),
          CachedNetworkImage(
            imageUrl: ApiConfig.iconUrl(forecast.icon),
            height: 28,
            errorWidget: (_, __, ___) =>
                const Icon(Icons.cloud, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              forecast.description,
              style:
                  const TextStyle(color: Colors.white70, fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (forecast.pop != null && forecast.pop! > 0) ...[
            Text(
              '💧${forecast.pop}%',
              style: const TextStyle(
                  color: Colors.lightBlueAccent, fontSize: 12),
            ),
            const SizedBox(width: 8),
          ],
          Text(
            '${forecast.getTempMin(tempUnit).round()}° / ${forecast.getTempMax(tempUnit).round()}°',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
