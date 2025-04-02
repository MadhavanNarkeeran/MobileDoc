import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'medication_tile.dart';
import 'add_medication_page.dart';

class PrescriptionsPage extends StatelessWidget {
  const PrescriptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text("Log in to see your prescriptions."));
    }

    Query query = FirebaseFirestore.instance
        .collection('prescriptions')
        .where('userId', isEqualTo: user.uid)
        .orderBy('medication');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescriptions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AddMedicationPage()));
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: query.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text("No medications added."));
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final doc = docs[index];
                        final data = doc.data() as Map<String, dynamic>;
                        return MedicationTile(
                          docId: doc.id,
                          medication: data['medication'] ?? 'No name',
                          dosage: data['dosage'] ?? 'No dosage',
                          instruction: data['instruction'] ?? '',
                          links: data['links'] ?? '',
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
