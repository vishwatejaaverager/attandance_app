class EmployeModel {
  final String date;
  final String employeeName;
  final String checkIn;
  final String checkOut;
  final String status;
  final bool working;

  EmployeModel({
    required this.date,
    required this.employeeName,
    required this.checkIn,
    required this.checkOut,
    required this.status,
    required this.working,
  });

  // Factory constructor to create an instance from JSON
  factory EmployeModel.fromJson(Map<String, dynamic> json) {
    return EmployeModel(
      date: json['Date'] as String,
      employeeName: json['Employee Name'] as String,
      checkIn: json['Check-in'] as String,
      checkOut: json['Check-out'] as String,
      status: json['Status'] as String,
      working: json['working'] as bool,
    );
  }

  // Method to convert instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'Date': date,
      'Employee Name': employeeName,
      'Check-in': checkIn,
      'Check-out': checkOut,
      'Status': status,
      'working': working,
    };
  }

  // Copy method to create a new instance with modified fields
  EmployeModel copyWith({
    String? date,
    String? employeeName,
    String? checkIn,
    String? checkOut,
    String? status,
    bool? working,
  }) {
    return EmployeModel(
      date: date ?? this.date,
      employeeName: employeeName ?? this.employeeName,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      status: status ?? this.status,
      working: working ?? this.working,
    );
  }

  // Override toString for debugging
  @override
  String toString() {
    return 'EmployeModel(date: $date, employeeName: $employeeName, checkIn: $checkIn, checkOut: $checkOut, status: $status, working: $working)';
  }
}
