import 'package:emorald_attendee/bloc/home/home_event.dart';
import 'package:emorald_attendee/bloc/home/home_state.dart';
import 'package:emorald_attendee/repositories/google_sheets_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final GoogleSheetsRepo sheetRepo;

  EmployeeBloc(this.sheetRepo) : super(EmployeeInitial(DateTime.now())) {
    on<FetchEmployeeData>((event, emit) async {
      emit(EmployeeLoading(event.date));
      try {
        final formattedDate = DateFormat('yyyy-MM-dd').format(event.date);
        final employees = await sheetRepo.fetchAttendanceData(formattedDate);
        emit(EmployeeLoaded(employees, event.date));
      } catch (e) {
        emit(EmployeeError("Failed to fetch data: $e", event.date));
      }
    });

    on<AddEmployee>((event, emit) async {
      emit(EmployeeLoading(state.selectedDate));
      try {
        await sheetRepo.addEmployee(event.employee);
        final formattedDate = DateFormat(
          'yyyy-MM-dd',
        ).format(state.selectedDate);
        final employees = await sheetRepo.fetchAttendanceData(formattedDate);
        emit(EmployeeLoaded(employees, state.selectedDate));
      } catch (e) {
        emit(EmployeeError("Failed to add employee: $e", state.selectedDate));
      }
    });

    on<UpdateEmployeeLogins>((event, emit) async {
      emit(EmployeeLoading(state.selectedDate));
      try {
        await sheetRepo.updateLoggings(event.employee);
        final formattedDate = DateFormat(
          'yyyy-MM-dd',
        ).format(state.selectedDate);
        final employees = await sheetRepo.fetchAttendanceData(formattedDate);
        emit(EmployeeLoaded(employees, state.selectedDate));
      } catch (e) {
        emit(EmployeeError("Failed to update logins: $e", state.selectedDate));
      }
    });

    on<RemoveEmployee>((event, emit) async {
      emit(EmployeeLoading(state.selectedDate));
      try {
        await sheetRepo.removeEmploye(event.employeeName);
        final formattedDate = DateFormat(
          'yyyy-MM-dd',
        ).format(state.selectedDate);
        final employees = await sheetRepo.fetchAttendanceData(formattedDate);
        emit(EmployeeLoaded(employees, state.selectedDate));
      } catch (e) {
        emit(
          EmployeeError("Failed to remove employee: $e", state.selectedDate),
        );
      }
    });
  }
}
