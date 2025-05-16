import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class MedicationTile extends StatelessWidget {
  final String docId;
  final String medication;
  final String dosage;
  final String instruction;
  final String links;
  final String? imagePath;

  const MedicationTile({
    super.key,
    required this.docId,
    required this.medication,
    required this.dosage,
    required this.instruction,
    required this.links,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(docId),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Confirm Delete"),
              content: const Text(
                  "Are you sure you want to delete this medication?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Delete"),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) async {
        await FirebaseFirestore.instance
            .collection('prescriptions')
            .doc(docId)
            .delete();
      },
      background: Container(
        color: const Color.fromARGB(255, 54, 171, 244),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ExpansionTile(
          leading: const CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage('assets/medication_placeholder.png'),
          ),
          title: Text(
            medication,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            dosage,
            style: const TextStyle(fontSize: 12),
          ),
          children: [
            if (imagePath != null && imagePath!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(imagePath!),
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Instructions: $instruction",
                      style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 8),
                  Text("Pharmacy Links: $links",
                      style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
