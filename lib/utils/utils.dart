import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:intl/intl.dart';

final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

Widget horizontalDivider() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Divider(color: Colors.white.withOpacity(0.2)),
  );
}

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

debugLog(String s) {
  return log("vishwa : $s");
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
