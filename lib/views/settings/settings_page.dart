import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // For AssetImage and Icon
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/auth_service.dart';
import '../auth/welcome_page.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Blue Title Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
            decoration: const BoxDecoration(
              color: CupertinoColors.activeBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: const Text(
              'Settings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Content
          Expanded(
            child: currentUser == null
                ? const Center(child: Text("Not logged in"))
                : FutureBuilder<Map<String, dynamic>?> (
                    future: _getUserData(currentUser!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CupertinoActivityIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data == null) {
                        return const Center(child: Text("No user data found"));
                      }

                      final userData = snapshot.data!;
                      final username = _capitalize(userData['username'] ?? 'N/A');
                      final email = currentUser!.email ?? 'No email';

                      return Column(
                        children: [
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: CupertinoColors.systemGrey6,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  radius: 35,
                                  backgroundImage:
                                      AssetImage('assets/profile_placeholder.png'),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      username,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      email,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: CupertinoColors.systemGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 30),
                          CupertinoListSection.insetGrouped(
                            header: const Text('Account Settings'),
                            children: const [
                              CupertinoListTile(
                                leading: Icon(CupertinoIcons.person),
                                title: Text("Edit Profile"),
                                trailing: Icon(CupertinoIcons.forward),
                              ),
                              CupertinoListTile(
                                leading: Icon(CupertinoIcons.lock),
                                title: Text("Change Password"),
                                trailing: Icon(CupertinoIcons.forward),
                              ),
                            ],
                          ),

                          CupertinoListSection.insetGrouped(
                            header: const Text('Health Info'),
                            children: const [
                              CupertinoListTile(
                                leading: Icon(CupertinoIcons.heart),
                                title: Text("Medical Records"),
                                trailing: Icon(CupertinoIcons.forward),
                              ),
                              CupertinoListTile(
                                leading: Icon(CupertinoIcons.bandage),
                                title: Text("Allergies"),
                                trailing: Icon(CupertinoIcons.forward),
                              ),
                              CupertinoListTile(
                                leading: Icon(CupertinoIcons.info),
                                title: Text("Emergency Contacts"),
                                trailing: Icon(CupertinoIcons.forward),
                              ),
                            ],
                          ),

                          const Spacer(),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: CupertinoButton(
                              color: CupertinoColors.systemRed,
                              borderRadius: BorderRadius.circular(10),
                              onPressed: () async {
                                await AuthService().signOut();
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (_) => const WelcomePage()),
                                  (route) => false,
                                );
                              },
                              child: const Text("Log Out"),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    },
                  ),
          ),
        ],
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