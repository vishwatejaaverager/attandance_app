import 'package:emorald_attendee/bloc/home/home_block.dart';
import 'package:emorald_attendee/bloc/home/home_event.dart';
import 'package:emorald_attendee/models/employe_model.dart';
import 'package:emorald_attendee/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class EmployeeCard extends StatelessWidget {
  const EmployeeCard({super.key, required this.employeModel});

  final EmployeModel employeModel;

  @override
  Widget build(BuildContext context) {
    String formattedCheckIn = formatApiTime(employeModel.checkIn);
    String formattedCheckOut = formatApiTime(employeModel.checkOut);
    return Slidable(
      closeOnScroll: false,
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        openThreshold: 0.8,
        children: [
          SlidableAction(
            flex: 1,
            onPressed: (context) {
              context.read<EmployeeBloc>().add(
                RemoveEmployee(employeModel.employeeName),
              );
            },
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'remove employee',
          ),
          SlidableAction(
            flex: 1,
            onPressed: (slidableContext) {
              // Capture the bloc before showing the dialog
              final employeeBloc = BlocProvider.of<EmployeeBloc>(context);

              showDialog(
                context: context,
                builder: (dialogContext) {
                  TextEditingController checkInController =
                      TextEditingController();
                  TextEditingController checkOutController =
                      TextEditingController();

                  return Builder(
                    builder: (context) {
                      return BlocProvider.value(
                        value: employeeBloc, // Use the captured bloc
                        child: AlertDialog(
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
                              onPressed: () => Navigator.pop(dialogContext),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                String checkIn = checkInController.text;
                                String checkOut = checkOutController.text;

                                if (checkIn.isEmpty || checkOut.isEmpty) {
                                  appToast('Please enter both times');
                                  return;
                                }

                                DateTime parsedDate =
                                    DateTime.parse(employeModel.date).toLocal();
                                final formattedDate = DateFormat(
                                  'yyyy-MM-dd',
                                ).format(parsedDate);
                                EmployeModel model = employeModel.copyWith(
                                  date: formattedDate,
                                  checkIn: checkIn,
                                  checkOut: checkOut,
                                );

                                // Use BlocProvider.of with dialogContext since we've provided the bloc
                                employeeBloc.add(UpdateEmployeeLogins(model));
                                Navigator.pop(dialogContext);
                                appToast('Login times updated successfully');
                              },
                              child: Text('Update'),
                            ),
                          ],
                        ),
                      );
                    },
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
                isMoreThanNineHours(employeModel.checkIn, employeModel.checkOut)
                    ? Text(
                      "Overtime",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                    : SizedBox(),
                Text(
                  formattedCheckOut,
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
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
