import 'package:flutter/material.dart';

class HeartbeatBadge extends StatefulWidget {
  final double change24;
  const HeartbeatBadge({super.key, required this.change24});

  @override
  State<HeartbeatBadge> createState() => _HeartbeatBadgeState();
}

class _HeartbeatBadgeState extends State<HeartbeatBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    Future.delayed(const Duration(seconds: 1), _startPulse);
  }

  void _startPulse() {
    if (!mounted) return;
    _controller.forward().then((_) {
      _controller.reverse().then((_) {
        Future.delayed(const Duration(seconds: 3), _startPulse);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isPositive = widget.change24 > 0;
    final String text =
        '${isPositive ? '+' : ''}${widget.change24.toStringAsFixed(2)}%';

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isPositive ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: (isPositive ? Colors.green : Colors.red).withOpacity(0.6),
              blurRadius: 8,
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
