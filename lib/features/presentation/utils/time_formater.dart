import 'package:intl/intl.dart';

class TimeFormater {
  static String formatPublishedDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('MMM d, yyyy • h:mm a').format(dateTime);
    } catch (e) {
      return 'Unknown date';
    }
  }
}
