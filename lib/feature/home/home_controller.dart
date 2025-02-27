import 'package:emorald_attendee/models/employe_model.dart';
import 'package:emorald_attendee/repositories/google_sheets_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final allEmployess = StateProvider<List<EmployeModel>?>((ref) => []);

final selectedDate = StateProvider<DateTime?>((ref) => DateTime.now());

final getEmployeeDataFutureProvider =
    FutureProvider.autoDispose<List<EmployeModel>>((ref) async {
      final sheetRepo = ref.read(googleSheetsRepoProvider);
      final date = ref.watch(selectedDate);

      // Handle null case

      // Ensure date is always in "yyyy-MM-dd" format
      final formattedDate = DateFormat('yyyy-MM-dd').format(date!);

      print("Fetching data for: $formattedDate");

      final employeeList = await sheetRepo.fetchAttendanceData(formattedDate);

      return employeeList ?? [];
    });
