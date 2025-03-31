import 'package:flutter/material.dart';
import 'calendar_display.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Dashboard')),
        body: Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Center(
                        child: Column(children: [
                      const Text(
                        "Welcome Back!\nMadhavan Narkeeran",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      const Text("Upcoming Appointments",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      const CalendarDisplay(),
                    ]))))));
  }
}
