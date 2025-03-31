import 'package:flutter/material.dart';
import 'doctor_information_template.dart';

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
            padding: EdgeInsets.all(30),
            child: Center(
              child: Column(
                children: [
                  const Text(
                    "Your Doctors",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                    )
                  ),
                  const SizedBox(height: 10),
                  const DoctorInformationTemplate(
                    name: "John Smith", 
                    phoneNumber: "555-555-5555",
                    email: "johnsmith@gmail.com",
                    about: "Dr. John Smith is a board-certified cardiologist with over 15 years of experience in diagnosing, treating, and managing a wide range of heart conditions."
                  ),
                  const SizedBox(height: 10),
                  const DoctorInformationTemplate(
                    name: "John Smith", 
                    phoneNumber: "555-555-5555",
                    email: "johnsmith@gmail.com",
                    about: "Dr. John Smith is a board-certified cardiologist with over 15 years of experience in diagnosing, treating, and managing a wide range of heart conditions."
                  ),
                  const SizedBox(height: 10),
                  const DoctorInformationTemplate(
                    name: "John Smith", 
                    phoneNumber: "555-555-5555",
                    email: "johnsmith@gmail.com",
                    about: "Dr. John Smith is a board-certified cardiologist with over 15 years of experience in diagnosing, treating, and managing a wide range of heart conditions."
                  ),
                  const SizedBox(height: 10),
                  const DoctorInformationTemplate(
                    name: "John Smith", 
                    phoneNumber: "555-555-5555",
                    email: "johnsmith@gmail.com",
                    about: "Dr. John Smith is a board-certified cardiologist with over 15 years of experience in diagnosing, treating, and managing a wide range of heart conditions."
                  ),
                  const SizedBox(height: 10),
                  const DoctorInformationTemplate(
                    name: "John Smith", 
                    phoneNumber: "555-555-5555",
                    email: "johnsmith@gmail.com",
                    about: "Dr. John Smith is a board-certified cardiologist with over 15 years of experience in diagnosing, treating, and managing a wide range of heart conditions."
                  )
                ]
              )
            )
          )
        )
      )
    );
  }
}