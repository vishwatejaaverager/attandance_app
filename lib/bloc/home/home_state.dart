import 'package:emorald_attendee/models/employe_model.dart';
import 'package:equatable/equatable.dart';

abstract class EmployeeState extends Equatable {
  final DateTime selectedDate; // Add this as a required field

  const EmployeeState(this.selectedDate);

  @override
  List<Object?> get props => [selectedDate];
}

class EmployeeInitial extends EmployeeState {
  const EmployeeInitial(super.selectedDate);
}

class EmployeeLoading extends EmployeeState {
  const EmployeeLoading(super.selectedDate);
}

class EmployeeLoaded extends EmployeeState {
  final List<EmployeModel> employees;

  const EmployeeLoaded(this.employees, super.selectedDate);

  @override
  List<Object?> get props => [employees, selectedDate];
}

class EmployeeError extends EmployeeState {
  final String message;

  const EmployeeError(this.message, super.selectedDate);

  @override
  List<Object?> get props => [message, selectedDate];
}
