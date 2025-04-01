import 'package:flutter/material.dart';
import 'medication_information_template.dart';

class PrescriptionsPage extends StatelessWidget {
  const PrescriptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prescriptions')),
      body: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const Text(
                  "Your Medications",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const MedicationInformationTemplate(
                  medication: "Tylenol", 
                  dosage: "500 mg every 4-6 hours as needed", 
                  instruction: "Take with a full glass of water. Ensure you avoid alcohol during use.", 
                  links: "cvs.com"
                ),
                SizedBox(height: 10),
                const MedicationInformationTemplate(
                  medication: "Tylenol", 
                  dosage: "500 mg every 4-6 hours as needed", 
                  instruction: "Take with a full glass of water. Ensure you avoid alcohol during use.", 
                  links: "cvs.com"
                ),
                SizedBox(height: 10),
                const MedicationInformationTemplate(
                  medication: "Tylenol", 
                  dosage: "500 mg every 4-6 hours as needed", 
                  instruction: "Take with a full glass of water. Ensure you avoid alcohol during use.", 
                  links: "cvs.com"
                ),
                SizedBox(height: 10),
                const MedicationInformationTemplate(
                  medication: "Tylenol", 
                  dosage: "500 mg every 4-6 hours as needed", 
                  instruction: "Take with a full glass of water. Ensure you avoid alcohol during use.", 
                  links: "cvs.com"
                ),
                SizedBox(height: 10)
              ]
            ),
          )
        )
      )
    );
  }
}
