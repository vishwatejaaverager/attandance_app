import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

Widget horizontalDivider() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Divider(color: Colors.white.withOpacity(0.2)),
  );
}

// this is universal snackbar could be used with out context
appToast(String message) {
  snackbarKey.currentState?.showSnackBar(
    SnackBar(behavior: SnackBarBehavior.floating, content: Text(message)),
  );
}

sbh(double h) {
  return SizedBox(height: h);
}

sbw(double w) {
  return SizedBox(width: w);
}

// function to calc the hours
bool isMoreThanNineHours(String checkIn, String checkOut) {
  try {
    // Define the format
    DateFormat format = DateFormat("HH:mm");

    // Parse the time strings
    DateTime now = DateTime.now(); // Get today's date
    DateTime inTime = format.parse(checkIn);
    DateTime outTime = format.parse(checkOut);

    // Convert to DateTime with today's date
    DateTime fullInTime = DateTime(
      now.year,
      now.month,
      now.day,
      inTime.hour,
      inTime.minute,
    );
    DateTime fullOutTime = DateTime(
      now.year,
      now.month,
      now.day,
      outTime.hour,
      outTime.minute,
    );

    // Handle overnight shifts (check-out past midnight)
    if (fullOutTime.isBefore(fullInTime)) {
      fullOutTime = fullOutTime.add(Duration(days: 1));
    }

    // Calculate duration
    Duration diff = fullOutTime.difference(fullInTime);

    return diff.inHours > 9;
  } catch (e) {
    print("Error parsing time: $e");
    return false; // Return false if parsing fails
  }
}

/// Parses API timestamp and returns formatted time (hh:mm a)
String formatApiTime(String apiTime) {
  try {
    DateTime dateTime = DateTime.parse(
      apiTime,
    ); // Convert API string to DateTime
    return DateFormat("hh:mm a").format(dateTime); // Format as HH:mm AM/PM
  } catch (e) {
    return apiTime; // Return original if parsing fails
  }
}
