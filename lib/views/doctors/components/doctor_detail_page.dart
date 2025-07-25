import 'package:flutter/material.dart';
import '../../appointments/add_appointments_page.dart';
import '../../appointments/appointments_list.dart';
import 'edit_doctor_page.dart';
import 'doctor_document_uploads.dart';

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
  late String _name;
  late String _phoneNumber;
  late String _email;
  late String _about;

  @override
  void initState() {
    super.initState();
    _name = widget.name;
    _phoneNumber = widget.phoneNumber;
    _email = widget.email;
    _about = widget.about;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dr. $_name"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Doctor',
            onPressed: () async {
              final updated = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditDoctorPage(
                    doctorId: widget.doctorId,
                    name: _name,
                    phoneNumber: _phoneNumber,
                    email: _email,
                    about: _about,
                  ),
                ),
              );

              if (updated != null && mounted) {
                setState(() {
                  _name = updated['name'] ?? _name;
                  _phoneNumber = updated['phoneNumber'] ?? _phoneNumber;
                  _email = updated['email'] ?? _email;
                  _about = updated['about'] ?? _about;
                });
              }
            },
          ),
        ],
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
              "Dr. $_name",
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Phone: $_phoneNumber"),
            const SizedBox(height: 8),
            Text("Email: $_email"),
            const SizedBox(height: 16),
            const Text("About",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(_about),
            const SizedBox(height: 24),
            const Text("Document Uploads",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DoctorDocumentUploads(doctorId: widget.doctorId),
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
                      doctorName: _name,
                    ),
                  ),
                );
              },
              child: const Text("Add Appointment"),
            ),
            const SizedBox(height: 20),
            AppointmentsList(doctorName: _name),
          ],
        ),
      ),
    );
  }
}
