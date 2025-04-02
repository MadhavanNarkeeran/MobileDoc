import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../appointments/appointments_list.dart';
import 'calendar_display.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  Future<String> _fetchUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return "Guest";

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    return doc.data()?['username'] ?? "User";
  }

  String capitalize(String name) {
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder<String>(
              future: _fetchUsername(),
              builder: (context, snapshot) {
                final name = capitalize(snapshot.data ?? "User");
                return Text(
                  "Welcome Back,\n$name!",
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                );
              },
            ),
            const SizedBox(height: 10),
            const Text(
              "Upcoming Appointments",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            CalendarDisplay(),
            const SizedBox(height: 10),
            const AppointmentsList(),
          ],
        ),
      ),
    );
  }
}
