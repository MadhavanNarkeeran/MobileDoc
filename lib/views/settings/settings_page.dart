import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: currentUser == null
          ? const Center(child: Text("Not logged in"))
          : FutureBuilder<Map<String, dynamic>?>(
              future: _getUserData(currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text("No user data found"));
                }

                final userData = snapshot.data!;
                final username = _capitalize(userData['username'] ?? 'N/A');
                final email = currentUser!.email ?? 'No email';

                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            AssetImage('assets/profile_placeholder.png'),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        username,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 30),
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: const Text(
                          "Log Out",
                          style: TextStyle(color: Colors.red),
                        ),
                        onTap: () async {
                          await AuthService().signOut();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Future<Map<String, dynamic>?> _getUserData(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc.exists ? doc.data() : null;
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}
