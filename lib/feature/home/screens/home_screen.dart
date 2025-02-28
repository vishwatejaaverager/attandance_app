import 'dart:math';

import 'package:emorald_attendee/bloc/home/home_block.dart';
import 'package:emorald_attendee/bloc/home/home_event.dart';
import 'package:emorald_attendee/bloc/home/home_state.dart';
import 'package:emorald_attendee/feature/home/screens/employee_card.dart';
import 'package:emorald_attendee/models/employe_model.dart';
import 'package:emorald_attendee/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:simple_horizontal_calendar/horizontal_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // fetch all employess intially
    context.read<EmployeeBloc>().add(FetchEmployeeData(DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeBloc, EmployeeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Employees"),
            actions: [
              IconButton(
                onPressed: () => showAddEmployeeSheet(),
                icon: Icon(Icons.add),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HorizontalCalender(
                  onSelected: (DateTime date) {
                    context.read<EmployeeBloc>().add(FetchEmployeeData(date));
                  },
                ),
                SizedBox(height: 12),
                Expanded(child: _buildEmployeeList(state)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmployeeList(EmployeeState state) {
    if (state is EmployeeLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (state is EmployeeLoaded) {
      if (state.employees.isEmpty) {
        return Center(child: Text("No employees available"));
      }
      return ListView.builder(
        itemCount: state.employees.length,
        itemBuilder: (context, index) {
          return EmployeeCard(employeModel: state.employees[index]);
        },
      );
    } else if (state is EmployeeError) {
      return Center(child: Text("Error: ${state.message}"));
    }
    return Center(child: Text("Press the button to load data"));
  }

  void showAddEmployeeSheet() {
    TextEditingController dateController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController checkInController = TextEditingController();
    TextEditingController checkOutController = TextEditingController();
    String selectedStatus = "Present";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        // Use the bottom sheet's context
        return BlocProvider.value(
          value: BlocProvider.of<EmployeeBloc>(context),
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom + 16,
              top: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Add Employee",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: "Date",
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: bottomSheetContext,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      dateController.text = DateFormat(
                        'yyyy-MM-dd',
                      ).format(pickedDate);
                    }
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Employee Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: checkInController,
                  decoration: InputDecoration(
                    labelText: "Check-in Time",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: checkOutController,
                  decoration: InputDecoration(
                    labelText: "Check-out Time",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  items:
                      ["Present", "Absent", "Leave"].map((String status) {
                        return DropdownMenuItem<String>(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                  decoration: InputDecoration(
                    labelText: "Status",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => selectedStatus = value!,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    String date = dateController.text;
                    String name = nameController.text;
                    String checkIn = checkInController.text;
                    String checkOut = checkOutController.text;

                    if (date.isEmpty ||
                        name.isEmpty ||
                        checkIn.isEmpty ||
                        checkOut.isEmpty) {
                      appToast("Please fill all fields");
                      return;
                    }

                    EmployeModel employeModel = EmployeModel(
                      date: date,
                      employeeName: name,
                      checkIn: checkIn,
                      checkOut: checkOut,
                      status: selectedStatus,
                      working: true,
                    );

                    context.read<EmployeeBloc>().add(
                      AddEmployee(employeModel),
                    ); // Use bottomSheetContext
                    Navigator.pop(bottomSheetContext);
                  },
                  child: Text("Add Employee"),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}
