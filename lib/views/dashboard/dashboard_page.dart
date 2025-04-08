import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../appointments/appointments_list.dart';
import 'calendar_display.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  Stream<DocumentSnapshot<Map<String, dynamic>>> get userDocStream {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Return an empty stream to avoid null issues
      return const Stream.empty();
    }
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots();
  }

  String capitalize(String name) {
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fixed Blue Header
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.only(top: 60, bottom: 30, left: 20, right: 20),
            decoration: const BoxDecoration(
              color: CupertinoColors.activeBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: const Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.white,
              ),
            ),
          ),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: userDocStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CupertinoActivityIndicator();
                      }

                      final data = snapshot.data!.data();
                      final username = data?['username'] ?? 'User';
                      final capitalized = capitalize(username);

                      return Text(
                        "Welcome back, $capitalized!",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Upcoming Appointments",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const CalendarDisplay(),
                  const SizedBox(height: 20),
                  const AppointmentsList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
