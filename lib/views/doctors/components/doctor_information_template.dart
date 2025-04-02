import 'package:flutter/material.dart';

class DoctorInformationTemplate extends StatelessWidget {
  final String name;
  final String specialization;
  final VoidCallback onTap;

  const DoctorInformationTemplate({
    super.key,
    required this.name,
    required this.specialization,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(40, 0, 0, 0),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 26,
              backgroundImage: AssetImage('assets/doctor_placeholder.png'),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text(specialization,
                    style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
