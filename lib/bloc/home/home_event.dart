import 'package:emorald_attendee/models/employe_model.dart';
import 'package:equatable/equatable.dart';

abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object?> get props => [];
}

class FetchEmployeeData extends EmployeeEvent {
  final DateTime date;

  const FetchEmployeeData(this.date);

  @override
  List<Object?> get props => [date];
}

class AddEmployee extends EmployeeEvent {
  final EmployeModel employee;

  const AddEmployee(this.employee);

  @override
  List<Object?> get props => [employee];
}

class UpdateEmployeeLogins extends EmployeeEvent {
  final EmployeModel employee;

  const UpdateEmployeeLogins(this.employee);

  @override
  List<Object?> get props => [employee];
}

class RemoveEmployee extends EmployeeEvent {
  final String employeeName;

  const RemoveEmployee(this.employeeName);

  @override
  List<Object?> get props => [employeeName];
}
