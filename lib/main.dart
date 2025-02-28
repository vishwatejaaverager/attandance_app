import 'package:emorald_attendee/bloc/home/home_block.dart';
import 'package:emorald_attendee/feature/home/screens/home_screen.dart';
import 'package:emorald_attendee/repositories/google_sheets_repo.dart';
import 'package:emorald_attendee/utils/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Navigation.instance.navigationKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      //provinding dependencies to all the screens
      home: BlocProvider(
        create: (context) => EmployeeBloc(GoogleSheetsRepo()),
        child: HomeScreen(),
      ),
    );
  }
}
