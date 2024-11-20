import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String getFormattedDate(String dateStr) {
  // Parse the input string "MM-dd-yyyy" into a DateTime object
  DateTime date = DateFormat('MM-dd-yyyy').parse(dateStr);

  DateTime today = DateTime.now();
  DateTime yesterday = today.subtract(Duration(days: 1));

  // Check if the date is today
  if (DateFormat('yyyy-MM-dd').format(date) ==
      DateFormat('yyyy-MM-dd').format(today)) {
    return "Today";
  }
  // Check if the date is yesterday
  else if (DateFormat('yyyy-MM-dd').format(date) ==
      DateFormat('yyyy-MM-dd').format(yesterday)) {
    return "Yesterday";
  }
  // For any other date, return in the format "Day, d Month"
  else {
    return DateFormat('EEEE, d MMMM').format(date);
  }
}

String formatDateTime(DateTime date) {
  DateTime now = DateTime.now();
  DateFormat timeFormat = DateFormat.jm(); // For formatting time as 9:30 pm

  // Check if the date is today
  if (date.day == now.day && date.month == now.month && date.year == now.year) {
    return "Today, ${timeFormat.format(date)}";
  }

  // Optionally, handle cases for yesterday or other formats as needed
  // For example:
  // else if (date.day == now.day - 1 && date.month == now.month && date.year == now.year) {
  //   return "Yesterday, ${timeFormat.format(date)}";
  // }

  // Fallback for dates not today
  return DateFormat('d MMMM ,').add_jm().format(date);
}

bool isRecentlyActive(DateTime lastSeen) {
  return DateTime.now().difference(lastSeen).inMinutes < 10;
}

bool isWithinLastTwoMonths(Timestamp timestamp) {
  // Get the current date and the date from the timestamp
  DateTime currentDate = DateTime.now();
  DateTime givenDate = timestamp.toDate();

  // Calculate the difference in months
  int monthDifference = (currentDate.year - givenDate.year) * 12 +
      (currentDate.month - givenDate.month);

  // Check if the given date is within the last 2 months
  return monthDifference <= 1;
}
