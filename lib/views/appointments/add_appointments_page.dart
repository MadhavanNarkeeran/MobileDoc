import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AddAppointmentPage extends StatefulWidget {
  final String doctorId;
  final String doctorName;

  const AddAppointmentPage({
    super.key,
    required this.doctorId,
    required this.doctorName,
  });

  @override
  AddAppointmentPageState createState() => AddAppointmentPageState();
}

class AddAppointmentPageState extends State<AddAppointmentPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TextEditingController _notesController = TextEditingController();

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _selectedTime != null) {

      final DateTime appointmentDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      final DateTime appointmentEndTime =
          appointmentDateTime.add(const Duration(minutes: 30));

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      Map<String, dynamic> appointmentData = {
        'userId': user.uid,
        'doctorId': widget.doctorId,
        'doctorName': widget.doctorName,
        'startTime': appointmentDateTime.toIso8601String(),
        'endTime': appointmentEndTime.toIso8601String(),
        'notes': _notesController.text,
      };

 
      await FirebaseFirestore.instance
          .collection('appointments')
          .add(appointmentData);

      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    String dateText = _selectedDate != null
        ? DateFormat.yMd().format(_selectedDate!)
        : 'Select Date';
    String timeText =
        _selectedTime != null ? _selectedTime!.format(context) : 'Select Time';

    return Scaffold(
      appBar: AppBar(title: const Text("Add Appointment")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ListTile(
                title: Text(dateText),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),
              ListTile(
                title: Text(timeText),
                trailing: const Icon(Icons.access_time),
                onTap: _pickTime,
              ),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text("Add Appointment"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
