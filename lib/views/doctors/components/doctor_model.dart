class Doctor {
  final String name;
  final String specialization;
  final String phone;
  final String email;
  final String about;

  Doctor({
    required this.name,
    required this.specialization,
    required this.phone,
    required this.email,
    required this.about,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      name: json['name'],
      specialization: json['specialization'],
      phone: json['phone'],
      email: json['email'],
      about: json['about'],
    );
  }
}
