import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
      CupertinoPageRoute(
        builder: (_) => DoctorDetailsPage(
            doctorId: docId,
            name: doctor.name,
            phoneNumber: doctor.phone,
            email: doctor.email,
            about: doctor.about),
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

    return CupertinoPageScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fixed Blue Header
          Container(
            padding:
                const EdgeInsets.only(left: 20, right: 20, bottom: 30, top: 60),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: CupertinoColors.activeBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: const Text(
              "Doctors",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          // Title & Add Button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Your Doctors",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (_) => const AddDoctorPage()),
                    );
                  },
                  child: const Icon(CupertinoIcons.add, size: 24),
                ),
              ],
            ),
          ),

          // Scrollable Doctor List
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: StreamBuilder<QuerySnapshot>(
                stream: userDoctorsStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CupertinoActivityIndicator());
                  }

                  final docs = snapshot.data!.docs;
                  if (docs.isEmpty) {
                    return const Center(child: Text("No doctors added yet."));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 20),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final data = doc.data() as Map<String, dynamic>;
                      final doctor = Doctor(
                        name: data['name'] ?? '',
                        specialization: data['specialization'] ?? '',
                        phone: data['phone'] ?? '',
                        email: data['email'] ?? '',
                        about: data['about'] ?? '',
                      );

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Dismissible(
                          key: Key(doc.id),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (direction) async {
                            return await showCupertinoDialog<bool>(
                              context: context,
                              builder: (context) => CupertinoAlertDialog(
                                title: const Text("Confirm Delete"),
                                content: const Text(
                                    "Are you sure you want to delete this doctor?"),
                                actions: [
                                  CupertinoDialogAction(
                                    child: const Text("Cancel"),
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                  ),
                                  CupertinoDialogAction(
                                    isDestructiveAction: true,
                                    child: const Text("Delete"),
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                  ),
                                ],
                              ),
                            );
                          },
                          onDismissed: (direction) => _deleteDoctor(doc.id),
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: const Icon(CupertinoIcons.delete,
                                color: Colors.white),
                          ),
                          child: DoctorInformationTemplate(
                            name: doctor.name,
                            specialization: doctor.specialization,
                            onTap: () => _navigateToDetails(doctor, doc.id),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
