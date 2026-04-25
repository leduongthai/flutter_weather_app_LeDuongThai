import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime dateTime, {bool use24h = false}) {
    return DateFormat('EEEE, MMM d').format(dateTime);
  }

  static String formatTime(DateTime dateTime, {bool use24h = false}) {
    if (use24h) {
      return DateFormat('HH:mm').format(dateTime);
    }
    return DateFormat('h:mm a').format(dateTime);
  }

  static String formatDayShort(DateTime dateTime) {
    final now = DateTime.now();
    if (dateTime.day == now.day &&
        dateTime.month == now.month &&
        dateTime.year == now.year) {
      return 'Today';
    }
    if (dateTime.day == now.add(const Duration(days: 1)).day) {
      return 'Tomorrow';
    }
    return DateFormat('EEE').format(dateTime);
  }

  static String formatHour(DateTime dateTime, {bool use24h = false}) {
    if (use24h) {
      return DateFormat('HH:00').format(dateTime);
    }
    return DateFormat('h a').format(dateTime);
  }

  static String formatSuntime(int unixTimestamp) {
    final dt =
        DateTime.fromMillisecondsSinceEpoch(unixTimestamp * 1000);
    return DateFormat('h:mm a').format(dt);
  }

  static String timeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
