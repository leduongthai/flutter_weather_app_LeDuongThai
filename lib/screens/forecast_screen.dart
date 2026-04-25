import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/weather_provider.dart';
import '../config/api_config.dart';
import '../utils/date_formatter.dart';
import '../utils/constants.dart';

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();
    final weather = provider.currentWeather;

    final gradient = weather != null
        ? AppConstants.getGradient(weather.mainCondition,
            isNight: weather.isNight)
        : const LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          weather != null ? '${weather.cityName} - 5 Day Forecast' : 'Forecast',
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
          itemCount: provider.forecast.length,
          itemBuilder: (context, index) {
            final f = provider.forecast[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormatter.formatDayShort(f.dateTime),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          DateFormatter.formatTime(f.dateTime,
                              use24h:
                                  provider.timeFormat == '24h'),
                          style: const TextStyle(
                              color: Colors.white60, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  CachedNetworkImage(
                    imageUrl: ApiConfig.iconUrl(f.icon),
                    height: 40,
                    errorWidget: (_, __, ___) => const Icon(
                        Icons.cloud,
                        color: Colors.white,
                        size: 40),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          f.description,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 13),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.water_drop,
                                color: Colors.lightBlueAccent,
                                size: 12),
                            Text(
                              ' ${f.humidity}%',
                              style: const TextStyle(
                                  color: Colors.white60, fontSize: 12),
                            ),
                            const SizedBox(width: 8),
                            if (f.pop != null && f.pop! > 0)
                              Text(
                                '💧${f.pop}% rain',
                                style: const TextStyle(
                                    color: Colors.lightBlueAccent,
                                    fontSize: 12),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${f.getTemperature(provider.tempUnit).round()}°',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        '${f.getTempMin(provider.tempUnit).round()}° / ${f.getTempMax(provider.tempUnit).round()}°',
                        style: const TextStyle(
                            color: Colors.white60, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
