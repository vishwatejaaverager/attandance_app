class EmployeModel {
  final String date;
  final String employeeName;
  final String checkIn;
  final String checkOut;
  final String status;

  EmployeModel({
    required this.date,
    required this.employeeName,
    required this.checkIn,
    required this.checkOut,
    required this.status,
  });

  // Factory constructor to create an instance from JSON
  factory EmployeModel.fromJson(Map<String, dynamic> json) {
    return EmployeModel(
      date: json['Date'] as String,
      employeeName: json['Employee Name'] as String,
      checkIn: json['Check-in'] as String,
      checkOut: json['Check-out'] as String,
      status: json['Status'] as String,
    );
  }

  // Method to convert instance back to JSON (for writing data if needed)
  Map<String, dynamic> toJson() {
    return {
      'Date': date,
      'Employee Name': employeeName,
      'Check-in': checkIn,
      'Check-out': checkOut,
      'Status': status,
    };
  }

  // Optional: Override toString for debugging
  @override
  String toString() {
    return 'EmployeModel(date: $date, employeeName: $employeeName, checkIn: $checkIn, checkOut: $checkOut, status: $status)';
  }
}
