import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddDoctorPage extends StatefulWidget {
  const AddDoctorPage({super.key});

  @override
  AddDoctorPageState createState() => AddDoctorPageState();
}

class AddDoctorPageState extends State<AddDoctorPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _specializationController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();

  final CollectionReference doctorsCollection =
      FirebaseFirestore.instance.collection('doctors');

  Future<void> _submitDoctor() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (_formKey.currentState!.validate()) {
      final doctorData = {
        'userId': user.uid,
        'name': _nameController.text.trim(),
        'specialization': _specializationController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
        'about': _aboutController.text.trim(),
      };

      await doctorsCollection.add(doctorData);

      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specializationController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Doctor")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Please enter a name'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _specializationController,
                decoration: const InputDecoration(
                  labelText: 'Specialization',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Please enter a specialization'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _aboutController,
                decoration: const InputDecoration(
                  labelText: 'About',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Please enter some information about the doctor'
                    : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitDoctor,
                child: const Text("Add Doctor"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
