import 'package:flutter/material.dart';

class LoadingShimmer extends StatefulWidget {
  const LoadingShimmer({super.key});

  @override
  State<LoadingShimmer> createState() => _LoadingShimmerState();
}

class _LoadingShimmerState extends State<LoadingShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              _buildTopShimmer(),
              const SizedBox(height: 8),
              _buildCardShimmer(height: 120),
              const SizedBox(height: 8),
              _buildCardShimmer(height: 200),
              const SizedBox(height: 8),
              _buildCardShimmer(height: 260),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopShimmer() {
    return Opacity(
      opacity: _animation.value,
      child: Container(
        height: 380,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _shimmerBox(width: 180, height: 28, radius: 8),
            const SizedBox(height: 12),
            _shimmerBox(width: 100, height: 20, radius: 6),
            const SizedBox(height: 20),
            _shimmerBox(width: 100, height: 100, radius: 50),
            const SizedBox(height: 16),
            _shimmerBox(width: 120, height: 60, radius: 12),
            const SizedBox(height: 12),
            _shimmerBox(width: 160, height: 20, radius: 6),
          ],
        ),
      ),
    );
  }

  Widget _buildCardShimmer({required double height}) {
    return Opacity(
      opacity: _animation.value,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _shimmerBox({
    required double width,
    required double height,
    required double radius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
