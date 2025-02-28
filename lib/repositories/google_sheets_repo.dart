import 'package:emorald_attendee/models/employe_model.dart';
import 'package:emorald_attendee/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final googleSheetsRepoProvider = Provider((ref) => GoogleSheetsRepo());

class GoogleSheetsRepo {
  final String apiUrl =
      'https://script.google.com/macros/s/AKfycbzvm2f88w8mXrhhao8NqDZMCpf95ylJQpMIQM7z6pulFydWeanHPTkeo4Mxosr6EHru1Q/exec';

  Future<List<EmployeModel>> fetchAttendanceData(String datenow) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://script.google.com/macros/s/AKfycbz7yJj8w01EPZ4-a3m5APseIbWby2yVXzHgkBC4ucSd4Qx7FxkmMlYsY3dfkJV2NBU3Bw/exec?date=$datenow',
        ),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData is List) {
          final data =
              jsonData.map((item) => EmployeModel.fromJson(item)).toList();

          return data;
        } else {
          appToast("Unexpected JSON structure: $jsonData");
          return [];
        }
      } else {
        appToast('HTTP error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addEmployee(EmployeModel employye) async {
    final Map<String, dynamic> employeeData = employye.toJson();
    final res = jsonEncode(employeeData);

    final response = await http.post(
      Uri.parse(
        "https://script.google.com/macros/s/AKfycbz0Rr7aHysLLltWVpSv8iIv41irJwhwqJzhbn_WCZpT8kPo5giq3mtp975muTVrUZGy8A/exec",
      ),
      headers: {"Content-Type": "application/json"},
      body: res,
    );

    if (response.statusCode == 200) {
      appToast("Employee added: ${response.body}");
    } else {
      appToast("Error adding employee: ${response.body}");
    }
  }

  Future<void> updateLoggings(EmployeModel employye) async {
    final Map<String, dynamic> employeeData = employye.toJson();

    final res = jsonEncode(employeeData);

    try {
      final response = await http.post(
        Uri.parse(
          "https://script.google.com/macros/s/AKfycbwnGciG941ENhDdDSERrCYojp0KIMmL1oV3-JAd2Pi6f0nY0GFEqvFIl2NKx-qi0yJtUA/exec",
        ),
        headers: {"Content-Type": "application/json"},
        body: res,
      );

      if (response.statusCode == 200) {
        appToast("Loggings updated: ${response.body}");
      } else {
        appToast("Error updating loggings: ${response.body}");
      }
    } catch (e) {
      appToast("Exception: $e");
    }
  }

  Future<void> removeEmploye(String employeeName) async {
    final response = await http.post(
      Uri.parse(
        'https://script.google.com/macros/s/AKfycbx0OWMOUG6wiQzkhFkYu1guK2-Xt48ZHAxljJelE-NOcuHq_eKSlA1Ew4AZAEQlwSYLyw/exec',
      ),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": employeeName}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data["success"] == true) {
        print("✅ Updated successfully!");
      } else {
        print("❌ Error: ${data["message"]}");
      }
    } else {
      print("❌ Server error: ${response.statusCode}");
    }
  }
}
