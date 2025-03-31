import 'package:flutter/material.dart';

class DoctorInformationTemplate extends StatelessWidget {
  final String name;
  final String phoneNumber;
  final String email;
  final String about;
  const DoctorInformationTemplate(
      {super.key,
      required this.name,
      required this.phoneNumber,
      required this.email,
      required this.about});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 350,
        height: 280,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(117, 158, 158, 158),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(children: [
              Text(name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                const Text("Phone Number",
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text(phoneNumber),
                const SizedBox(height: 10),
                const Text("Email",
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text(email),
                const SizedBox(height: 10),
                const Text("About",
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text(about, textAlign: TextAlign.center)
              ])
            ])));
  }
}
