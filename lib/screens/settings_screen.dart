import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF1A202C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D3748),
        title: const Text('Settings',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          const _SectionHeader(title: '🌡️  Temperature'),
          _SettingsTile(
            title: 'Temperature Unit',
            subtitle: provider.tempUnit,
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'Celsius', label: Text('°C')),
                ButtonSegment(value: 'Fahrenheit', label: Text('°F')),
              ],
              selected: {provider.tempUnit},
              onSelectionChanged: (val) =>
                  provider.setTempUnit(val.first),
              style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.resolveWith<Color?>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Colors.blueAccent.withOpacity(0.7);
                  }
                  return Colors.white.withOpacity(0.08);
                }),
                foregroundColor: WidgetStateProperty.all(Colors.white),
              ),
            ),
          ),
          const Divider(color: Colors.white12),
          const _SectionHeader(title: '💨  Wind Speed'),
          _SettingsTile(
            title: 'Wind Speed Unit',
            subtitle: provider.windUnit,
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'm/s', label: Text('m/s')),
                ButtonSegment(value: 'km/h', label: Text('km/h')),
                ButtonSegment(value: 'mph', label: Text('mph')),
              ],
              selected: {provider.windUnit},
              onSelectionChanged: (val) =>
                  provider.setWindUnit(val.first),
              style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.resolveWith<Color?>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Colors.blueAccent.withOpacity(0.7);
                  }
                  return Colors.white.withOpacity(0.08);
                }),
                foregroundColor: WidgetStateProperty.all(Colors.white),
              ),
            ),
          ),
          const Divider(color: Colors.white12),
          const _SectionHeader(title: '🕐  Time Format'),
          _SettingsTile(
            title: 'Time Format',
            subtitle: provider.timeFormat,
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: '12h', label: Text('12h')),
                ButtonSegment(value: '24h', label: Text('24h')),
              ],
              selected: {provider.timeFormat},
              onSelectionChanged: (val) =>
                  provider.setTimeFormat(val.first),
              style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.resolveWith<Color?>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Colors.blueAccent.withOpacity(0.7);
                  }
                  return Colors.white.withOpacity(0.08);
                }),
                foregroundColor: WidgetStateProperty.all(Colors.white),
              ),
            ),
          ),
          const Divider(color: Colors.white12),
          const _SectionHeader(title: '⭐  Favorites'),
          if (provider.favoriteCities.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'No favorite cities yet.\nSearch for a city and tap ♡ to add it.',
                style: TextStyle(color: Colors.white54, fontSize: 14),
              ),
            )
          else
            ...provider.favoriteCities.map(
              (city) => ListTile(
                leading: const Icon(Icons.favorite, color: Colors.pinkAccent),
                title: Text(city,
                    style: const TextStyle(color: Colors.white)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: Colors.white38),
                  onPressed: () => provider.toggleFavorite(city),
                ),
              ),
            ),
          const Divider(color: Colors.white12),
          const _SectionHeader(title: 'ℹ️  About'),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.white54),
            title: const Text('Weather App',
                style: TextStyle(color: Colors.white)),
            subtitle: const Text('Lab 4 - Flutter Weather Application',
                style: TextStyle(color: Colors.white54, fontSize: 12)),
          ),
          ListTile(
            leading: const Icon(Icons.api, color: Colors.white54),
            title: const Text('Data Source',
                style: TextStyle(color: Colors.white)),
            subtitle: const Text('OpenWeatherMap API',
                style: TextStyle(color: Colors.white54, fontSize: 12)),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _SettingsTile({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(color: Colors.white, fontSize: 15)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
