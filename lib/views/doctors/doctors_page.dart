import 'package:flutter/material.dart';
import '../dashboard/doctor_information_template.dart';

class DoctorsPage extends StatelessWidget {
  const DoctorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doctors')),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your Doctors",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Flexible(
              child: Scrollbar(
                thumbVisibility: true,
                child: ListView(
                  children: const [
                    DoctorInformationTemplate(
                      name: "John Smith",
                      phoneNumber: "555-555-5555",
                      email: "johnsmith@gmail.com",
                      about:
                          "Dr. John Smith is a board-certified cardiologist with over 15 years of experience in diagnosing, treating, and managing a wide range of heart conditions.",
                    ),
                    SizedBox(height: 10),
                    DoctorInformationTemplate(
                      name: "Jane Doe",
                      phoneNumber: "444-444-4444",
                      email: "janedoe@gmail.com",
                      about:
                          "Dr. Jane Doe is a renowned neurologist with expertise in treating complex brain and nerve disorders.",
                    ),
                    SizedBox(height: 10),
                    DoctorInformationTemplate(
                      name: "Jane Doe",
                      phoneNumber: "444-444-4444",
                      email: "janedoe@gmail.com",
                      about:
                          "Dr. Jane Doe is a renowned neurologist with expertise in treating complex brain and nerve disorders.",
                    ),
                    SizedBox(height: 10),
                    DoctorInformationTemplate(
                      name: "Jane Doe",
                      phoneNumber: "444-444-4444",
                      email: "janedoe@gmail.com",
                      about:
                          "Dr. Jane Doe is a renowned neurologist with expertise in treating complex brain and nerve disorders.",
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
