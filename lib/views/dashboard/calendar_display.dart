import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarDisplay extends StatelessWidget {
  const CalendarDisplay({super.key});

  List<Appointment> _getAppointments(List<DocumentSnapshot> docs) {
    List<Appointment> appointments = [];
    for (var doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      DateTime startTime = DateTime.parse(data['startTime']);
      DateTime endTime = DateTime.parse(data['endTime']);
      String subject = "Dr. ${data['doctorName']} Appointment";
      appointments.add(Appointment(
        startTime: startTime,
        endTime: endTime,
        subject: subject,
        color: Colors.blue,
      ));
    }
    return appointments;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text("Log in to view calendar."));
    }
    return SizedBox(
      width: 350,
      height: 350,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('userId', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;
          final appointments = _getAppointments(docs);
          return SfCalendar(
            view: CalendarView.month,
            dataSource: AppointmentDataSource(appointments),
          );
        },
      ),
    );
  }
}

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
