import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'components/add_doctor.dart';
import 'components/doctor_detail_page.dart';
import 'components/doctor_information_template.dart';
import 'components/doctor_model.dart';

class DoctorsPage extends StatefulWidget {
  const DoctorsPage({super.key});

  @override
  State<DoctorsPage> createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  final CollectionReference doctorsCollection =
      FirebaseFirestore.instance.collection('doctors');

  void _deleteDoctor(String id) async {
    await doctorsCollection.doc(id).delete();
  }

  void _navigateToDetails(Doctor doctor, String docId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DoctorDetailsPage(
          doctorId: docId,
          name: doctor.name,
          phoneNumber: doctor.phone,
          email: doctor.email,
          about: doctor.about,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text("Please log in to view doctors."));
    }

    final userDoctorsStream = doctorsCollection
        .where('userId', isEqualTo: user.uid)
        .orderBy('name')
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Doctors',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddDoctorPage()),
              );
            },
          ),
        ],
      ),
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
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: userDoctorsStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;
                  if (docs.isEmpty) {
                    return const Center(child: Text("No doctors added yet."));
                  }

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final docData =
                          docs[index].data() as Map<String, dynamic>;
                      final doctor = Doctor(
                        name: docData['name'] ?? '',
                        specialization: docData['specialization'] ?? '',
                        phone: docData['phone'] ?? '',
                        email: docData['email'] ?? '',
                        about: docData['about'] ?? '',
                      );

                      return Dismissible(
                        key: Key(docs[index].id),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (direction) async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Confirm Delete"),
                                content: const Text(
                                    "Are you sure you want to delete this doctor?"),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text("Delete"),
                                  ),
                                ],
                              );
                            },
                          );
                          return confirm;
                        },
                        onDismissed: (direction) =>
                            _deleteDoctor(docs[index].id),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: DoctorInformationTemplate(
                          name: doctor.name,
                          specialization: doctor.specialization,
                          onTap: () =>
                              _navigateToDetails(doctor, docs[index].id),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
