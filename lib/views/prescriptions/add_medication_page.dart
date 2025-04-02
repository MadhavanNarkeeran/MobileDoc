import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddMedicationPage extends StatefulWidget {
  const AddMedicationPage({super.key});

  @override
  AddMedicationPageState createState() => AddMedicationPageState();
}

class AddMedicationPageState extends State<AddMedicationPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _medicationController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _linksController = TextEditingController();

  Future<void> _submitMedication() async {
    if (_formKey.currentState!.validate()) {
      final medication = _medicationController.text;
      final dosage = _dosageController.text;
      final instructions = _instructionsController.text;
      final links = _linksController.text;

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      await FirebaseFirestore.instance.collection('prescriptions').add({
        'userId': user.uid,
        'medication': medication,
        'dosage': dosage,
        'instruction': instructions,
        'links': links,
      });

      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _medicationController.dispose();
    _dosageController.dispose();
    _instructionsController.dispose();
    _linksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Medication")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _medicationController,
                decoration: const InputDecoration(
                  labelText: 'Medication Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the medication name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dosageController,
                decoration: const InputDecoration(
                  labelText: 'Dosage',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the dosage';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _instructionsController,
                decoration: const InputDecoration(
                  labelText: 'Instructions',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter instructions';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _linksController,
                decoration: const InputDecoration(
                  labelText: 'Pharmacy Links',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitMedication,
                child: const Text("Add Medication"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
