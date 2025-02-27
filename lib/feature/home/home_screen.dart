import 'dart:math';

import 'package:emorald_attendee/feature/home/home_controller.dart';
import 'package:emorald_attendee/models/employe_model.dart';
import 'package:emorald_attendee/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sbh(36),
            HorizontalCalender(
              onSelected: (DateTime date) {
                // Update the selected date
                ref.read(selectedDate.notifier).update((state) => date);
                // No need for ref.refresh here; provider will auto-update
              },
            ),
            sbh(12),
            Text("All Employees", style: TextStyle(fontSize: 18)),
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
}

class EmployeeCard extends StatelessWidget {
  const EmployeeCard({super.key, required this.employeModel});

  final EmployeModel employeModel;

  @override
  Widget build(BuildContext context) {
    String formattedCheckIn = formatApiTime(employeModel.checkIn);
    String formattedCheckOut = formatApiTime(employeModel.checkOut);
    return Column(
      children: [
        ListTile(
          title: Text(employeModel.employeeName),
          subtitle: Text(
            employeModel.status,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color:
                  employeModel.status == "Present" ? Colors.green : Colors.red,
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
    );
  }
}
