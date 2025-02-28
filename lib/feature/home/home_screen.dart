import 'dart:math';

import 'package:emorald_attendee/feature/home/home_controller.dart';
import 'package:emorald_attendee/models/employe_model.dart';
import 'package:emorald_attendee/repositories/google_sheets_repo.dart';
import 'package:emorald_attendee/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:simple_horizontal_calendar/horizontal_calendar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Employess"),
        actions: [
          IconButton(
            onPressed: () async {
              showAddEmployeeSheet(context);
            },
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
                // Update the selected date
                ref.read(selectedDate.notifier).update((state) => date);
                // No need for ref.refresh here; provider will auto-update
              },
            ),
            sbh(12),

            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final employeeDataAsync = ref.watch(
                    getEmployeeDataFutureProvider,
                  );

                  return employeeDataAsync.when(
                    data: (data) {
                      if (data.isEmpty) {
                        return Center(child: Text("No employees available"));
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return EmployeeCard(employeModel: data[index]);
                        },
                      );
                    },
                    error: (error, stackTrace) {
                      return Center(child: Text("Error: $error"));
                    },
                    loading: () {
                      return Center(child: CircularProgressIndicator());
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showAddEmployeeSheet(BuildContext context) {
    TextEditingController dateController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController checkInController = TextEditingController();
    TextEditingController checkOutController = TextEditingController();

    String selectedStatus = "Present";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows full-screen modal
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
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

              // Date Field
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
                    context: context,
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

              // Employee Name
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Employee Name",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),

              // Check-in Time
              TextField(
                controller: checkInController,
                decoration: InputDecoration(
                  labelText: "Check-in Time",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),

              // Check-out Time
              TextField(
                controller: checkOutController,
                decoration: InputDecoration(
                  labelText: "Check-out Time",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),

              // Status Dropdown
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
                onChanged: (value) {
                  selectedStatus = value!;
                },
              ),
              SizedBox(height: 10),

              SizedBox(height: 10),

              // Submit Button
              ElevatedButton(
                onPressed: () async {
                  // Collect data
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

                  await ref
                      .read(googleSheetsRepoProvider)
                      .addEmployee(employeModel);
                  ref.refresh(getEmployeeDataFutureProvider);

                  Navigator.pop(context); // Close the bottom sheet
                },
                child: Text("Add Employee"),
              ),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}

class EmployeeCard extends ConsumerWidget {
  const EmployeeCard({super.key, required this.employeModel});

  final EmployeModel employeModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String formattedCheckIn = formatApiTime(employeModel.checkIn);
    String formattedCheckOut = formatApiTime(employeModel.checkOut);
    return Slidable(
      closeOnScroll: false,

      // Specify a key if the Slidable is dismissible.
      // key: const ValueKey(0),

      // The start action pane is the one at the left or the top side.
      endActionPane: ActionPane(
        // A motion is a widget used to control how the pane animates.
        motion: const BehindMotion(),
        openThreshold: 0.8,

        // A pane can dismiss the Slidable.

        // All actions are defined in the children parameter.
        children: [
          // A SlidableAction can have an icon and/or a label.
          SlidableAction(
            flex: 1,
            onPressed: (context) async {
              await ref
                  .read(googleSheetsRepoProvider)
                  .removeEmploye(employeModel.employeeName);
            },
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'remove employee',
          ),
          SlidableAction(
            flex: 1,
            onPressed: (context) {
              showDialog(
                context: context,
                builder: (context) {
                  TextEditingController checkInController =
                      TextEditingController();
                  TextEditingController checkOutController =
                      TextEditingController();

                  return AlertDialog(
                    title: Text('Update Logins'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: checkInController,
                          decoration: InputDecoration(
                            labelText: 'Check-in Time',
                          ),
                          keyboardType: TextInputType.datetime,
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: checkOutController,
                          decoration: InputDecoration(
                            labelText: 'Check-out Time',
                          ),
                          keyboardType: TextInputType.datetime,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          String checkIn = checkInController.text;
                          String checkOut = checkOutController.text;

                          if (checkIn.isEmpty || checkOut.isEmpty) {
                            appToast('Please enter both times');

                            return;
                          }

                          // Parse date string to DateTime
                          DateTime parsedDate =
                              DateTime.parse(employeModel.date).toLocal();

                          // Format the date as 'yyyy-MM-dd'
                          final formattedDate = DateFormat(
                            'yyyy-MM-dd',
                          ).format(parsedDate);
                          EmployeModel model = employeModel.copyWith(
                            date: formattedDate,
                            checkIn: checkIn,
                            checkOut: checkOut,
                          );

                          await ref
                              .read(googleSheetsRepoProvider)
                              .updateLoggings(model);

                          Navigator.pop(context);
                          appToast('Login times updated successfully');
                        },
                        child: Text('Update'),
                      ),
                    ],
                  );
                },
              );
            },
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Update Logins',
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(employeModel.employeeName),
            subtitle: Text(
              employeModel.status,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color:
                    employeModel.status == "Present"
                        ? Colors.green
                        : Colors.red,
              ),
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  formattedCheckIn,

                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("-"),
                Text(
                  formattedCheckOut,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
