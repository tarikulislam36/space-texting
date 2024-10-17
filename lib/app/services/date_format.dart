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
