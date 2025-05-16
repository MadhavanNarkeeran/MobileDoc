import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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

  File? _prescriptionImage;
  final ImagePicker _picker = ImagePicker();
  bool _uploading = false;
  String? _uploadError;

  Future<void> _pickPrescriptionImage(ImageSource source) async {
    setState(() { _uploadError = null; _uploading = true; });
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile == null) {
        setState(() { _uploading = false; });
        return;
      }
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String dirPath = '${appDocDir.path}/prescription_images';
      await Directory(dirPath).create(recursive: true);
      final String fileName = 'presc_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String savePath = '$dirPath/$fileName';
      final File savedImage = await File(pickedFile.path).copy(savePath);
      setState(() {
        _prescriptionImage = savedImage;
      });
    } catch (e) {
      setState(() { _uploadError = 'Image pick failed: $e'; });
    } finally {
      setState(() { _uploading = false; });
    }
  }

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
        'imagePath': _prescriptionImage?.path ?? '',
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
              if (_prescriptionImage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(_prescriptionImage!, height: 120, fit: BoxFit.cover),
                  ),
                ),
              if (_uploadError != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(_uploadError!, style: const TextStyle(color: Colors.red)),
                ),
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                    onPressed: _uploading ? null : () => _pickPrescriptionImage(ImageSource.camera),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                    onPressed: _uploading ? null : () => _pickPrescriptionImage(ImageSource.gallery),
                  ),
                ],
              ),
              const SizedBox(height: 16),
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
