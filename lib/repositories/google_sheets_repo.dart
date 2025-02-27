import 'package:emorald_attendee/models/employe_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final googleSheetsRepoProvider = Provider((ref) => GoogleSheetsRepo());

class GoogleSheetsRepo {
  final String apiUrl =
      'https://script.google.com/macros/s/AKfycbzvm2f88w8mXrhhao8NqDZMCpf95ylJQpMIQM7z6pulFydWeanHPTkeo4Mxosr6EHru1Q/exec';

  Future<List<EmployeModel>> fetchAttendanceData(String datenow) async {
    try {
      print("API call for: $datenow");

      final response = await http.get(
        Uri.parse(
          'https://script.google.com/macros/s/AKfycbzmaYp_Xn-croZmhEgCqKpfnI3n63lpxFzxq8BGVfR-kud8kSgMc86apbpBPB9CKa373Q/exec?date=$datenow',
        ),
      );
      // print("Raw Response: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        // print("Decoded JSON: $jsonData"); // Debugging

        if (jsonData is List) {
          final data =
              jsonData.map((item) => EmployeModel.fromJson(item)).toList();
          // print("Parsed Employee Data: ${data.first.date}");

          return data.isEmpty ? _generateDefaultData(datenow) : data;
        } else {
          throw Exception("Unexpected JSON structure: $jsonData");
        }
      } else {
        throw Exception('HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  List<EmployeModel> _generateDefaultData(String date) {
    print("using default");
    const employees = [
      'John Doe',
      'Jane Smith',
      'Alex Brown',
      'Emily Davis',
      'Michael Lee',
      'Sarah Wilson',
      'David Kim',
      'Laura Adams',
      'Chris Evans',
      'Anna Taylor',
    ];
    return employees
        .map(
          (name) => EmployeModel(
            date: date,
            employeeName: name,
            checkIn: '9:00 AM',
            checkOut: '6:00 PM',
            status: 'Present',
          ),
        )
        .toList();
  }
}
