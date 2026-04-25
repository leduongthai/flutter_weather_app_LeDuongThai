import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/hourly_forecast_list.dart';
import '../widgets/daily_forecast_card.dart';
import '../widgets/weather_detail_item.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/error_widget.dart';
import '../utils/constants.dart';
import '../utils/date_formatter.dart';
import 'search_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().fetchWeatherByLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();
    final weather = provider.currentWeather;

    // Background gradient
    final gradient = weather != null
        ? AppConstants.getGradient(weather.mainCondition,
            isNight: weather.isNight)
        : const LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.my_location, color: Colors.white),
          tooltip: 'Use my location',
          onPressed: () => provider.fetchWeatherByLocation(),
        ),
        title: weather != null
            ? Column(
                children: [
                  Text(
                    provider.isOffline ? '📵 Offline Mode' : '',
                    style:
                        const TextStyle(color: Colors.orangeAccent, fontSize: 11),
                  ),
                  if (provider.lastUpdated != null)
                    Text(
                      'Updated ${DateFormatter.timeAgo(provider.lastUpdated!)}',
                      style: const TextStyle(
                          color: Colors.white60, fontSize: 11),
                    ),
                ],
              )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            tooltip: 'Search city',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: RefreshIndicator(
          onRefresh: () => provider.refreshWeather(),
          color: Colors.white,
          backgroundColor: Colors.transparent,
          child: _buildBody(provider),
        ),
      ),
      floatingActionButton: provider.state == WeatherState.loaded
          ? FloatingActionButton.small(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              ),
              backgroundColor: Colors.white.withOpacity(0.2),
              child: const Icon(Icons.search, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildBody(WeatherProvider provider) {
    if (provider.state == WeatherState.loading) {
      return const LoadingShimmer();
    }

    if (provider.state == WeatherState.error &&
        provider.currentWeather == null) {
      return ErrorWidgetCustom(
        message: provider.errorMessage,
        onRetry: () => provider.fetchWeatherByLocation(),
      );
    }

    if (provider.currentWeather == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🌤️', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 16),
            const Text(
              'Welcome to Weather App',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Getting your location...',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => provider.fetchWeatherByLocation(),
              icon: const Icon(Icons.my_location),
              label: const Text('Use My Location'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.25),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    final weather = provider.currentWeather!;
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          CurrentWeatherCard(weather: weather),
          if (provider.isOffline)
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wifi_off, color: Colors.orange, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Showing cached data — No internet connection',
                    style: TextStyle(color: Colors.orange, fontSize: 13),
                  ),
                ],
              ),
            ),
          if (provider.hourlyForecast.isNotEmpty)
            HourlyForecastList(forecasts: provider.hourlyForecast),
          if (provider.dailyForecast.isNotEmpty)
            DailyForecastSection(forecasts: provider.forecast),
          WeatherDetailsSection(weather: weather),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
