import 'package:flutter/material.dart';
import '../../appointments/add_appointments_page.dart';
import '../../appointments/appointments_list.dart';

class DoctorDetailsPage extends StatefulWidget {
  final String doctorId;
  final String name;
  final String phoneNumber;
  final String email;
  final String about;

  const DoctorDetailsPage({
    super.key,
    required this.doctorId,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.about,
  });

  @override
  DoctorDetailsPageState createState() => DoctorDetailsPageState();
}

class DoctorDetailsPageState extends State<DoctorDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dr. ${widget.name}"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/doctor_placeholder.png'),
            ),
            const SizedBox(height: 16),
            Text(
              "Dr. ${widget.name}",
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Phone: ${widget.phoneNumber}"),
            const SizedBox(height: 8),
            Text("Email: ${widget.email}"),
            const SizedBox(height: 16),
            const Text("About",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(widget.about),
            const SizedBox(height: 24),
            const Text("Appointments",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddAppointmentPage(
                      doctorId: widget.doctorId,
                      doctorName: widget.name,
                    ),
                  ),
                );
              },
              child: const Text("Add Appointment"),
            ),
            const SizedBox(height: 20),
            AppointmentsList(doctorName: widget.name),
          ],
        ),
      ),
    );
  }
}
