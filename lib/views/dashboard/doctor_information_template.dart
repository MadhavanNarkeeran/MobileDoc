import 'package:flutter/material.dart';

class DoctorInformationTemplate extends StatelessWidget {
  final String name;
  final String phoneNumber;
  final String email;
  final String about;
  const DoctorInformationTemplate({super.key, required this.name, required this.phoneNumber, required this.email, required this.about});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2)
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              )
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Phone Number",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                  )
                ),
                Text(phoneNumber),
                const SizedBox(height: 10),
                const Text(
                  "Email",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                  )
                ),
                Text(email),
                const SizedBox(height: 10),
                const Text(
                  "About",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                  )
                ),
                Text(
                  about,
                  textAlign: TextAlign.center
                )
              ]
            )
          ]
        )
      )
    );
  }
}