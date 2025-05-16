import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // For AssetImage and Icon
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/auth_service.dart';
import '../auth/welcome_page.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  File? _insuranceCardImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadInsuranceCardFromStorage();
  }

  Future<void> _loadInsuranceCardFromStorage() async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String path = '${appDocDir.path}/insurance_card.jpg';
    final File file = File(path);
    if (await file.exists()) {
      setState(() {
        _insuranceCardImage = file;
      });
    }
  }

  Future<void> _pickInsuranceCard() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
    );
    if (image != null) {
      await _saveInsuranceCardToStorage(File(image.path));
    }
  }


  Future<void> _deleteInsuranceCardImage() async {
    try {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String path = '${appDocDir.path}/insurance_card.jpg';
      final File file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
      setState(() {
        _insuranceCardImage = null;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Insurance card image deleted.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete image: $e')),
        );
      }
    }
  }

  Future<void> _saveInsuranceCardToStorage(File imageFile) async {
    try {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String savePath = '${appDocDir.path}/insurance_card.jpg';
      final File savedImage = await imageFile.copy(savePath);
      setState(() {
        _insuranceCardImage = savedImage;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Insurance card saved to device storage.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save image: $e')),
        );
      }
    }
  }

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
                : FutureBuilder<Map<String, dynamic>?>(
                    future: _getUserData(currentUser!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CupertinoActivityIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data == null) {
                        return const Center(child: Text("No user data found"));
                      }

                      final userData = snapshot.data!;
                      final username =
                          _capitalize(userData['username'] ?? 'N/A');
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
                                  // ignore: deprecated_member_use
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
                                  backgroundImage: AssetImage(
                                      'assets/profile_placeholder.png'),
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
                          const SizedBox(height: 20),
                          // Insurance Card Upload Section
                          Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: CupertinoColors.systemGrey6,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Insurance Card',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                _insuranceCardImage != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          _insuranceCardImage!,
                                          width: 200,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : const Text('No insurance card uploaded.'),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    CupertinoButton(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      color: CupertinoColors.activeBlue,
                                      onPressed: _pickInsuranceCard,
                                      child: const Text('Scan Card'),
                                    ),
                                    const SizedBox(width: 10),
                                    CupertinoButton(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      color: CupertinoColors.systemRed,
                                      onPressed:
                                          _insuranceCardImage != null ? _deleteInsuranceCardImage : null,
                                      child: const Text('Delete Image'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: CupertinoButton(
                              color: CupertinoColors.systemRed,
                              borderRadius: BorderRadius.circular(10),
                              onPressed: () async {
                                await AuthService().signOut();
                                Navigator.pushAndRemoveUntil(
                                  // ignore: use_build_context_synchronously
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
