class Patient {
  final String? id; // Firestore Document ID

  final String patientCode;

  final String name;

  final String phone;

  final int age;

  final String gender;

  final String address;

  final DateTime dob;

  final DateTime createdAt;

  const Patient({
    this.id,
    required this.patientCode,
    required this.name,
    required this.phone,
    required this.age,
    required this.gender,
    required this.address,
    required this.dob,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "patientCode": patientCode,
      "name": name,
      "phone": phone,
      "age": age,
      "gender": gender,
      "address": address,
      "dob": dob.toIso8601String(),
      "createdAt": createdAt.toIso8601String(),
    };
  }

  factory Patient.fromMap(
      Map<String, dynamic> map,
      String documentId,
      ) {
    return Patient(
      id: documentId,
      patientCode: map["patientCode"] ?? "",
      name: map["name"] ?? "",
      phone: map["phone"] ?? "",
      age: map["age"] ?? 0,
      gender: map["gender"] ?? "",
      address: map["address"] ?? "",
      dob: DateTime.parse(map["dob"]),
      createdAt: DateTime.parse(map["createdAt"]),
    );
  }

  Patient copyWith({
    String? id,
    String? patientCode,
    String? name,
    String? phone,
    int? age,
    String? gender,
    String? address,
    DateTime? dob,
    DateTime? createdAt,
  }) {
    return Patient(
      id: id ?? this.id,
      patientCode: patientCode ?? this.patientCode,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      dob: dob ?? this.dob,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}