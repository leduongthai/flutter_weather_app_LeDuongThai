import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _search(String city) {
    if (city.trim().isEmpty) return;
    context.read<WeatherProvider>().fetchWeatherByCity(city.trim());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF1A202C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'tìm city',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 100),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white30),
              ),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                decoration: InputDecoration(
                  hintText: 'Nhập tên thành phố...',
                  hintStyle: const TextStyle(color: Colors.white38),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 16),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: () => _search(_controller.text),
                  ),
                ),
                onSubmitted: _search,
                textInputAction: TextInputAction.search,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (provider.favoriteCities.isNotEmpty) ...[
                    _sectionHeader('Favorite Cities'),
                    const SizedBox(height: 8),
                    ...provider.favoriteCities.map((city) => _CityTile(
                          city: city,
                          trailing: IconButton(
                            icon: const Icon(Icons.favorite,
                                color: Colors.pinkAccent, size: 20),
                            onPressed: () =>
                                provider.toggleFavorite(city),
                          ),
                          onTap: () => _search(city),
                        )),
                    const SizedBox(height: 20),
                  ],
                  if (provider.recentSearches.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        _sectionHeader('Recent Searches'),
                        TextButton(
                          onPressed: () =>
                              provider.clearRecentSearches(),
                          child: const Text(
                            'Clear',
                            style: TextStyle(
                                color: Colors.white54, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...provider.recentSearches.take(8).map(
                          (city) => _CityTile(
                            city: city,
                            trailing: const Icon(Icons.history,
                                color: Colors.white38, size: 18),
                            onTap: () => _search(city),
                          ),
                        ),
                    const SizedBox(height: 20),
                  ],
                  _sectionHeader('Popular Cities'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      'Ho Chi Minh City',
                      'Hanoi',
                      'Da Nang',
                      'London',
                      'Tokyo',
                      'New York',
                      'Paris',
                      'Sydney',
                      'Singapore',
                      'Bangkok',
                    ].map((city) => _CityChip(
                          city: city,
                          onTap: () => _search(city),
                        )).toList(),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _CityTile extends StatelessWidget {
  final String city;
  final Widget trailing;
  final VoidCallback onTap;

  const _CityTile({
    required this.city,
    required this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on, color: Colors.white54, size: 18),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                city,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

class _CityChip extends StatelessWidget {
  final String city;
  final VoidCallback onTap;

  const _CityChip({required this.city, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24),
        ),
        child: Text(
          city,
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
      ),
    );
  }
}
