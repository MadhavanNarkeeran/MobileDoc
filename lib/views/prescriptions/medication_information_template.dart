import 'package:flutter/material.dart';

class MedicationInformationTemplate extends StatelessWidget {
  final String medication;
  final String dosage;
  final String instruction;
  final String links;
  const MedicationInformationTemplate(
      {super.key,
      required this.medication,
      required this.dosage,
      required this.instruction,
      required this.links});

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
              Text(medication,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                const Text("Dosage",
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text(dosage),
                const SizedBox(height: 10),
                const Text("Additional Instructions",
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text(instruction),
                const SizedBox(height: 10),
                const Text("Links to Pharmacy Options",
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text(links, textAlign: TextAlign.center)
              ])
            ])));
  }
}
